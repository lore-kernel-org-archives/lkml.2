Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab0LHTqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:46:22 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:61414 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab0LHTqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:46:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DLuDhfxrJNNxmGRdIejmXgbIc5OB/HfMJANxHccJLVrTt4PuiE8mJONK9x+35WRh7k
         sTYYek1DaNCSmKDkkeBp0ltKMmhlZRsW4hKOE0JnD5lNcRUtDHvZlgaQMwychJeYTOs9
         n/GgOJJtUdn2lpGBjHQMYFKeUBIBjFCq1XXxQ=
From: Igor Plyatov <plyatov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@maxim.org.za,
        nicolas.ferre@atmel.com, linux@arm.linux.org.uk,
        costa.antonior@gmail.com, plagnioj@jcrosoft.com, ryan@bluewatersys.com,
        christian.glindkamp@taskit.de, pgsellmann@portner-elektronik.at,
        Igor Plyatov <plyatov@gmail.com>
Subject: [PATCH v3] mach-at91: Support for gms board added
Date: Wed,  8 Dec 2010 22:45:52 +0300
Message-Id: <1291837552-8389-1-git-send-email-plyatov@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code for the Stamp9G20 SoM separated into the board-stamp9g20.c, and following
files correspond to carrier boards for Stamp9G20:
* carrier-board-gms.c - "GMS", Seismograph from GeoSIG.
* carrier-board-panelcardevb.c - "Panel Card EVB", Taskit's eval. board.
* carrier-board-portuxg20.c - "Portux G20", derivative from Stamp9G20.
* carrier-board-pcontrol_g20.c - "Pcontrol G20", PORTNER-Elektronik.
.
All stuff specific to carrier board encapsulated into functions:
* carrier_board_map_io()
* carrier_board_init()
which used in the board-stamp9g20.c
.
There is only one choice for Stamp9G20 carrier board from:
* CONFIG_CARRIERBOARD_GMS
* CONFIG_CARRIERBOARD_PANELCARDEVB
* CONFIG_CARRIERBOARD_PCONTROL_G20
* CONFIG_CARRIERBOARD_PORTUXG20

Signed-off-by: Igor Plyatov <plyatov@gmail.com>
---
 arch/arm/configs/gms_defconfig                  |  148 ++++++
 arch/arm/configs/pcontrol_g20_defconfig         |    3 +-
 arch/arm/configs/portuxg20_defconfig            |  129 ++++++
 arch/arm/configs/stamp9g20_defconfig            |    2 +-
 arch/arm/mach-at91/Kconfig                      |   46 ++-
 arch/arm/mach-at91/Makefile                     |    8 +-
 arch/arm/mach-at91/board-pcontrol-g20.c         |  322 -------------
 arch/arm/mach-at91/board-stamp9g20.c            |  201 +-------
 arch/arm/mach-at91/carrier-board-gms.c          |  556 +++++++++++++++++++++++
 arch/arm/mach-at91/carrier-board-panelcardevb.c |   96 ++++
 arch/arm/mach-at91/carrier-board-pcontrol-g20.c |  208 +++++++++
 arch/arm/mach-at91/carrier-board-portuxg20.c    |  121 +++++
 arch/arm/mach-at91/generic.h                    |    3 +
 arch/arm/mach-at91/include/mach/gms.h           |   33 ++
 14 files changed, 1366 insertions(+), 510 deletions(-)
 create mode 100644 arch/arm/configs/gms_defconfig
 create mode 100644 arch/arm/configs/portuxg20_defconfig
 delete mode 100644 arch/arm/mach-at91/board-pcontrol-g20.c
 create mode 100644 arch/arm/mach-at91/carrier-board-gms.c
 create mode 100644 arch/arm/mach-at91/carrier-board-panelcardevb.c
 create mode 100644 arch/arm/mach-at91/carrier-board-pcontrol-g20.c
 create mode 100644 arch/arm/mach-at91/carrier-board-portuxg20.c
 create mode 100644 arch/arm/mach-at91/include/mach/gms.h

diff --git a/arch/arm/configs/gms_defconfig b/arch/arm/configs/gms_defconfig
new file mode 100644
index 0000000..278400a
--- /dev/null
+++ b/arch/arm/configs/gms_defconfig
@@ -0,0 +1,148 @@
+CONFIG_EXPERIMENTAL=y
+CONFIG_SYSVIPC=y
+CONFIG_LOG_BUF_SHIFT=14
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_SLAB=y
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+CONFIG_ARCH_AT91=y
+CONFIG_ARCH_AT91SAM9G20=y
+CONFIG_MACH_STAMP9G20=y
+CONFIG_CARRIERBOARD_GMS=y
+CONFIG_AT91_PROGRAMMABLE_CLOCKS=y
+CONFIG_AT91_SLOW_CLOCK=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_PREEMPT=y
+CONFIG_AEABI=y
+CONFIG_ZBOOT_ROM_TEXT=0x0
+CONFIG_ZBOOT_ROM_BSS=0x0
+CONFIG_CMDLINE="mem=64M console=ttyS0,115200 initrd=0x21100000,3145728 root=/dev/ram0 rw"
+CONFIG_KEXEC=y
+CONFIG_CPU_IDLE=y
+CONFIG_PM=y
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_INET=y
+CONFIG_NETFILTER=y
+CONFIG_NETFILTER_NETLINK_LOG=m
+CONFIG_NF_CONNTRACK=m
+CONFIG_NF_CT_PROTO_SCTP=m
+CONFIG_NF_CT_PROTO_UDPLITE=m
+CONFIG_NF_CONNTRACK_FTP=m
+CONFIG_NF_CONNTRACK_IRC=m
+CONFIG_NF_CONNTRACK_SIP=m
+CONFIG_NF_CT_NETLINK=m
+CONFIG_NETFILTER_XT_MARK=m
+CONFIG_NETFILTER_XT_CONNMARK=m
+CONFIG_NETFILTER_XT_MATCH_STATE=m
+CONFIG_NF_CONNTRACK_IPV4=m
+CONFIG_IP_NF_IPTABLES=m
+CONFIG_IP_NF_MATCH_ADDRTYPE=m
+CONFIG_IP_NF_MATCH_AH=m
+CONFIG_IP_NF_MATCH_ECN=m
+CONFIG_IP_NF_MATCH_TTL=m
+CONFIG_IP_NF_FILTER=m
+CONFIG_IP_NF_TARGET_REJECT=m
+CONFIG_IP_NF_TARGET_LOG=m
+CONFIG_IP_NF_TARGET_ULOG=m
+CONFIG_NF_NAT=m
+CONFIG_IP_NF_TARGET_MASQUERADE=m
+CONFIG_IP_NF_TARGET_NETMAP=m
+CONFIG_IP_NF_TARGET_REDIRECT=m
+CONFIG_NF_NAT_SNMP_BASIC=m
+CONFIG_IP_NF_MANGLE=m
+CONFIG_IP_NF_TARGET_CLUSTERIP=m
+CONFIG_IP_NF_TARGET_ECN=m
+CONFIG_IP_NF_TARGET_TTL=m
+CONFIG_IP_NF_RAW=m
+CONFIG_IP_NF_ARPTABLES=m
+CONFIG_IP_NF_ARPFILTER=m
+CONFIG_IP_NF_ARP_MANGLE=m
+CONFIG_CFG80211=y
+CONFIG_LIB80211=y
+CONFIG_MAC80211=y
+CONFIG_MAC80211_LEDS=y
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_MTD=y
+CONFIG_MTD_CONCAT=y
+CONFIG_MTD_PARTITIONS=y
+CONFIG_MTD_CMDLINE_PARTS=y
+CONFIG_MTD_CHAR=y
+CONFIG_MTD_BLOCK=y
+CONFIG_MTD_DATAFLASH=y
+CONFIG_MTD_NAND=y
+CONFIG_MTD_NAND_ATMEL=y
+CONFIG_MTD_UBI=y
+CONFIG_BLK_DEV_LOOP=y
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_SIZE=8192
+CONFIG_MISC_DEVICES=y
+CONFIG_EEPROM_AT24=y
+CONFIG_BLK_DEV_SD=y
+CONFIG_SCSI_MULTI_LUN=y
+CONFIG_ATA=y
+CONFIG_PATA_AT91=y
+CONFIG_NETDEVICES=y
+CONFIG_NET_ETHERNET=y
+CONFIG_MACB=y
+CONFIG_RTL8187=m
+CONFIG_RT2X00=y
+CONFIG_RT2500USB=y
+CONFIG_RT73USB=y
+CONFIG_RT2800USB=y
+CONFIG_PPP=y
+CONFIG_PPP_ASYNC=y
+CONFIG_PPP_DEFLATE=y
+CONFIG_PPP_BSDCOMP=y
+CONFIG_PPP_MPPE=y
+CONFIG_INPUT_MOUSEDEV_SCREEN_X=320
+CONFIG_INPUT_MOUSEDEV_SCREEN_Y=240
+CONFIG_INPUT_EVDEV=y
+CONFIG_KEYBOARD_GPIO=y
+CONFIG_SERIAL_ATMEL=y
+CONFIG_SERIAL_ATMEL_CONSOLE=y
+CONFIG_I2C=y
+CONFIG_I2C_CHARDEV=y
+CONFIG_I2C_GPIO=y
+CONFIG_SPI=y
+CONFIG_SPI_ATMEL=y
+CONFIG_SPI_SPIDEV=y
+CONFIG_GPIO_SYSFS=y
+CONFIG_GPIO_PCF857X=y
+CONFIG_W1=y
+CONFIG_W1_MASTER_GPIO=y
+CONFIG_W1_SLAVE_DS2431=y
+CONFIG_USB=y
+CONFIG_USB_DEVICEFS=y
+CONFIG_USB_OHCI_HCD=y
+CONFIG_USB_ACM=y
+CONFIG_USB_STORAGE=y
+CONFIG_USB_GADGET=y
+CONFIG_USB_ETH=y
+CONFIG_MMC=y
+CONFIG_MMC_ATMELMCI=y
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_TRIGGER_TIMER=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_DRV_AT91SAM9=y
+CONFIG_EXT2_FS=y
+CONFIG_EXT3_FS=y
+CONFIG_EXT4_FS=y
+CONFIG_VFAT_FS=y
+CONFIG_TMPFS=y
+CONFIG_JFFS2_FS=y
+CONFIG_JFFS2_SUMMARY=y
+CONFIG_UBIFS_FS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+CONFIG_NLS_CODEPAGE_437=y
+CONFIG_NLS_CODEPAGE_850=y
+CONFIG_NLS_ISO8859_1=y
+CONFIG_NLS_ISO8859_15=y
+CONFIG_NLS_UTF8=y
diff --git a/arch/arm/configs/pcontrol_g20_defconfig b/arch/arm/configs/pcontrol_g20_defconfig
index b42ee62..3c66fca 100644
--- a/arch/arm/configs/pcontrol_g20_defconfig
+++ b/arch/arm/configs/pcontrol_g20_defconfig
@@ -23,7 +23,8 @@ CONFIG_MODULE_UNLOAD=y
 CONFIG_DEFAULT_DEADLINE=y
 CONFIG_ARCH_AT91=y
 CONFIG_ARCH_AT91SAM9G20=y
-CONFIG_MACH_PCONTROL_G20=y
+CONFIG_MACH_STAMP9G20=y
+CONFIG_CARRIERBOARD_PCONTROL_G20=y
 CONFIG_AT91_PROGRAMMABLE_CLOCKS=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
diff --git a/arch/arm/configs/portuxg20_defconfig b/arch/arm/configs/portuxg20_defconfig
new file mode 100644
index 0000000..e50492b
--- /dev/null
+++ b/arch/arm/configs/portuxg20_defconfig
@@ -0,0 +1,129 @@
+CONFIG_EXPERIMENTAL=y
+# CONFIG_LOCALVERSION_AUTO is not set
+# CONFIG_SWAP is not set
+CONFIG_SYSVIPC=y
+CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_LOG_BUF_SHIFT=14
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_SLAB=y
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+# CONFIG_LBDAF is not set
+# CONFIG_BLK_DEV_BSG is not set
+# CONFIG_IOSCHED_DEADLINE is not set
+CONFIG_ARCH_AT91=y
+CONFIG_ARCH_AT91SAM9G20=y
+CONFIG_MACH_STAMP9G20=y
+CONFIG_CARRIERBOARD_PORTUXG20=y
+CONFIG_AT91_PROGRAMMABLE_CLOCKS=y
+CONFIG_AT91_SLOW_CLOCK=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_PREEMPT=y
+CONFIG_AEABI=y
+# CONFIG_OABI_COMPAT is not set
+CONFIG_ZBOOT_ROM_TEXT=0x0
+CONFIG_ZBOOT_ROM_BSS=0x0
+CONFIG_CMDLINE="mem=64M console=ttyS0,115200 initrd=0x21100000,3145728 root=/dev/ram0 rw"
+CONFIG_KEXEC=y
+CONFIG_CPU_IDLE=y
+CONFIG_PM=y
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_INET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
+# CONFIG_IPV6 is not set
+# CONFIG_WIRELESS is not set
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_MTD=y
+CONFIG_MTD_CONCAT=y
+CONFIG_MTD_PARTITIONS=y
+CONFIG_MTD_CMDLINE_PARTS=y
+CONFIG_MTD_CHAR=y
+CONFIG_MTD_BLOCK=y
+CONFIG_MTD_DATAFLASH=y
+CONFIG_MTD_NAND=y
+CONFIG_MTD_NAND_ATMEL=y
+CONFIG_BLK_DEV_LOOP=y
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_SIZE=8192
+# CONFIG_MISC_DEVICES is not set
+CONFIG_SCSI=y
+CONFIG_BLK_DEV_SD=y
+CONFIG_SCSI_MULTI_LUN=y
+# CONFIG_SCSI_LOWLEVEL is not set
+CONFIG_NETDEVICES=y
+CONFIG_NET_ETHERNET=y
+CONFIG_MACB=y
+# CONFIG_NETDEV_1000 is not set
+# CONFIG_NETDEV_10000 is not set
+# CONFIG_WLAN is not set
+# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
+CONFIG_INPUT_MOUSEDEV_SCREEN_X=320
+CONFIG_INPUT_MOUSEDEV_SCREEN_Y=240
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_SERIO is not set
+CONFIG_SERIAL_ATMEL=y
+CONFIG_SERIAL_ATMEL_CONSOLE=y
+# CONFIG_LEGACY_PTYS is not set
+# CONFIG_HW_RANDOM is not set
+CONFIG_I2C=y
+CONFIG_I2C_CHARDEV=y
+CONFIG_I2C_GPIO=y
+CONFIG_SPI=y
+CONFIG_SPI_ATMEL=y
+CONFIG_SPI_SPIDEV=y
+CONFIG_GPIO_SYSFS=y
+CONFIG_W1=y
+CONFIG_W1_MASTER_GPIO=y
+CONFIG_W1_SLAVE_THERM=y
+CONFIG_W1_SLAVE_DS2431=y
+# CONFIG_HWMON is not set
+CONFIG_WATCHDOG=y
+CONFIG_AT91SAM9X_WATCHDOG=y
+# CONFIG_VGA_CONSOLE is not set
+# CONFIG_HID_SUPPORT is not set
+CONFIG_USB=y
+CONFIG_USB_DEVICEFS=y
+# CONFIG_USB_DEVICE_CLASS is not set
+CONFIG_USB_MON=y
+CONFIG_USB_OHCI_HCD=y
+CONFIG_USB_STORAGE=y
+CONFIG_USB_GADGET=m
+CONFIG_USB_ZERO=m
+CONFIG_USB_ETH=m
+CONFIG_USB_FILE_STORAGE=m
+CONFIG_USB_G_SERIAL=m
+CONFIG_MMC=y
+# CONFIG_MMC_AT91 is not set
+CONFIG_MMC_ATMELMCI=y
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_TRIGGERS=y
+CONFIG_LEDS_TRIGGER_TIMER=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_DRV_AT91SAM9=y
+CONFIG_EXT2_FS=y
+CONFIG_EXT3_FS=y
+CONFIG_INOTIFY=y
+CONFIG_VFAT_FS=y
+CONFIG_TMPFS=y
+CONFIG_JFFS2_FS=y
+CONFIG_JFFS2_SUMMARY=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+CONFIG_NLS_CODEPAGE_437=y
+CONFIG_NLS_CODEPAGE_850=y
+CONFIG_NLS_ISO8859_1=y
+CONFIG_NLS_ISO8859_15=y
+CONFIG_NLS_UTF8=y
+# CONFIG_RCU_CPU_STALL_DETECTOR is not set
+# CONFIG_ARM_UNWIND is not set
diff --git a/arch/arm/configs/stamp9g20_defconfig b/arch/arm/configs/stamp9g20_defconfig
index d5e260b..45ba2f5 100644
--- a/arch/arm/configs/stamp9g20_defconfig
+++ b/arch/arm/configs/stamp9g20_defconfig
@@ -13,8 +13,8 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_IOSCHED_DEADLINE is not set
 CONFIG_ARCH_AT91=y
 CONFIG_ARCH_AT91SAM9G20=y
-CONFIG_MACH_PORTUXG20=y
 CONFIG_MACH_STAMP9G20=y
+CONFIG_CARRIERBOARD_PANELCARDEVB=y
 CONFIG_AT91_PROGRAMMABLE_CLOCKS=y
 CONFIG_AT91_SLOW_CLOCK=y
 CONFIG_NO_HZ=y
diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index c015b68..b37bdb4 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -362,12 +362,6 @@ config MACH_CPU9G20
 	  Select this if you are using a Eukrea Electromatique's
 	  CPU9G20 Board <http://www.eukrea.com/>
 
-config MACH_PORTUXG20
-	bool "taskit PortuxG20"
-	help
-	  Select this if you are using taskit's PortuxG20.
-	  <http://www.taskit.de/en/>
-
 config MACH_STAMP9G20
 	bool "taskit Stamp9G20 CPU module"
 	help
@@ -375,12 +369,48 @@ config MACH_STAMP9G20
 	  evaluation board.
 	  <http://www.taskit.de/en/>
 
-config MACH_PCONTROL_G20
-	bool "PControl G20 CPU module"
+#
+# The "Carrier Board for Stamp9G20" choice list is ordered alphabetically by
+# option text.  Please add new entries in the option alphabetic order.
+#
+choice
+	prompt "Carrier Board for Stamp9G20"
+	default CARRIERBOARD_PANELCARDEVB
+	help
+	  Carrier boards for the Stamp9G20 SoM.
+
+config CARRIERBOARD_GMS
+	bool "GMS"
+	help
+	  This enables support for the GMS carrier board
+	  produced by GeoSIG Ltd company. The GMS is a seismic station.
+	  <http://www.geosig.com>
+
+config CARRIERBOARD_PANELCARDEVB
+	bool "Panel Card EVB"
 	help
+	  This enables support for the Panel Card EVB carrier board
+	  produced by Taskit company.
+
+config CARRIERBOARD_PCONTROL_G20
+	bool "Pcontrol G20"
+	help
+	  This enables support for the Pcontrol G20 carrier board
+	  produced by PORTNER-Elektronik company.
 	  Select this if you are using taskit's Stamp9G20 CPU module on this
 	  carrier board, beeing the decentralized unit of a building automation
 	  system; featuring nvram, eth-switch, iso-rs485, display, io
+
+config CARRIERBOARD_PORTUXG20
+	bool "Portux G20"
+	help
+	  This enables support for the Portux G20 board
+	  produced by Taskit company.
+	  The Portux G20 board is an extended Stamp9G20 variant.
+	  Select this if you are using taskit's PortuxG20.
+	  <http://www.taskit.de/en/>
+
+endchoice
 endif
 
 if (ARCH_AT91SAM9260 || ARCH_AT91SAM9G20)
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 62d686f..bc14a79 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -64,8 +64,6 @@ obj-$(CONFIG_MACH_AT91SAM9RLEK)	+= board-sam9rlek.o
 obj-$(CONFIG_MACH_AT91SAM9G20EK) += board-sam9g20ek.o
 obj-$(CONFIG_MACH_CPU9G20)	+= board-cpu9krea.o
 obj-$(CONFIG_MACH_STAMP9G20)	+= board-stamp9g20.o
-obj-$(CONFIG_MACH_PORTUXG20)	+= board-stamp9g20.o
-obj-$(CONFIG_MACH_PCONTROL_G20)	+= board-pcontrol-g20.o
 
 # AT91SAM9260/AT91SAM9G20 board-specific support
 obj-$(CONFIG_MACH_SNAPPER_9260)	+= board-snapper9260.o
@@ -90,6 +88,12 @@ obj-$(CONFIG_PM)		+= pm.o
 obj-$(CONFIG_AT91_SLOW_CLOCK)	+= pm_slowclock.o
 obj-$(CONFIG_CPU_IDLE)	+= cpuidle.o
 
+# Carrier Boards
+obj-$(CONFIG_CARRIERBOARD_GMS)		+= carrier-board-gms.o
+obj-$(CONFIG_CARRIERBOARD_PANELCARDEVB)	+= carrier-board-panelcardevb.o
+obj-$(CONFIG_CARRIERBOARD_PORTUXG20)	+= carrier-board-portuxg20.o
+obj-$(CONFIG_CARRIERBOARD_PCONTROL_G20)	+= carrier-board-pcontrol-g20.o
+
 ifeq ($(CONFIG_PM_DEBUG),y)
 CFLAGS_pm.o += -DDEBUG
 endif
diff --git a/arch/arm/mach-at91/board-pcontrol-g20.c b/arch/arm/mach-at91/board-pcontrol-g20.c
deleted file mode 100644
index bba5a56..0000000
--- a/arch/arm/mach-at91/board-pcontrol-g20.c
+++ /dev/null
@@ -1,322 +0,0 @@
-/*
- *  Copyright (C) 2010 Christian Glindkamp <christian.glindkamp@taskit.de>
- *                     taskit GmbH
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-/*
- * copied and adjusted from board-stamp9g20.c
- * by Peter Gsellmann <pgsellmann@portner-elektronik.at>
- */
-
-#include <linux/mm.h>
-#include <linux/platform_device.h>
-#include <linux/gpio.h>
-#include <linux/w1-gpio.h>
-
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-
-#include <mach/board.h>
-#include <mach/at91sam9_smc.h>
-
-#include "sam9_smc.h"
-#include "generic.h"
-
-
-static void __init pcontrol_g20_map_io(void)
-{
-	/* Initialize processor: 18.432 MHz crystal */
-	at91sam9260_initialize(18432000);
-
-	/* DGBU on ttyS0. (Rx, Tx) only TTL -> JTAG connector X7 17,19 ) */
-	at91_register_uart(0, 0, 0);
-
-	/* USART0 on ttyS1. (Rx, Tx, CTS, RTS) piggyback  A2 */
-	at91_register_uart(AT91SAM9260_ID_US0, 1, ATMEL_UART_CTS
-						| ATMEL_UART_RTS);
-
-	/* USART1 on ttyS2. (Rx, Tx, CTS, RTS) isolated RS485  X5 */
-	at91_register_uart(AT91SAM9260_ID_US1, 2, ATMEL_UART_CTS
-						| ATMEL_UART_RTS);
-
-	/* USART2 on ttyS3. (Rx, Tx)  9bit-Bus  Multidrop-mode  X4 */
-	at91_register_uart(AT91SAM9260_ID_US4, 3, 0);
-
-	/* set serial console to ttyS0 (ie, DBGU) */
-	at91_set_serial_console(0);
-}
-
-
-static void __init init_irq(void)
-{
-	at91sam9260_init_interrupts(NULL);
-}
-
-
-/*
- * NAND flash 512MiB 1,8V 8-bit, sector size 128 KiB
- */
-static struct atmel_nand_data __initdata nand_data = {
-	.ale		= 21,
-	.cle		= 22,
-	.rdy_pin	= AT91_PIN_PC13,
-	.enable_pin	= AT91_PIN_PC14,
-};
-
-/*
- * Bus timings; unit = 7.57ns
- */
-static struct sam9_smc_config __initdata nand_smc_config = {
-	.ncs_read_setup		= 0,
-	.nrd_setup		= 2,
-	.ncs_write_setup	= 0,
-	.nwe_setup		= 2,
-
-	.ncs_read_pulse		= 4,
-	.nrd_pulse		= 4,
-	.ncs_write_pulse	= 4,
-	.nwe_pulse		= 4,
-
-	.read_cycle		= 7,
-	.write_cycle		= 7,
-
-	.mode			= AT91_SMC_READMODE | AT91_SMC_WRITEMODE
-			| AT91_SMC_EXNWMODE_DISABLE | AT91_SMC_DBW_8,
-	.tdf_cycles		= 3,
-};
-
-static struct sam9_smc_config __initdata pcontrol_smc_config[2] = { {
-	.ncs_read_setup		= 16,
-	.nrd_setup		= 18,
-	.ncs_write_setup	= 16,
-	.nwe_setup		= 18,
-
-	.ncs_read_pulse		= 63,
-	.nrd_pulse		= 55,
-	.ncs_write_pulse	= 63,
-	.nwe_pulse		= 55,
-
-	.read_cycle		= 127,
-	.write_cycle		= 127,
-
-	.mode			= AT91_SMC_READMODE | AT91_SMC_WRITEMODE
-			| AT91_SMC_EXNWMODE_DISABLE | AT91_SMC_BAT_SELECT
-			| AT91_SMC_DBW_8 | AT91_SMC_PS_4
-			| AT91_SMC_TDFMODE,
-	.tdf_cycles		= 3,
-}, {
-	.ncs_read_setup		= 0,
-	.nrd_setup		= 0,
-	.ncs_write_setup	= 0,
-	.nwe_setup		= 1,
-
-	.ncs_read_pulse		= 8,
-	.nrd_pulse		= 8,
-	.ncs_write_pulse	= 5,
-	.nwe_pulse		= 4,
-
-	.read_cycle		= 8,
-	.write_cycle		= 7,
-
-	.mode			= AT91_SMC_READMODE | AT91_SMC_WRITEMODE
-			| AT91_SMC_EXNWMODE_DISABLE | AT91_SMC_BAT_SELECT
-			| AT91_SMC_DBW_16 | AT91_SMC_PS_8
-			| AT91_SMC_TDFMODE,
-	.tdf_cycles		= 1,
-} };
-
-static void __init add_device_nand(void)
-{
-	/* configure chip-select 3 (NAND) */
-	sam9_smc_configure(3, &nand_smc_config);
-	at91_add_device_nand(&nand_data);
-}
-
-
-static void __init add_device_pcontrol(void)
-{
-	/* configure chip-select 4 (IO compatible to 8051  X4 ) */
-	sam9_smc_configure(4, &pcontrol_smc_config[0]);
-	/* configure chip-select 7 (FerroRAM 256KiBx16bit MR2A16A  D4 ) */
-	sam9_smc_configure(7, &pcontrol_smc_config[1]);
-}
-
-
-/*
- * MCI (SD/MMC)
- * det_pin, wp_pin and vcc_pin are not connected
- */
-#if defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
-static struct mci_platform_data __initdata mmc_data = {
-	.slot[0] = {
-		.bus_width	= 4,
-	},
-};
-#else
-static struct at91_mmc_data __initdata mmc_data = {
-	.wire4		= 1,
-};
-#endif
-
-
-/*
- * USB Host port
- */
-static struct at91_usbh_data __initdata usbh_data = {
-	.ports		= 2,
-};
-
-
-/*
- * USB Device port
- */
-static struct at91_udc_data __initdata pcontrol_g20_udc_data = {
-	.vbus_pin	= AT91_PIN_PA22,	/* Detect +5V bus voltage */
-	.pullup_pin	= AT91_PIN_PA4,		/* K-state, active low */
-};
-
-
-/*
- * MACB Ethernet device
- */
-static struct at91_eth_data __initdata macb_data = {
-	.phy_irq_pin	= AT91_PIN_PA28,
-	.is_rmii	= 1,
-};
-
-
-/*
- * I2C devices: eeprom and phy/switch
- */
-static struct i2c_board_info __initdata pcontrol_g20_i2c_devices[] = {
-{		/* D7  address width=2, 8KiB */
-	I2C_BOARD_INFO("24c64", 0x50)
-}, {		/* D8  address width=1, 1 byte has 32 bits! */
-	I2C_BOARD_INFO("lan9303", 0x0a)
-}, };
-
-
-/*
- * LEDs
- */
-static struct gpio_led pcontrol_g20_leds[] = {
-	{
-		.name			= "LED1",	/* red  H5 */
-		.gpio			= AT91_PIN_PB18,
-		.active_low		= 1,
-		.default_trigger	= "none",	/* supervisor */
-	}, {
-		.name			= "LED2",	/* yellow  H7 */
-		.gpio			= AT91_PIN_PB19,
-		.active_low		= 1,
-		.default_trigger	= "mmc0",	/* SD-card activity */
-	}, {
-		.name			= "LED3",	/* green  H2 */
-		.gpio			= AT91_PIN_PB20,
-		.active_low		= 1,
-		.default_trigger	= "heartbeat",	/* blinky */
-	}, {
-		.name			= "LED4",	/* red  H3 */
-		.gpio			= AT91_PIN_PC6,
-		.active_low		= 1,
-		.default_trigger	= "none",	/* connection lost */
-	}, {
-		.name			= "LED5",	/* yellow  H6 */
-		.gpio			= AT91_PIN_PC7,
-		.active_low		= 1,
-		.default_trigger	= "none",	/* unsent data */
-	}, {
-		.name			= "LED6",	/* green  H1 */
-		.gpio			= AT91_PIN_PC9,
-		.active_low		= 1,
-		.default_trigger	= "none",	/* snafu */
-	}
-};
-
-
-/*
- * SPI devices
- */
-static struct spi_board_info pcontrol_g20_spi_devices[] = {
-	{
-		.modalias	= "spidev",	/* HMI port  X4 */
-		.chip_select	= 1,
-		.max_speed_hz	= 50 * 1000 * 1000,
-		.bus_num	= 0,
-	}, {
-		.modalias	= "spidev",	/* piggyback  A2 */
-		.chip_select	= 0,
-		.max_speed_hz	= 50 * 1000 * 1000,
-		.bus_num	= 1,
-	},
-};
-
-
-/*
- * Dallas 1-Wire  DS2431
- */
-static struct w1_gpio_platform_data w1_gpio_pdata = {
-	.pin		= AT91_PIN_PA29,
-	.is_open_drain	= 1,
-};
-
-static struct platform_device w1_device = {
-	.name			= "w1-gpio",
-	.id			= -1,
-	.dev.platform_data	= &w1_gpio_pdata,
-};
-
-static void add_wire1(void)
-{
-	at91_set_GPIO_periph(w1_gpio_pdata.pin, 1);
-	at91_set_multi_drive(w1_gpio_pdata.pin, 1);
-	platform_device_register(&w1_device);
-}
-
-
-static void __init pcontrol_g20_board_init(void)
-{
-	at91_add_device_serial();
-	add_device_nand();
-#if defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
-	at91_add_device_mci(0, &mmc_data);
-#else
-	at91_add_device_mmc(0, &mmc_data);
-#endif
-	at91_add_device_usbh(&usbh_data);
-	at91_add_device_eth(&macb_data);
-	at91_add_device_i2c(pcontrol_g20_i2c_devices,
-		ARRAY_SIZE(pcontrol_g20_i2c_devices));
-	add_wire1();
-	add_device_pcontrol();
-	at91_add_device_spi(pcontrol_g20_spi_devices,
-		ARRAY_SIZE(pcontrol_g20_spi_devices));
-	at91_add_device_udc(&pcontrol_g20_udc_data);
-	at91_gpio_leds(pcontrol_g20_leds,
-		ARRAY_SIZE(pcontrol_g20_leds));
-	/* piggyback  A2 */
-	at91_set_gpio_output(AT91_PIN_PB31, 1);
-}
-
-
-MACHINE_START(PCONTROL_G20, "PControl G20")
-	/* Maintainer: pgsellmann@portner-elektronik.at */
-	.boot_params	= AT91_SDRAM_BASE + 0x100,
-	.timer		= &at91sam926x_timer,
-	.map_io		= pcontrol_g20_map_io,
-	.init_irq	= init_irq,
-	.init_machine	= pcontrol_g20_board_init,
-MACHINE_END
diff --git a/arch/arm/mach-at91/board-stamp9g20.c b/arch/arm/mach-at91/board-stamp9g20.c
index 5206eef..7e99a95 100644
--- a/arch/arm/mach-at91/board-stamp9g20.c
+++ b/arch/arm/mach-at91/board-stamp9g20.c
@@ -1,6 +1,9 @@
 /*
- *  Copyright (C) 2010 Christian Glindkamp <christian.glindkamp@taskit.de>
- *                     taskit GmbH
+ *  Copyright (C) 2010:
+ *		Christian Glindkamp <christian.glindkamp@taskit.de>
+ *			taskit GmbH
+ *		Igor Plyatov plyatov@gmail.com
+ *			GeoSIG Ltd
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -17,7 +20,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#include <linux/mm.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/w1-gpio.h>
@@ -31,37 +33,7 @@
 #include "sam9_smc.h"
 #include "generic.h"
 
-
-static void __init portuxg20_map_io(void)
-{
-	/* Initialize processor: 18.432 MHz crystal */
-	at91sam9260_initialize(18432000);
-
-	/* DGBU on ttyS0. (Rx & Tx only) */
-	at91_register_uart(0, 0, 0);
-
-	/* USART0 on ttyS1. (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI) */
-	at91_register_uart(AT91SAM9260_ID_US0, 1, ATMEL_UART_CTS | ATMEL_UART_RTS
-						| ATMEL_UART_DTR | ATMEL_UART_DSR
-						| ATMEL_UART_DCD | ATMEL_UART_RI);
-
-	/* USART1 on ttyS2. (Rx, Tx, CTS, RTS) */
-	at91_register_uart(AT91SAM9260_ID_US1, 2, ATMEL_UART_CTS | ATMEL_UART_RTS);
-
-	/* USART2 on ttyS3. (Rx, Tx, CTS, RTS) */
-	at91_register_uart(AT91SAM9260_ID_US2, 3, ATMEL_UART_CTS | ATMEL_UART_RTS);
-
-	/* USART4 on ttyS5. (Rx, Tx only) */
-	at91_register_uart(AT91SAM9260_ID_US4, 5, 0);
-
-	/* USART5 on ttyS6. (Rx, Tx only) */
-	at91_register_uart(AT91SAM9260_ID_US5, 6, 0);
-
-	/* set serial console to ttyS0 (ie, DBGU) */
-	at91_set_serial_console(0);
-}
-
-static void __init stamp9g20_map_io(void)
+static void __init board_map_io(void)
 {
 	/* Initialize processor: 18.432 MHz crystal */
 	at91sam9260_initialize(18432000);
@@ -69,10 +41,8 @@ static void __init stamp9g20_map_io(void)
 	/* DGBU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
 
-	/* USART0 on ttyS1. (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI) */
-	at91_register_uart(AT91SAM9260_ID_US0, 1, ATMEL_UART_CTS | ATMEL_UART_RTS
-						| ATMEL_UART_DTR | ATMEL_UART_DSR
-						| ATMEL_UART_DCD | ATMEL_UART_RI);
+	/* specific HW of the carrier board */
+	carrier_board_map_io();
 
 	/* set serial console to ttyS0 (ie, DBGU) */
 	at91_set_serial_console(0);
@@ -83,7 +53,6 @@ static void __init init_irq(void)
 	at91sam9260_init_interrupts(NULL);
 }
 
-
 /*
  * NAND flash
  */
@@ -92,7 +61,6 @@ static struct atmel_nand_data __initdata nand_data = {
 	.cle		= 22,
 	.rdy_pin	= AT91_PIN_PC13,
 	.enable_pin	= AT91_PIN_PC14,
-	.bus_width_16	= 0,
 };
 
 static struct sam9_smc_config __initdata nand_smc_config = {
@@ -109,7 +77,10 @@ static struct sam9_smc_config __initdata nand_smc_config = {
 	.read_cycle		= 7,
 	.write_cycle		= 7,
 
-	.mode			= AT91_SMC_READMODE | AT91_SMC_WRITEMODE | AT91_SMC_EXNWMODE_DISABLE | AT91_SMC_DBW_8,
+	.mode			= AT91_SMC_READMODE |
+				  AT91_SMC_WRITEMODE |
+				  AT91_SMC_EXNWMODE_DISABLE |
+				  AT91_SMC_DBW_8,
 	.tdf_cycles		= 3,
 };
 
@@ -121,7 +92,6 @@ static void __init add_device_nand(void)
 	at91_add_device_nand(&nand_data);
 }
 
-
 /*
  * MCI (SD/MMC)
  * det_pin, wp_pin and vcc_pin are not connected
@@ -139,95 +109,6 @@ static struct at91_mmc_data __initdata mmc_data = {
 };
 #endif
 
-
-/*
- * USB Host port
- */
-static struct at91_usbh_data __initdata usbh_data = {
-	.ports		= 2,
-};
-
-
-/*
- * USB Device port
- */
-static struct at91_udc_data __initdata portuxg20_udc_data = {
-	.vbus_pin	= AT91_PIN_PC7,
-	.pullup_pin	= 0,		/* pull-up driven by UDC */
-};
-
-static struct at91_udc_data __initdata stamp9g20_udc_data = {
-	.vbus_pin	= AT91_PIN_PA22,
-	.pullup_pin	= 0,		/* pull-up driven by UDC */
-};
-
-
-/*
- * MACB Ethernet device
- */
-static struct at91_eth_data __initdata macb_data = {
-	.phy_irq_pin	= AT91_PIN_PA28,
-	.is_rmii	= 1,
-};
-
-
-/*
- * LEDs
- */
-static struct gpio_led portuxg20_leds[] = {
-	{
-		.name			= "LED2",
-		.gpio			= AT91_PIN_PC5,
-		.default_trigger	= "none",
-	}, {
-		.name			= "LED3",
-		.gpio			= AT91_PIN_PC4,
-		.default_trigger	= "none",
-	}, {
-		.name			= "LED4",
-		.gpio			= AT91_PIN_PC10,
-		.default_trigger	= "heartbeat",
-	}
-};
-
-static struct gpio_led stamp9g20_leds[] = {
-	{
-		.name			= "D8",
-		.gpio			= AT91_PIN_PB18,
-		.active_low		= 1,
-		.default_trigger	= "none",
-	}, {
-		.name			= "D9",
-		.gpio			= AT91_PIN_PB19,
-		.active_low		= 1,
-		.default_trigger	= "none",
-	}, {
-		.name			= "D10",
-		.gpio			= AT91_PIN_PB20,
-		.active_low		= 1,
-		.default_trigger	= "heartbeat",
-	}
-};
-
-
-/*
- * SPI devices
- */
-static struct spi_board_info portuxg20_spi_devices[] = {
-	{
-		.modalias	= "spidev",
-		.chip_select	= 0,
-		.max_speed_hz	= 1 * 1000 * 1000,
-		.bus_num	= 0,
-	}, {
-		.modalias	= "spidev",
-		.chip_select	= 0,
-		.max_speed_hz	= 1 * 1000 * 1000,
-		.bus_num	= 1,
-	},
-};
-
-
 /*
  * Dallas 1-Wire
  */
@@ -249,63 +130,31 @@ void add_w1(void)
 	platform_device_register(&w1_device);
 }
 
-
-static void __init generic_board_init(void)
+static void __init board_init(void)
 {
-	/* Serial */
 	at91_add_device_serial();
-	/* NAND */
 	add_device_nand();
-	/* MMC */
 #if defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
 	at91_add_device_mci(0, &mmc_data);
 #else
 	at91_add_device_mmc(0, &mmc_data);
 #endif
-	/* USB Host */
-	at91_add_device_usbh(&usbh_data);
-	/* Ethernet */
-	at91_add_device_eth(&macb_data);
-	/* I2C */
-	at91_add_device_i2c(NULL, 0);
-	/* W1 */
 	add_w1();
+	carrier_board_init();
 }
 
-static void __init portuxg20_board_init(void)
-{
-	generic_board_init();
-	/* SPI */
-	at91_add_device_spi(portuxg20_spi_devices, ARRAY_SIZE(portuxg20_spi_devices));
-	/* USB Device */
-	at91_add_device_udc(&portuxg20_udc_data);
-	/* LEDs */
-	at91_gpio_leds(portuxg20_leds, ARRAY_SIZE(portuxg20_leds));
-}
-
-static void __init stamp9g20_board_init(void)
-{
-	generic_board_init();
-	/* USB Device */
-	at91_add_device_udc(&stamp9g20_udc_data);
-	/* LEDs */
-	at91_gpio_leds(stamp9g20_leds, ARRAY_SIZE(stamp9g20_leds));
-}
-
-MACHINE_START(PORTUXG20, "taskit PortuxG20")
-	/* Maintainer: taskit GmbH */
-	.boot_params	= AT91_SDRAM_BASE + 0x100,
-	.timer		= &at91sam926x_timer,
-	.map_io		= portuxg20_map_io,
-	.init_irq	= init_irq,
-	.init_machine	= portuxg20_board_init,
-MACHINE_END
-
-MACHINE_START(STAMP9G20, "taskit Stamp9G20")
-	/* Maintainer: taskit GmbH */
+#if defined(CONFIG_CARRIERBOARD_GMS)
+	MACHINE_START(STAMP9G20, "Stamp9G20 on the GMS")
+#elif defined(CONFIG_CARRIERBOARD_PCONTROL_G20)
+	MACHINE_START(PCONTROL_G20, "PControl G20")
+#elif defined(CONFIG_CARRIERBOARD_PANELCARDEVB)
+	MACHINE_START(STAMP9G20, "taskit Stamp9G20")
+#elif defined(CONFIG_CARRIERBOARD_PORTUXG20)
+	MACHINE_START(PORTUXG20, "taskit PortuxG20")
+#endif
 	.boot_params	= AT91_SDRAM_BASE + 0x100,
 	.timer		= &at91sam926x_timer,
-	.map_io		= stamp9g20_map_io,
+	.map_io		= board_map_io,
 	.init_irq	= init_irq,
-	.init_machine	= stamp9g20_board_init,
+	.init_machine	= board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/carrier-board-gms.c b/arch/arm/mach-at91/carrier-board-gms.c
new file mode 100644
index 0000000..30b218d
--- /dev/null
+++ b/arch/arm/mach-at91/carrier-board-gms.c
@@ -0,0 +1,556 @@
+/*
+ *  Copyright (C) 2010 Christian Glindkamp <christian.glindkamp@taskit.de>
+ *			taskit GmbH
+ *                2010 Igor Plyatov <plyatov@gmail.com>
+ *			GeoSIG Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/gpio_keys.h>
+#include <linux/input.h>
+#include <linux/i2c/pcf857x.h>
+
+#include <mach/board.h>
+#include <mach/gms.h>
+
+void __init carrier_board_map_io(void)
+{
+	/*
+	 * USART0 on ttyS1 (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI).
+	 * Used for Internal Analog Modem.
+	 */
+	at91_register_uart(AT91SAM9260_ID_US0, 1,
+			     ATMEL_UART_CTS | ATMEL_UART_RTS
+			   | ATMEL_UART_DTR | ATMEL_UART_DSR
+			   | ATMEL_UART_DCD | ATMEL_UART_RI);
+	/*
+	 * USART1 on ttyS2 (Rx, Tx, CTS, RTS).
+	 * Used for GPS or WiFi or Data stream.
+	 */
+	at91_register_uart(AT91SAM9260_ID_US1, 2,
+			   ATMEL_UART_CTS | ATMEL_UART_RTS);
+	/*
+	 * USART2 on ttyS3 (Rx, Tx, CTS, RTS).
+	 * Used for External Modem.
+	 */
+	at91_register_uart(AT91SAM9260_ID_US2, 3,
+			   ATMEL_UART_CTS | ATMEL_UART_RTS);
+	/*
+	 * USART3 on ttyS4 (Rx, Tx, RTS).
+	 * Used for RS-485.
+	 */
+	at91_register_uart(AT91SAM9260_ID_US3, 4, ATMEL_UART_RTS);
+
+	/*
+	 * USART4 on ttyS5 (Rx, Tx).
+	 * Used for TRX433 Radio Module.
+	 */
+	at91_register_uart(AT91SAM9260_ID_US4, 5, 0);
+}
+
+/*
+ * Two USB Host ports
+ */
+static struct at91_usbh_data __initdata usbh_data = {
+	.ports		= 2,
+};
+
+/*
+ * USB Device port
+ */
+static struct at91_udc_data __initdata udc_data = {
+	.vbus_pin	= AT91_PIN_PA22,
+	.pullup_pin	= 0,		/* pull-up driven by UDC */
+};
+
+/*
+ * MACB Ethernet device
+ */
+static struct at91_eth_data __initdata macb_data = {
+	.phy_irq_pin	= AT91_PIN_PA28,
+	.is_rmii	= 1,
+};
+
+/*
+ * LEDs and GPOs
+ */
+static struct gpio_led stamp9g20gms_gpio_leds[] = {
+	{
+		.name                   = "gpo:spi1reset",
+		.gpio                   = AT91_PIN_PC1,
+		.active_low             = 0,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name                   = "gpo:trig_net_out",
+		.gpio                   = AT91_PIN_PB20,
+		.active_low             = 0,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name                   = "gpo:trig_net_dir",
+		.gpio                   = AT91_PIN_PB19,
+		.active_low             = 0,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name                   = "gpo:charge_dis",
+		.gpio                   = AT91_PIN_PC2,
+		.active_low             = 0,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name                   = "led:event",
+		.gpio                   = AT91_PIN_PB17,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name                   = "led:lan",
+		.gpio                   = AT91_PIN_PB18,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{
+		.name                   = "led:error",
+		.gpio                   = AT91_PIN_PB16,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_ON,
+	}
+};
+
+static struct gpio_led_platform_data stamp9g20gms_gpio_led_info = {
+	.leds		= stamp9g20gms_gpio_leds,
+	.num_leds	= ARRAY_SIZE(stamp9g20gms_gpio_leds),
+};
+
+static struct platform_device stamp9g20gms_leds = {
+	.name	= "leds-gpio",
+	.id	= 0,
+	.dev	= {
+		.platform_data	= &stamp9g20gms_gpio_led_info,
+	}
+};
+
+static void __init stamp9g20gms_leds_init(void)
+{
+	platform_device_register(&stamp9g20gms_leds);
+}
+
+/* PCF8574 0x20 GPIO - U1 on the GS_IA18-CB_V3 board */
+static struct gpio_led stamp9g20gms_pcf_gpio_leds1[] = {
+	{ /* bit 0 */
+		.name                   = "gpo:hdc_power",
+		.gpio                   = PCF_GPIO_HDC_POWER,
+		.active_low             = 0,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{ /* bit 1 */
+		.name                   = "gpo:wifi_setup",
+		.gpio                   = PCF_GPIO_WIFI_SETUP,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{ /* bit 2 */
+		.name                   = "gpo:wifi_enable",
+		.gpio                   = PCF_GPIO_WIFI_ENABLE,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{ /* bit 3  */
+		.name                   = "gpo:wifi_reset",
+		.gpio                   = PCF_GPIO_WIFI_RESET,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_ON,
+	},
+	/* bit 4 used as GPI  */
+	{ /* bit 5 */
+		.name                   = "gpo:gps_setup",
+		.gpio                   = PCF_GPIO_GPS_SETUP,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{ /* bit 6 */
+		.name                   = "gpo:gps_standby",
+		.gpio                   = PCF_GPIO_GPS_STANDBY,
+		.active_low             = 0,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_ON,
+	},
+	{ /* bit 7 */
+		.name                   = "gpo:gps_power",
+		.gpio                   = PCF_GPIO_GPS_POWER,
+		.active_low             = 0,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	}
+};
+
+static struct gpio_led_platform_data stamp9g20gms_pcf_gpio_led_info1 = {
+	.leds		= stamp9g20gms_pcf_gpio_leds1,
+	.num_leds	= ARRAY_SIZE(stamp9g20gms_pcf_gpio_leds1),
+};
+
+static struct platform_device stamp9g20gms_pcf_leds1 = {
+	.name	= "leds-gpio", /* GS_IA18-CB_board */
+	.id	= 1,
+	.dev	= {
+		.platform_data	= &stamp9g20gms_pcf_gpio_led_info1,
+	}
+};
+
+/* PCF8574 0x22 GPIO - U1 on the GS_2G_OPT1-A_V0 board (Alarm) */
+static struct gpio_led stamp9g20gms_pcf_gpio_leds2[] = {
+	{ /* bit 0 */
+		.name                   = "gpo:alarm_1",
+		.gpio                   = PCF_GPIO_ALARM1,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{ /* bit 1 */
+		.name                   = "gpo:alarm_2",
+		.gpio                   = PCF_GPIO_ALARM2,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{ /* bit 2 */
+		.name                   = "gpo:alarm_3",
+		.gpio                   = PCF_GPIO_ALARM3,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	{ /* bit 3 */
+		.name                   = "gpo:alarm_4",
+		.gpio                   = PCF_GPIO_ALARM4,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	/* bits 4, 5, 6 not used */
+	{ /* bit 7 */
+		.name                   = "gpo:alarm_v_relay_on",
+		.gpio                   = PCF_GPIO_ALARM_V_RELAY_ON,
+		.active_low             = 0,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+};
+
+static struct gpio_led_platform_data stamp9g20gms_pcf_gpio_led_info2 = {
+	.leds		= stamp9g20gms_pcf_gpio_leds2,
+	.num_leds	= ARRAY_SIZE(stamp9g20gms_pcf_gpio_leds2),
+};
+
+static struct platform_device stamp9g20gms_pcf_leds2 = {
+	.name	= "leds-gpio",
+	.id	= 2,
+	.dev	= {
+		.platform_data	= &stamp9g20gms_pcf_gpio_led_info2,
+	}
+};
+
+/* PCF8574 0x24 GPIO U1 on the GS_2G-OPT23-A_V0 board (Modem) */
+static struct gpio_led stamp9g20gms_pcf_gpio_leds3[] = {
+	{ /* bit 0 */
+		.name                   = "gpo:modem_power",
+		.gpio                   = PCF_GPIO_MODEM_POWER,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
+	},
+	  /* bits 1 and 2 not used */
+	{ /* bit 3 */
+		.name                   = "gpo:modem_reset",
+		.gpio                   = PCF_GPIO_MODEM_RESET,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_ON,
+	},
+	  /* bits 4, 5 and 6 not used */
+	{ /* bit 7 */
+		.name                   = "gpo:trx_reset",
+		.gpio                   = PCF_GPIO_TRX_RESET,
+		.active_low             = 1,
+		.default_trigger        = "none",
+		.default_state          = LEDS_GPIO_DEFSTATE_ON,
+	}
+};
+
+static struct gpio_led_platform_data stamp9g20gms_pcf_gpio_led_info3 = {
+	.leds		= stamp9g20gms_pcf_gpio_leds3,
+	.num_leds	= ARRAY_SIZE(stamp9g20gms_pcf_gpio_leds3),
+};
+
+static struct platform_device stamp9g20gms_pcf_leds3 = {
+	.name	= "leds-gpio",
+	.id	= 3,
+	.dev	= {
+		.platform_data	= &stamp9g20gms_pcf_gpio_led_info3,
+	}
+};
+
+static void __init stamp9g20gms_pcf_leds_init(void)
+{
+	platform_device_register(&stamp9g20gms_pcf_leds1);
+	platform_device_register(&stamp9g20gms_pcf_leds2);
+	platform_device_register(&stamp9g20gms_pcf_leds3);
+}
+
+/*
+ * SPI busses.
+ */
+static struct spi_board_info spi_devices[] = {
+	{ /* User accessible spi0, cs0 used for communication with MSP RTC */
+		.modalias	= "spidev",
+		.bus_num	= 0,
+		.chip_select	= 0,
+		.max_speed_hz	= 580000,
+		.mode		= SPI_MODE_1,
+	},
+	{ /* User accessible spi1, cs0 used for communication with int. DSP */
+		.modalias	= "spidev",
+		.bus_num	= 1,
+		.chip_select	= 0,
+		.max_speed_hz	= 5600000,
+		.mode		= SPI_MODE_0,
+	},
+	{ /* User accessible spi1, cs1 used for communication with ext. DSP */
+		.modalias	= "spidev",
+		.bus_num	= 1,
+		.chip_select	= 1,
+		.max_speed_hz	= 5600000,
+		.mode		= SPI_MODE_0,
+	},
+	{ /* User accessible spi1, cs2 used for communication with ext. DSP */
+		.modalias	= "spidev",
+		.bus_num	= 1,
+		.chip_select	= 2,
+		.max_speed_hz	= 5600000,
+		.mode		= SPI_MODE_0,
+	},
+	{ /* User accessible spi1, cs3 used for communication with ext. DSP */
+		.modalias	= "spidev",
+		.bus_num	= 1,
+		.chip_select	= 3,
+		.max_speed_hz	= 5600000,
+		.mode		= SPI_MODE_0,
+	}
+};
+
+/*
+ * GPI Buttons
+ */
+static struct gpio_keys_button stamp9g20gms_buttons[] = {
+	{
+		.gpio		= GPIO_TRIG_NET_IN,
+		.code		= BTN_1,
+		.desc		= "TRIG_NET_IN",
+		.type		= EV_KEY,
+		.active_low	= 0,
+		.wakeup		= 1,
+	},
+	{ /* SW80 on the GS_IA18_S-MN board*/
+		.gpio		= GPIO_CARD_UNMOUNT_0,
+		.code		= BTN_2,
+		.desc		= "Card umount 0",
+		.type		= EV_KEY,
+		.active_low	= 1,
+		.wakeup		= 1,
+	},
+	{ /* SW79 on the GS_IA18_S-MN board*/
+		.gpio		= GPIO_CARD_UNMOUNT_1,
+		.code		= BTN_3,
+		.desc		= "Card umount 1",
+		.type		= EV_KEY,
+		.active_low	= 1,
+		.wakeup		= 1,
+	},
+	{ /* SW280 on the GS_IA18-CB board*/
+		.gpio		= GPIO_KEY_POWER,
+		.code		= KEY_POWER,
+		.desc		= "Power Off Button",
+		.type		= EV_KEY,
+		.active_low	= 0,
+		.wakeup		= 1,
+	}
+};
+
+static struct gpio_keys_platform_data stamp9g20gms_button_data = {
+	.buttons	= stamp9g20gms_buttons,
+	.nbuttons	= ARRAY_SIZE(stamp9g20gms_buttons),
+};
+
+static struct platform_device stamp9g20gms_button_device = {
+	.name		= "gpio-keys",
+	.id		= -1,
+	.num_resources	= 0,
+	.dev		= {
+		.platform_data	= &stamp9g20gms_button_data,
+	}
+};
+
+static void __init stamp9g20gms_add_device_buttons(void)
+{
+	at91_set_gpio_input(GPIO_TRIG_NET_IN, 1);
+	at91_set_deglitch(GPIO_TRIG_NET_IN, 1);
+	at91_set_gpio_input(GPIO_CARD_UNMOUNT_0, 1);
+	at91_set_deglitch(GPIO_CARD_UNMOUNT_0, 1);
+	at91_set_gpio_input(GPIO_CARD_UNMOUNT_1, 1);
+	at91_set_deglitch(GPIO_CARD_UNMOUNT_1, 1);
+	at91_set_gpio_input(GPIO_KEY_POWER, 0);
+	at91_set_deglitch(GPIO_KEY_POWER, 1);
+
+	platform_device_register(&stamp9g20gms_button_device);
+}
+
+/*
+ * I2C
+ */
+static int pcf8574x_0x20_setup(struct i2c_client *client, int gpio,
+				unsigned int ngpio, void *context)
+{
+	int status;
+
+	status = gpio_request(gpio + PCF_GPIO_ETH_DETECT, "eth_det");
+	if (status < 0) {
+		pr_err("error: can't request GPIO%d\n",
+			gpio + PCF_GPIO_ETH_DETECT);
+		return status;
+	}
+	status = gpio_direction_input(gpio + PCF_GPIO_ETH_DETECT);
+	if (status < 0) {
+		pr_err("error: can't setup GPIO%d as input\n",
+			gpio + PCF_GPIO_ETH_DETECT);
+		return status;
+	}
+	status = gpio_export(gpio + PCF_GPIO_ETH_DETECT, false);
+	if (status < 0) {
+		pr_err("error: can't export GPIO%d\n",
+			gpio + PCF_GPIO_ETH_DETECT);
+		return status;
+	}
+	status = gpio_sysfs_set_active_low(gpio + PCF_GPIO_ETH_DETECT, 1);
+	if (status < 0) {
+		pr_err("error: gpio_sysfs_set active_low(GPIO%d, 1)\n",
+			gpio + PCF_GPIO_ETH_DETECT);
+		return status;
+	}
+
+	return 0;
+}
+
+static int pcf8574x_0x20_teardown(struct i2c_client *client, int gpio,
+					unsigned ngpio, void *context)
+{
+	gpio_free(gpio + PCF_GPIO_ETH_DETECT);
+	return 0;
+}
+
+static struct pcf857x_platform_data stamp9g20_pcf20_pdata = {
+	.gpio_base	= GS_IA18_S_PCF_GPIO_BASE0,
+	.n_latch	= (1 << 4),
+	.setup		= pcf8574x_0x20_setup,
+	.teardown	= pcf8574x_0x20_teardown,
+};
+
+static struct pcf857x_platform_data stamp9g20_pcf22_pdata = {
+	.gpio_base	= GS_IA18_S_PCF_GPIO_BASE1,
+};
+
+static struct pcf857x_platform_data stamp9g20_pcf24_pdata = {
+	.gpio_base	= GS_IA18_S_PCF_GPIO_BASE2,
+};
+
+static struct i2c_board_info __initdata i2c_devices[] = {
+	{ /* U1 on the GS_IA18-CB_V3 board */
+		I2C_BOARD_INFO("pcf8574", 0x20),
+		.platform_data = &stamp9g20_pcf20_pdata,
+	},
+	{ /* U1 on the GS_2G_OPT1-A_V0 board (Alarm) */
+		I2C_BOARD_INFO("pcf8574", 0x22),
+		.platform_data = &stamp9g20_pcf22_pdata,
+	},
+	{ /* U1 on the GS_2G-OPT23-A_V0 board (Modem) */
+		I2C_BOARD_INFO("pcf8574", 0x24),
+		.platform_data = &stamp9g20_pcf24_pdata,
+	},
+	{ /* U161 on the GS_IA18_S-MN board */
+		I2C_BOARD_INFO("24c1024", 0x50),
+	},
+	{ /* U162 on the GS_IA18_S-MN board */
+		I2C_BOARD_INFO("24c01", 0x53),
+	},
+};
+
+/*
+ * Compact Flash
+ */
+static struct at91_cf_data __initdata cf1_data = {
+	.irq_pin	= AT91_PIN_PA27,
+	.det_pin	= AT91_PIN_PB30,
+	.rst_pin	= AT91_PIN_PB31,
+	.chipselect	= 5,
+	.flags		= AT91_CF_TRUE_IDE,
+};
+
+/* Power Off by RTC */
+static void stamp9g20gms_power_off(void)
+{
+	pr_notice("Power supply will be switched off automatically now or after 60 seconds without ArmDAS.\n");
+	at91_set_gpio_output(AT91_PIN_PA25, 1);
+	/* Spin to death... */
+	while (1)
+		;
+}
+
+static int __init stamp9g20gms_power_off_init(void)
+{
+	pm_power_off = stamp9g20gms_power_off;
+	return 0;
+}
+
+/* ---------------------------------------------------------------------------*/
+
+void __init carrier_board_init(void)
+{
+	at91_add_device_usbh(&usbh_data);
+	at91_add_device_udc(&udc_data);
+	at91_add_device_eth(&macb_data);
+	stamp9g20gms_leds_init();
+	stamp9g20gms_pcf_leds_init();
+	stamp9g20gms_add_device_buttons();
+	at91_add_device_i2c(i2c_devices, ARRAY_SIZE(i2c_devices));
+	at91_add_device_cf(&cf1_data);
+	at91_add_device_spi(spi_devices, ARRAY_SIZE(spi_devices));
+	stamp9g20gms_power_off_init();
+}
diff --git a/arch/arm/mach-at91/carrier-board-panelcardevb.c b/arch/arm/mach-at91/carrier-board-panelcardevb.c
new file mode 100644
index 0000000..7315bfb
--- /dev/null
+++ b/arch/arm/mach-at91/carrier-board-panelcardevb.c
@@ -0,0 +1,96 @@
+/*
+ *  Copyright (C) 2010 Christian Glindkamp <christian.glindkamp@taskit.de>
+ *			taskit GmbH
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/w1-gpio.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+
+#include <mach/board.h>
+#include <mach/at91sam9_smc.h>
+
+#include "sam9_smc.h"
+#include "generic.h"
+
+void __init carrier_board_map_io(void)
+{
+	/* USART0 on ttyS1. (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI) */
+	at91_register_uart(AT91SAM9260_ID_US0, 1,
+			     ATMEL_UART_CTS | ATMEL_UART_RTS
+			   | ATMEL_UART_DTR | ATMEL_UART_DSR
+			   | ATMEL_UART_DCD | ATMEL_UART_RI);
+}
+
+/*
+ * USB Host port
+ */
+static struct at91_usbh_data __initdata usbh_data = {
+	.ports		= 2,
+};
+
+/*
+ * USB Device port
+ */
+static struct at91_udc_data __initdata udc_data = {
+	.vbus_pin	= AT91_PIN_PA22,
+	.pullup_pin	= 0,		/* pull-up driven by UDC */
+};
+
+/*
+ * MACB Ethernet device
+ */
+static struct at91_eth_data __initdata macb_data = {
+	.phy_irq_pin	= AT91_PIN_PA28,
+	.is_rmii	= 1,
+};
+
+/*
+ * LEDs
+ */
+static struct gpio_led leds[] = {
+	{
+		.name			= "D8",
+		.gpio			= AT91_PIN_PB18,
+		.active_low		= 1,
+		.default_trigger	= "none",
+	},
+	{
+		.name			= "D9",
+		.gpio			= AT91_PIN_PB19,
+		.active_low		= 1,
+		.default_trigger	= "none",
+	},
+	{
+		.name			= "D10",
+		.gpio			= AT91_PIN_PB20,
+		.active_low		= 1,
+		.default_trigger	= "heartbeat",
+	}
+};
+
+void __init carrier_board_init(void)
+{
+	at91_add_device_usbh(&usbh_data);
+	at91_add_device_udc(&udc_data);
+	at91_add_device_eth(&macb_data);
+	at91_gpio_leds(leds, ARRAY_SIZE(leds));
+	at91_add_device_i2c(NULL, 0);
+}
diff --git a/arch/arm/mach-at91/carrier-board-pcontrol-g20.c b/arch/arm/mach-at91/carrier-board-pcontrol-g20.c
new file mode 100644
index 0000000..f442577
--- /dev/null
+++ b/arch/arm/mach-at91/carrier-board-pcontrol-g20.c
@@ -0,0 +1,208 @@
+/*
+ *  Copyright (C) 2010:
+ *		Christian Glindkamp <christian.glindkamp@taskit.de>
+ *			taskit GmbH
+ *		Peter Gsellmann pgsellmann@portner-elektronik.at
+ *			PORTNER-Elektronik
+ *		Igor Plyatov plyatov@gmail.com
+ *			GeoSIG Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+
+#include <mach/board.h>
+#include <mach/at91sam9_smc.h>
+
+#include "sam9_smc.h"
+
+void __init carrier_board_map_io(void)
+{
+	/* USART0 on ttyS1. (Rx, Tx, CTS, RTS) piggyback  A2 */
+	at91_register_uart(AT91SAM9260_ID_US0, 1, ATMEL_UART_CTS
+						| ATMEL_UART_RTS);
+	/* USART1 on ttyS2. (Rx, Tx, CTS, RTS) isolated RS485  X5 */
+	at91_register_uart(AT91SAM9260_ID_US1, 2, ATMEL_UART_CTS
+						| ATMEL_UART_RTS);
+	/* USART2 on ttyS3. (Rx, Tx)  9bit-Bus  Multidrop-mode  X4 */
+	at91_register_uart(AT91SAM9260_ID_US4, 3, 0);
+}
+
+static struct sam9_smc_config __initdata pcontrol_smc_config[2] = {
+	{
+		.ncs_read_setup		= 16,
+		.nrd_setup		= 18,
+		.ncs_write_setup	= 16,
+		.nwe_setup		= 18,
+
+		.ncs_read_pulse		= 63,
+		.nrd_pulse		= 55,
+		.ncs_write_pulse	= 63,
+		.nwe_pulse		= 55,
+
+		.read_cycle		= 127,
+		.write_cycle		= 127,
+
+		.mode			= AT91_SMC_READMODE |
+					  AT91_SMC_WRITEMODE |
+					  AT91_SMC_EXNWMODE_DISABLE |
+					  AT91_SMC_BAT_SELECT |
+					  AT91_SMC_DBW_8 |
+					  AT91_SMC_PS_4 |
+					  AT91_SMC_TDFMODE,
+		.tdf_cycles		= 3,
+	},
+	{
+		.ncs_read_setup		= 0,
+		.nrd_setup		= 0,
+		.ncs_write_setup	= 0,
+		.nwe_setup		= 1,
+
+		.ncs_read_pulse		= 8,
+		.nrd_pulse		= 8,
+		.ncs_write_pulse	= 5,
+		.nwe_pulse		= 4,
+
+		.read_cycle		= 8,
+		.write_cycle		= 7,
+
+		.mode			= AT91_SMC_READMODE |
+					  AT91_SMC_WRITEMODE |
+					  AT91_SMC_EXNWMODE_DISABLE |
+					  AT91_SMC_BAT_SELECT |
+					  AT91_SMC_DBW_16 |
+					  AT91_SMC_PS_8 |
+					  AT91_SMC_TDFMODE,
+		.tdf_cycles		= 1,
+	}
+};
+
+static void __init add_device_pcontrol(void)
+{
+	/* configure chip-select 4 (IO compatible to 8051  X4 ) */
+	sam9_smc_configure(4, &pcontrol_smc_config[0]);
+	/* configure chip-select 7 (FerroRAM 256KiBx16bit MR2A16A  D4 ) */
+	sam9_smc_configure(7, &pcontrol_smc_config[1]);
+}
+
+/*
+ * USB Host port
+ */
+static struct at91_usbh_data __initdata usbh_data = {
+	.ports		= 2,
+};
+
+/*
+ * USB Device port
+ */
+static struct at91_udc_data __initdata udc_data = {
+	.vbus_pin	= AT91_PIN_PA22,	/* Detect +5V bus voltage */
+	.pullup_pin	= AT91_PIN_PA4,		/* K-state, active low */
+};
+
+/*
+ * MACB Ethernet device
+ */
+static struct at91_eth_data __initdata macb_data = {
+	.phy_irq_pin	= AT91_PIN_PA28,
+	.is_rmii	= 1,
+};
+
+/*
+ * I2C devices: eeprom and phy/switch
+ */
+static struct i2c_board_info __initdata i2c_devices[] = {
+	{ /* D7  address width=2, 8KiB */
+		I2C_BOARD_INFO("24c64", 0x50)
+	},
+	{ /* D8  address width=1, 1 byte has 32 bits! */
+		I2C_BOARD_INFO("lan9303", 0x0a)
+	},
+};
+
+/*
+ * LEDs
+ */
+static struct gpio_led leds[] = {
+	{
+		.name			= "LED1",	/* red  H5 */
+		.gpio			= AT91_PIN_PB18,
+		.active_low		= 1,
+		.default_trigger	= "none",	/* supervisor */
+	},
+	{
+		.name			= "LED2",	/* yellow  H7 */
+		.gpio			= AT91_PIN_PB19,
+		.active_low		= 1,
+		.default_trigger	= "mmc0",	/* SD-card activity */
+	},
+	{
+		.name			= "LED3",	/* green  H2 */
+		.gpio			= AT91_PIN_PB20,
+		.active_low		= 1,
+		.default_trigger	= "heartbeat",	/* blinky */
+	},
+	{
+		.name			= "LED4",	/* red  H3 */
+		.gpio			= AT91_PIN_PC6,
+		.active_low		= 1,
+		.default_trigger	= "none",	/* connection lost */
+	},
+	{
+		.name			= "LED5",	/* yellow  H6 */
+		.gpio			= AT91_PIN_PC7,
+		.active_low		= 1,
+		.default_trigger	= "none",	/* unsent data */
+	},
+	{
+		.name			= "LED6",	/* green  H1 */
+		.gpio			= AT91_PIN_PC9,
+		.active_low		= 1,
+		.default_trigger	= "none",	/* snafu */
+	}
+};
+
+/*
+ * SPI devices
+ */
+static struct spi_board_info spi_devices[] = {
+	{
+		.modalias	= "spidev",	/* HMI port  X4 */
+		.chip_select	= 1,
+		.max_speed_hz	= 50 * 1000 * 1000,
+		.bus_num	= 0,
+	},
+	{
+		.modalias	= "spidev",	/* piggyback  A2 */
+		.chip_select	= 0,
+		.max_speed_hz	= 50 * 1000 * 1000,
+		.bus_num	= 1,
+	},
+};
+
+void __init carrier_board_init(void)
+{
+	at91_add_device_usbh(&usbh_data);
+	at91_add_device_udc(&udc_data);
+	at91_add_device_eth(&macb_data);
+	at91_gpio_leds(leds, ARRAY_SIZE(leds));
+	at91_add_device_spi(spi_devices, ARRAY_SIZE(spi_devices));
+	at91_add_device_i2c(i2c_devices, ARRAY_SIZE(i2c_devices));
+	add_device_pcontrol();
+	/* piggyback  A2 */
+	at91_set_gpio_output(AT91_PIN_PB31, 1);
+}
diff --git a/arch/arm/mach-at91/carrier-board-portuxg20.c b/arch/arm/mach-at91/carrier-board-portuxg20.c
new file mode 100644
index 0000000..6d50cb5
--- /dev/null
+++ b/arch/arm/mach-at91/carrier-board-portuxg20.c
@@ -0,0 +1,121 @@
+/*
+ *  Copyright (C) 2010:
+ *		Christian Glindkamp <christian.glindkamp@taskit.de>
+ *			taskit GmbH
+ *		Igor Plyatov plyatov@gmail.com
+ *			GeoSIG Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+
+#include <mach/board.h>
+#include <mach/at91sam9_smc.h>
+
+#include "sam9_smc.h"
+
+void __init carrier_board_map_io(void)
+{
+	/* USART0 on ttyS1. (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI) */
+	at91_register_uart(AT91SAM9260_ID_US0, 1,
+			     ATMEL_UART_CTS | ATMEL_UART_RTS
+			   | ATMEL_UART_DTR | ATMEL_UART_DSR
+			   | ATMEL_UART_DCD | ATMEL_UART_RI);
+	/* USART1 on ttyS2. (Rx, Tx, CTS, RTS) */
+	at91_register_uart(AT91SAM9260_ID_US1, 2,
+			     ATMEL_UART_CTS | ATMEL_UART_RTS);
+	/* USART2 on ttyS3. (Rx, Tx, CTS, RTS) */
+	at91_register_uart(AT91SAM9260_ID_US2, 3,
+			     ATMEL_UART_CTS | ATMEL_UART_RTS);
+	/* USART4 on ttyS5. (Rx, Tx only) */
+	at91_register_uart(AT91SAM9260_ID_US4, 5, 0);
+
+	/* USART5 on ttyS6. (Rx, Tx only) */
+	at91_register_uart(AT91SAM9260_ID_US5, 6, 0);
+}
+
+/*
+ * USB Host port
+ */
+static struct at91_usbh_data __initdata usbh_data = {
+	.ports		= 2,
+};
+
+/*
+ * USB Device port
+ */
+static struct at91_udc_data __initdata udc_data = {
+	.vbus_pin	= AT91_PIN_PC7,
+	.pullup_pin	= 0,		/* pull-up driven by UDC */
+};
+
+/*
+ * MACB Ethernet device
+ */
+static struct at91_eth_data __initdata macb_data = {
+	.phy_irq_pin	= AT91_PIN_PA28,
+	.is_rmii	= 1,
+};
+
+/*
+ * LEDs
+ */
+static struct gpio_led leds[] = {
+	{
+		.name			= "LED2",
+		.gpio			= AT91_PIN_PC5,
+		.default_trigger	= "none",
+	},
+	{
+		.name			= "LED3",
+		.gpio			= AT91_PIN_PC4,
+		.default_trigger	= "none",
+	},
+	{
+		.name			= "LED4",
+		.gpio			= AT91_PIN_PC10,
+		.default_trigger	= "heartbeat",
+	}
+};
+
+/*
+ * SPI devices
+ */
+static struct spi_board_info spi_devices[] = {
+	{
+		.modalias	= "spidev",
+		.chip_select	= 0,
+		.max_speed_hz	= 1 * 1000 * 1000,
+		.bus_num	= 0,
+	},
+	{
+		.modalias	= "spidev",
+		.chip_select	= 0,
+		.max_speed_hz	= 1 * 1000 * 1000,
+		.bus_num	= 1,
+	},
+};
+
+void __init carrier_board_init(void)
+{
+	at91_add_device_usbh(&usbh_data);
+	at91_add_device_udc(&udc_data);
+	at91_add_device_eth(&macb_data);
+	at91_gpio_leds(leds, ARRAY_SIZE(leds));
+	at91_add_device_spi(spi_devices, ARRAY_SIZE(spi_devices));
+	at91_add_device_i2c(NULL, 0);
+}
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 0c66deb..371e6de 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -63,3 +63,6 @@ extern void __init at91_gpio_irq_setup(void);
 
 extern void (*at91_arch_reset)(void);
 extern int at91_extern_irq;
+
+extern void __init carrier_board_map_io(void);
+extern void __init carrier_board_init(void);
diff --git a/arch/arm/mach-at91/include/mach/gms.h b/arch/arm/mach-at91/include/mach/gms.h
new file mode 100644
index 0000000..307c194
--- /dev/null
+++ b/arch/arm/mach-at91/include/mach/gms.h
@@ -0,0 +1,33 @@
+/* Buttons */
+#define GPIO_TRIG_NET_IN		AT91_PIN_PB21
+#define GPIO_CARD_UNMOUNT_0		AT91_PIN_PB13
+#define GPIO_CARD_UNMOUNT_1		AT91_PIN_PB12
+#define GPIO_KEY_POWER			AT91_PIN_PA25
+
+/* PCF8574 0x20 GPIO - U1 on the GS_IA18-CB_V3 board */
+#define GS_IA18_S_PCF_GPIO_BASE0	NR_BUILTIN_GPIO
+#define PCF_GPIO_HDC_POWER		(GS_IA18_S_PCF_GPIO_BASE0 + 0)
+#define PCF_GPIO_WIFI_SETUP		(GS_IA18_S_PCF_GPIO_BASE0 + 1)
+#define PCF_GPIO_WIFI_ENABLE		(GS_IA18_S_PCF_GPIO_BASE0 + 2)
+#define PCF_GPIO_WIFI_RESET		(GS_IA18_S_PCF_GPIO_BASE0 + 3)
+#define PCF_GPIO_ETH_DETECT		4 /* this is a GPI */
+#define PCF_GPIO_GPS_SETUP		(GS_IA18_S_PCF_GPIO_BASE0 + 5)
+#define PCF_GPIO_GPS_STANDBY		(GS_IA18_S_PCF_GPIO_BASE0 + 6)
+#define PCF_GPIO_GPS_POWER		(GS_IA18_S_PCF_GPIO_BASE0 + 7)
+
+/* PCF8574 0x22 GPIO - U1 on the GS_2G_OPT1-A_V0 board (Alarm) */
+#define GS_IA18_S_PCF_GPIO_BASE1	(GS_IA18_S_PCF_GPIO_BASE0 + 8)
+#define PCF_GPIO_ALARM1			(GS_IA18_S_PCF_GPIO_BASE1 + 0)
+#define PCF_GPIO_ALARM2			(GS_IA18_S_PCF_GPIO_BASE1 + 1)
+#define PCF_GPIO_ALARM3			(GS_IA18_S_PCF_GPIO_BASE1 + 2)
+#define PCF_GPIO_ALARM4			(GS_IA18_S_PCF_GPIO_BASE1 + 3)
+/* bits 4, 5, 6 not used */
+#define PCF_GPIO_ALARM_V_RELAY_ON	(GS_IA18_S_PCF_GPIO_BASE1 + 7)
+
+/* PCF8574 0x24 GPIO U1 on the GS_2G-OPT23-A_V0 board (Modem) */
+#define GS_IA18_S_PCF_GPIO_BASE2	(GS_IA18_S_PCF_GPIO_BASE1 + 8)
+#define PCF_GPIO_MODEM_POWER		(GS_IA18_S_PCF_GPIO_BASE2 + 0)
+#define PCF_GPIO_MODEM_RESET		(GS_IA18_S_PCF_GPIO_BASE2 + 3)
+/* bits 1, 2, 4, 5 not used */
+#define PCF_GPIO_TRX_RESET		(GS_IA18_S_PCF_GPIO_BASE2 + 6)
+/* bit 7 not used */
-- 
1.7.0.4

