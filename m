Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab1EZLjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:39:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:57285 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757131Ab1EZLh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:37:57 -0400
From: GuanXuetao <gxt@mprc.pku.edu.cn>
To: arnd@arndb.de
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
Subject: [PATCH 4/6] unicore32: add KBUILD_DEFCONFIG with unicore32_defconfig (old debug_defconfig)
Date: Thu, 26 May 2011 11:36:56 +0000
Message-Id: <3edfc75d669888b1732dbcdbecf73c6f7941c1a4.1306408804.git.gxt@mprc.pku.edu.cn>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1306408804.git.gxt@mprc.pku.edu.cn>
References: <cover.1306408804.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <cover.1306408804.git.gxt@mprc.pku.edu.cn>
References: <cover.1306408804.git.gxt@mprc.pku.edu.cn>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 May 2011 11:37:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <gxt@mprc.pku.edu.cn>

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/Makefile                    |    3 +-
 arch/unicore32/configs/debug_defconfig     |  215 ----------------------------
 arch/unicore32/configs/unicore32_defconfig |  215 ++++++++++++++++++++++++++++
 3 files changed, 217 insertions(+), 216 deletions(-)
 delete mode 100644 arch/unicore32/configs/debug_defconfig
 create mode 100644 arch/unicore32/configs/unicore32_defconfig

diff --git a/arch/unicore32/Makefile b/arch/unicore32/Makefile
index 76a8bee..6555abb 100644
--- a/arch/unicore32/Makefile
+++ b/arch/unicore32/Makefile
@@ -75,7 +75,8 @@ endif
 
 boot			:= arch/unicore32/boot
 
-# Default target when executing plain make
+# Default defconfig and target when executing plain make
+KBUILD_DEFCONFIG	:= $(ARCH)_defconfig
 KBUILD_IMAGE		:= zImage
 
 all:	$(KBUILD_IMAGE)
diff --git a/arch/unicore32/configs/debug_defconfig b/arch/unicore32/configs/debug_defconfig
deleted file mode 100644
index 69b002c..0000000
--- a/arch/unicore32/configs/debug_defconfig
+++ /dev/null
@@ -1,215 +0,0 @@
-### General setup
-CONFIG_EXPERIMENTAL=y
-CONFIG_LOCALVERSION="-debug"
-CONFIG_SWAP=y
-CONFIG_SYSVIPC=y
-CONFIG_POSIX_MQUEUE=y
-CONFIG_HOTPLUG=y
-#	Initial RAM filesystem and RAM disk (initramfs/initrd) support
-#CONFIG_BLK_DEV_INITRD=y
-#CONFIG_INITRAMFS_SOURCE="arch/unicore/ramfs/ramfs_config"
-
-### Enable loadable module support
-CONFIG_MODULES=n
-CONFIG_MODULE_UNLOAD=y
-
-### System Type
-CONFIG_ARCH_PUV3=y
-#	Board Selection
-CONFIG_PUV3_NB0916=y
-#	Processor Features
-CONFIG_CPU_DCACHE_LINE_DISABLE=y
-CONFIG_CPU_TLB_SINGLE_ENTRY_DISABLE=n
-
-### Bus support
-CONFIG_PCI=y
-CONFIG_PCI_LEGACY=n
-
-### Boot options
-#	for debug, adding: earlyprintk=ocd,keep initcall_debug
-#	others support: test_suspend=mem root=/dev/sda
-#	hibernate support: resume=/dev/sda3
-CONFIG_CMDLINE="earlyprintk=ocd,keep ignore_loglevel"
-# TODO: mem=512M video=unifb:1024x600-16@75
-# for nfs: root=/dev/nfs rw nfsroot=192.168.10.88:/home/udb/nfs/,rsize=1024,wsize=1024
-#	ip=192.168.10.83:192.168.10.88:192.168.10.1:255.255.255.0::eth0:off
-CONFIG_CMDLINE_FORCE=y
-
-### Power management options
-CONFIG_PM=y
-CONFIG_HIBERNATION=y
-CONFIG_PM_STD_PARTITION="/dev/sda3"
-CONFIG_CPU_FREQ=n
-CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
-
-### Networking support
-CONFIG_NET=y
-#	Networking options
-CONFIG_PACKET=m
-CONFIG_UNIX=m
-#	TCP/IP networking
-CONFIG_INET=y
-CONFIG_IP_MULTICAST=y
-CONFIG_IP_PNP=y
-CONFIG_IPV6=n
-#	Wireless
-CONFIG_WIRELESS=y
-CONFIG_WIRELESS_EXT=y
-CONFIG_MAC80211=m
-
-### PKUnity SoC Features
-CONFIG_USB_WLAN_HED_AQ3=n
-CONFIG_USB_CMMB_INNOFIDEI=n
-CONFIG_I2C_BATTERY_BQ27200=n
-CONFIG_I2C_EEPROM_AT24=n
-CONFIG_LCD_BACKLIGHT=n
-
-CONFIG_PUV3_MUSB=n
-CONFIG_PUV3_AC97=n
-CONFIG_PUV3_NAND=n
-CONFIG_PUV3_MMC=n
-CONFIG_PUV3_UART=n
-
-### Device Drivers
-#	Memory Technology Device (MTD) support
-CONFIG_MTD=m
-CONFIG_MTD_UBI=m
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=m
-CONFIG_MTD_BLKDEVS=m
-#	RAM/ROM/Flash chip drivers
-CONFIG_MTD_CFI=m
-CONFIG_MTD_JEDECPROBE=m
-CONFIG_MTD_CFI_AMDSTD=m
-#	Mapping drivers for chip access
-CONFIG_MTD_PHYSMAP=m
-
-#	Block devices
-CONFIG_BLK_DEV_LOOP=m
-
-#	SCSI device support
-CONFIG_SCSI=y
-CONFIG_BLK_DEV_SD=y
-CONFIG_BLK_DEV_SR=m
-CONFIG_CHR_DEV_SG=m
-
-#	Serial ATA (prod) and Parallel ATA (experimental) drivers
-CONFIG_ATA=y
-CONFIG_SATA_VIA=y
-
-#	Network device support
-CONFIG_NETDEVICES=y
-CONFIG_NET_ETHERNET=y
-CONFIG_MAC_PUV3=y
-CONFIG_NETDEV_1000=y
-#	Wireless LAN
-CONFIG_WLAN_80211=n
-CONFIG_RT2X00=n
-CONFIG_RT73USB=n
-
-#	Input device support
-CONFIG_INPUT_EVDEV=m
-#	Keyboards
-CONFIG_KEYBOARD_GPIO=m
-
-#	I2C support
-CONFIG_I2C=y
-CONFIG_I2C_PUV3=y
-
-#	Hardware Monitoring support
-#CONFIG_SENSORS_LM75=m
-#	Generic Thermal sysfs driver
-#CONFIG_THERMAL=m
-#CONFIG_THERMAL_HWMON=y
-
-#	Multimedia support
-CONFIG_MEDIA_SUPPORT=n
-CONFIG_VIDEO_DEV=n
-CONFIG_USB_VIDEO_CLASS=n
-
-#	Graphics support
-CONFIG_FB=y
-CONFIG_FB_PUV3_UNIGFX=y
-#	Console display driver support
-CONFIG_VGA_CONSOLE=n
-CONFIG_FRAMEBUFFER_CONSOLE=y
-CONFIG_FONTS=y
-CONFIG_FONT_8x8=y
-CONFIG_FONT_8x16=y
-#	Bootup logo
-CONFIG_LOGO=n
-
-#	Sound card support
-CONFIG_SOUND=m
-#	Advanced Linux Sound Architecture
-CONFIG_SND=m
-CONFIG_SND_MIXER_OSS=m
-CONFIG_SND_PCM_OSS=m
-
-#	USB support
-CONFIG_USB_ARCH_HAS_HCD=n
-CONFIG_USB=n
-CONFIG_USB_DEVICEFS=n
-CONFIG_USB_PRINTER=n
-CONFIG_USB_STORAGE=n
-#	Inventra Highspeed Dual Role Controller
-CONFIG_USB_MUSB_HDRC=n
-
-#	LED Support
-CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
-CONFIG_LEDS_GPIO=y
-#	LED Triggers
-CONFIG_LEDS_TRIGGERS=y
-CONFIG_LEDS_TRIGGER_TIMER=y
-CONFIG_LEDS_TRIGGER_IDE_DISK=y
-CONFIG_LEDS_TRIGGER_HEARTBEAT=y
-
-#	Real Time Clock
-CONFIG_RTC_LIB=y
-CONFIG_RTC_CLASS=y
-CONFIG_RTC_DRV_PUV3=y
-
-### File systems
-CONFIG_EXT2_FS=m
-CONFIG_EXT3_FS=y
-CONFIG_EXT4_FS=y
-CONFIG_FUSE_FS=m
-#	CD-ROM/DVD Filesystems
-CONFIG_ISO9660_FS=m
-CONFIG_JOLIET=y
-CONFIG_UDF_FS=m
-#	DOS/FAT/NT Filesystems
-CONFIG_VFAT_FS=m
-#	Pseudo filesystems
-CONFIG_PROC_FS=y
-CONFIG_SYSFS=y
-CONFIG_TMPFS=y
-#	Miscellaneous filesystems
-CONFIG_MISC_FILESYSTEMS=y
-CONFIG_JFFS2_FS=m
-CONFIG_UBIFS_FS=m
-#	Network File Systems
-CONFIG_NETWORK_FILESYSTEMS=y
-CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
-CONFIG_ROOT_NFS=y
-#	Partition Types
-CONFIG_PARTITION_ADVANCED=y
-CONFIG_MSDOS_PARTITION=y
-#	Native language support
-CONFIG_NLS=y
-CONFIG_NLS_CODEPAGE_437=m
-CONFIG_NLS_CODEPAGE_936=m
-CONFIG_NLS_ISO8859_1=m
-CONFIG_NLS_UTF8=m
-
-### Kernel hacking
-CONFIG_FRAME_WARN=8096
-CONFIG_MAGIC_SYSRQ=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_PROVE_LOCKING=n
-CONFIG_DEBUG_BUGVERBOSE=y
-CONFIG_FRAME_POINTER=y
-CONFIG_DEBUG_LL=y
-
diff --git a/arch/unicore32/configs/unicore32_defconfig b/arch/unicore32/configs/unicore32_defconfig
new file mode 100644
index 0000000..6265e73
--- /dev/null
+++ b/arch/unicore32/configs/unicore32_defconfig
@@ -0,0 +1,215 @@
+### General setup
+CONFIG_EXPERIMENTAL=y
+CONFIG_LOCALVERSION="-unicore32"
+CONFIG_SWAP=y
+CONFIG_SYSVIPC=y
+CONFIG_POSIX_MQUEUE=y
+CONFIG_HOTPLUG=y
+#	Initial RAM filesystem and RAM disk (initramfs/initrd) support
+#CONFIG_BLK_DEV_INITRD=y
+#CONFIG_INITRAMFS_SOURCE="arch/unicore/ramfs/ramfs_config"
+
+### Enable loadable module support
+CONFIG_MODULES=n
+CONFIG_MODULE_UNLOAD=y
+
+### System Type
+CONFIG_ARCH_PUV3=y
+#	Board Selection
+CONFIG_PUV3_NB0916=y
+#	Processor Features
+CONFIG_CPU_DCACHE_LINE_DISABLE=y
+CONFIG_CPU_TLB_SINGLE_ENTRY_DISABLE=n
+
+### Bus support
+CONFIG_PCI=y
+CONFIG_PCI_LEGACY=n
+
+### Boot options
+#	for debug, adding: earlyprintk=ocd,keep initcall_debug
+#	others support: test_suspend=mem root=/dev/sda
+#	hibernate support: resume=/dev/sda3
+CONFIG_CMDLINE="earlyprintk=ocd,keep ignore_loglevel"
+# TODO: mem=512M video=unifb:1024x600-16@75
+# for nfs: root=/dev/nfs rw nfsroot=192.168.10.88:/home/udb/nfs/,rsize=1024,wsize=1024
+#	ip=192.168.10.83:192.168.10.88:192.168.10.1:255.255.255.0::eth0:off
+CONFIG_CMDLINE_FORCE=y
+
+### Power management options
+CONFIG_PM=y
+CONFIG_HIBERNATION=y
+CONFIG_PM_STD_PARTITION="/dev/sda3"
+CONFIG_CPU_FREQ=n
+CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
+
+### Networking support
+CONFIG_NET=y
+#	Networking options
+CONFIG_PACKET=m
+CONFIG_UNIX=m
+#	TCP/IP networking
+CONFIG_INET=y
+CONFIG_IP_MULTICAST=y
+CONFIG_IP_PNP=y
+CONFIG_IPV6=n
+#	Wireless
+CONFIG_WIRELESS=y
+CONFIG_WIRELESS_EXT=y
+CONFIG_MAC80211=m
+
+### PKUnity SoC Features
+CONFIG_USB_WLAN_HED_AQ3=n
+CONFIG_USB_CMMB_INNOFIDEI=n
+CONFIG_I2C_BATTERY_BQ27200=n
+CONFIG_I2C_EEPROM_AT24=n
+CONFIG_LCD_BACKLIGHT=n
+
+CONFIG_PUV3_MUSB=n
+CONFIG_PUV3_AC97=n
+CONFIG_PUV3_NAND=n
+CONFIG_PUV3_MMC=n
+CONFIG_PUV3_UART=n
+
+### Device Drivers
+#	Memory Technology Device (MTD) support
+CONFIG_MTD=m
+CONFIG_MTD_UBI=m
+CONFIG_MTD_PARTITIONS=y
+CONFIG_MTD_CHAR=m
+CONFIG_MTD_BLKDEVS=m
+#	RAM/ROM/Flash chip drivers
+CONFIG_MTD_CFI=m
+CONFIG_MTD_JEDECPROBE=m
+CONFIG_MTD_CFI_AMDSTD=m
+#	Mapping drivers for chip access
+CONFIG_MTD_PHYSMAP=m
+
+#	Block devices
+CONFIG_BLK_DEV_LOOP=m
+
+#	SCSI device support
+CONFIG_SCSI=y
+CONFIG_BLK_DEV_SD=y
+CONFIG_BLK_DEV_SR=m
+CONFIG_CHR_DEV_SG=m
+
+#	Serial ATA (prod) and Parallel ATA (experimental) drivers
+CONFIG_ATA=y
+CONFIG_SATA_VIA=y
+
+#	Network device support
+CONFIG_NETDEVICES=y
+CONFIG_NET_ETHERNET=y
+CONFIG_MAC_PUV3=y
+CONFIG_NETDEV_1000=y
+#	Wireless LAN
+CONFIG_WLAN_80211=n
+CONFIG_RT2X00=n
+CONFIG_RT73USB=n
+
+#	Input device support
+CONFIG_INPUT_EVDEV=m
+#	Keyboards
+CONFIG_KEYBOARD_GPIO=m
+
+#	I2C support
+CONFIG_I2C=y
+CONFIG_I2C_PUV3=y
+
+#	Hardware Monitoring support
+#CONFIG_SENSORS_LM75=m
+#	Generic Thermal sysfs driver
+#CONFIG_THERMAL=m
+#CONFIG_THERMAL_HWMON=y
+
+#	Multimedia support
+CONFIG_MEDIA_SUPPORT=n
+CONFIG_VIDEO_DEV=n
+CONFIG_USB_VIDEO_CLASS=n
+
+#	Graphics support
+CONFIG_FB=y
+CONFIG_FB_PUV3_UNIGFX=y
+#	Console display driver support
+CONFIG_VGA_CONSOLE=n
+CONFIG_FRAMEBUFFER_CONSOLE=y
+CONFIG_FONTS=y
+CONFIG_FONT_8x8=y
+CONFIG_FONT_8x16=y
+#	Bootup logo
+CONFIG_LOGO=n
+
+#	Sound card support
+CONFIG_SOUND=m
+#	Advanced Linux Sound Architecture
+CONFIG_SND=m
+CONFIG_SND_MIXER_OSS=m
+CONFIG_SND_PCM_OSS=m
+
+#	USB support
+CONFIG_USB_ARCH_HAS_HCD=n
+CONFIG_USB=n
+CONFIG_USB_DEVICEFS=n
+CONFIG_USB_PRINTER=n
+CONFIG_USB_STORAGE=n
+#	Inventra Highspeed Dual Role Controller
+CONFIG_USB_MUSB_HDRC=n
+
+#	LED Support
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_GPIO=y
+#	LED Triggers
+CONFIG_LEDS_TRIGGERS=y
+CONFIG_LEDS_TRIGGER_TIMER=y
+CONFIG_LEDS_TRIGGER_IDE_DISK=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+
+#	Real Time Clock
+CONFIG_RTC_LIB=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_DRV_PUV3=y
+
+### File systems
+CONFIG_EXT2_FS=m
+CONFIG_EXT3_FS=y
+CONFIG_EXT4_FS=y
+CONFIG_FUSE_FS=m
+#	CD-ROM/DVD Filesystems
+CONFIG_ISO9660_FS=m
+CONFIG_JOLIET=y
+CONFIG_UDF_FS=m
+#	DOS/FAT/NT Filesystems
+CONFIG_VFAT_FS=m
+#	Pseudo filesystems
+CONFIG_PROC_FS=y
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+#	Miscellaneous filesystems
+CONFIG_MISC_FILESYSTEMS=y
+CONFIG_JFFS2_FS=m
+CONFIG_UBIFS_FS=m
+#	Network File Systems
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+CONFIG_ROOT_NFS=y
+#	Partition Types
+CONFIG_PARTITION_ADVANCED=y
+CONFIG_MSDOS_PARTITION=y
+#	Native language support
+CONFIG_NLS=y
+CONFIG_NLS_CODEPAGE_437=m
+CONFIG_NLS_CODEPAGE_936=m
+CONFIG_NLS_ISO8859_1=m
+CONFIG_NLS_UTF8=m
+
+### Kernel hacking
+CONFIG_FRAME_WARN=8096
+CONFIG_MAGIC_SYSRQ=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_PROVE_LOCKING=n
+CONFIG_DEBUG_BUGVERBOSE=y
+CONFIG_FRAME_POINTER=y
+CONFIG_DEBUG_LL=y
+
-- 
1.7.5.2

