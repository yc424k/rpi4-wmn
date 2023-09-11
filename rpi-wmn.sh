#!/bin/bash

# 인자의 개수 확인
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <mesh_name> <ip_address>"
    exit 1
fi

MESH_NAME=$1
IP_ADDRESS=$2

# rpi_mesh.sh 파일 생성 및 내용 쓰기
cat <<EOL > /usr/local/bin/rpi_mesh.sh
#!/bin/bash

# 인자의 개수 확인
if [ "\$#" -ne 2 ]; then
    echo "Usage: \$0 <mesh_name> <ip_address>"
    exit 1
fi

MESH_NAME=\$1
IP_ADDRESS=\$2
FREQUENCY=2437

ifconfig wlan1 down
iw wlan1 set type mp
ifconfig wlan1 up
iw wlan1 mesh join \$MESH_NAME freq \$FREQUENCY
ifconfig wlan1 \$IP_ADDRESS/24
EOL

# rpi_mesh.sh 파일 실행 권한 부여
chmod +x /usr/local/bin/rpi_mesh.sh

# /etc/rc.local 파일에 rpi_mesh.sh 실행 코드 추가
if ! grep -q "/usr/local/bin/rpi_mesh.sh" /etc/rc.local; then
    sed -i "s/^exit 0/\/usr\/local\/bin\/rpi_mesh.sh $MESH_NAME $IP_ADDRESS\n\nexit 0/" /etc/rc.local
fi

echo "Setup complete."