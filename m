Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1FLHtM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 03:49:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33957 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab1FLHtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 03:49:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XJB2NzFnkK2zU5SYpG0xUw6Z40IEmPsCDEOFV60MAsjNkmK7j+M2G5CWfLq/0NZE4o
         Y++ATTk2pG0e9qijOx+Sk2y5vX/Kp2BG4QnytwcQqLwqGTkwdQ0wIEyaaCqrsn/xGDm3
         XcDTZ6HKa0rSx/K796k0kj7AIQTeA2SVWSnQc=
From: Wu DaoGuang <wdgvip@gmail.com>
To: linux@arm.linux.org.uk, ben-linux@fluff.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wu DaoGuang <wdgvip@gmail.com>
Subject: [PATCH] Add ok2440 development board support.
Date: Sun, 12 Jun 2011 15:48:49 +0800
Message-Id: <1307864929-23828-1-git-send-email-wdgvip@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch has been modified for the second time .Reduced the size
of the file ok2440_defconfig and updated to the latest APIs.

The ok2440 development board is based on SAMSUNG's S3C2440
microprocessor,which is developed with ARM920T core.

Thanks to Vasily Khoruzhick <anarsoul@gmail.com> for detailed
proposal in this patch.

This patch is against v3.0-rc2.

Signed-off-by: Wu DaoGuang <wdgvip@gmail.com>
---
 arch/arm/configs/ok2440_defconfig   |  384 +++++++++++++++++++++++++++++
 arch/arm/mach-s3c2440/Kconfig       |   10 +
 arch/arm/mach-s3c2440/Makefile      |    1 +
 arch/arm/mach-s3c2440/mach-ok2440.c |  457 +++++++++++++++++++++++++++++++++++
 4 files changed, 852 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/configs/ok2440_defconfig
 create mode 100644 arch/arm/mach-s3c2440/mach-ok2440.c

diff --git a/arch/arm/configs/ok2440_defconfig b/arch/arm/configs/ok2440_defconfig
new file mode 100644
index 0000000..45f2c86
--- /dev/null
+++ b/arch/arm/configs/ok2440_defconfig
@@ -0,0 +1,384 @@
+CONFIG_EXPERIMENTAL=y
+# CONFIG_LOCALVERSION_AUTO is not set
+CONFIG_SYSVIPC=y
+CONFIG_POSIX_MQUEUE=y
+CONFIG_RELAY=y
+CONFIG_UTS_NS=y
+CONFIG_IPC_NS=y
+CONFIG_BLK_DEV_INITRD=y
+# CONFIG_COMPAT_BRK is not set
+CONFIG_MODULES=y
+CONFIG_MODULE_FORCE_LOAD=y
+CONFIG_MODULE_UNLOAD=y
+CONFIG_MODULE_FORCE_UNLOAD=y
+# CONFIG_BLK_DEV_BSG is not set
+CONFIG_BLK_DEV_INTEGRITY=y
+CONFIG_ARCH_S3C2410=y
+CONFIG_S3C_ADC=y
+CONFIG_S3C24XX_PWM=y
+CONFIG_MACH_OK2440=y
+CONFIG_AEABI=y
+# CONFIG_OABI_COMPAT is not set
+CONFIG_KEXEC=y
+CONFIG_CPU_IDLE=y
+CONFIG_BINFMT_AOUT=m
+CONFIG_BINFMT_MISC=m
+CONFIG_PM=y
+CONFIG_APM_EMULATION=y
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_XFRM_USER=m
+CONFIG_NET_KEY=m
+CONFIG_INET=y
+CONFIG_IP_MULTICAST=y
+CONFIG_IP_ADVANCED_ROUTER=y
+CONFIG_IP_MULTIPLE_TABLES=y
+CONFIG_IP_ROUTE_MULTIPATH=y
+CONFIG_IP_ROUTE_VERBOSE=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+CONFIG_IP_PNP_BOOTP=y
+CONFIG_IP_PNP_RARP=y
+CONFIG_IP_MROUTE=y
+CONFIG_IP_PIMSM_V1=y
+CONFIG_IP_PIMSM_V2=y
+CONFIG_SYN_COOKIES=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
+CONFIG_INET_DIAG=m
+# CONFIG_IPV6 is not set
+CONFIG_NETFILTER=y
+CONFIG_BRIDGE=m
+CONFIG_VLAN_8021Q=m
+CONFIG_VLAN_8021Q_GVRP=y
+CONFIG_NET_PKTGEN=m
+CONFIG_BT=m
+CONFIG_BT_L2CAP=m
+CONFIG_BT_SCO=m
+CONFIG_BT_RFCOMM=m
+CONFIG_BT_RFCOMM_TTY=y
+CONFIG_BT_BNEP=m
+CONFIG_BT_BNEP_MC_FILTER=y
+CONFIG_BT_BNEP_PROTO_FILTER=y
+CONFIG_BT_HIDP=m
+CONFIG_BT_HCIBTUSB=m
+CONFIG_BT_HCIBTSDIO=m
+CONFIG_BT_HCIUART=m
+CONFIG_BT_HCIUART_H4=y
+CONFIG_BT_HCIUART_BCSP=y
+CONFIG_BT_HCIUART_LL=y
+CONFIG_BT_HCIBCM203X=m
+CONFIG_BT_HCIBPA10X=m
+CONFIG_BT_HCIBFUSB=m
+CONFIG_BT_HCIVHCI=m
+CONFIG_CFG80211=m
+CONFIG_CFG80211_REG_DEBUG=y
+CONFIG_MAC80211=m
+CONFIG_MAC80211_MESH=y
+CONFIG_MAC80211_LEDS=y
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+# CONFIG_FIRMWARE_IN_KERNEL is not set
+CONFIG_CONNECTOR=m
+CONFIG_MTD=y
+CONFIG_MTD_CONCAT=y
+CONFIG_MTD_PARTITIONS=y
+CONFIG_MTD_CMDLINE_PARTS=y
+CONFIG_MTD_CHAR=y
+CONFIG_MTD_BLOCK=y
+CONFIG_FTL=y
+CONFIG_NFTL=y
+CONFIG_NFTL_RW=y
+CONFIG_INFTL=y
+CONFIG_RFD_FTL=y
+CONFIG_MTD_CFI=y
+CONFIG_MTD_JEDECPROBE=y
+CONFIG_MTD_CFI_AMDSTD=y
+CONFIG_MTD_CFI_STAA=y
+CONFIG_MTD_RAM=y
+CONFIG_MTD_ROM=y
+CONFIG_MTD_NAND=y
+CONFIG_MTD_NAND_VERIFY_WRITE=y
+CONFIG_MTD_NAND_S3C2410=y
+CONFIG_MTD_NAND_PLATFORM=y
+CONFIG_MTD_LPDDR=y
+CONFIG_BLK_DEV_LOOP=m
+CONFIG_BLK_DEV_NBD=m
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_SIZE=65536
+CONFIG_CDROM_PKTCDVD=m
+CONFIG_SENSORS_TSL2550=m
+CONFIG_SCSI=m
+# CONFIG_SCSI_PROC_FS is not set
+CONFIG_BLK_DEV_SD=m
+CONFIG_CHR_DEV_SG=m
+# CONFIG_SCSI_LOWLEVEL is not set
+CONFIG_NETDEVICES=y
+CONFIG_TUN=m
+CONFIG_NET_ETHERNET=y
+CONFIG_DM9000=y
+# CONFIG_NETDEV_1000 is not set
+# CONFIG_NETDEV_10000 is not set
+CONFIG_HOSTAP=m
+CONFIG_HOSTAP_FIRMWARE=y
+CONFIG_HOSTAP_FIRMWARE_NVRAM=y
+CONFIG_LIBERTAS=m
+CONFIG_LIBERTAS_SDIO=m
+CONFIG_ZD1211RW=m
+CONFIG_ZD1211RW_DEBUG=y
+CONFIG_PPP=m
+CONFIG_PPP_MULTILINK=y
+CONFIG_PPP_FILTER=y
+CONFIG_PPP_ASYNC=m
+CONFIG_PPP_SYNC_TTY=m
+CONFIG_PPP_DEFLATE=m
+CONFIG_PPP_BSDCOMP=m
+CONFIG_PPP_MPPE=m
+CONFIG_INPUT_FF_MEMLESS=y
+CONFIG_INPUT_EVDEV=y
+CONFIG_INPUT_EVBUG=m
+# CONFIG_KEYBOARD_ATKBD is not set
+CONFIG_KEYBOARD_GPIO=y
+CONFIG_INPUT_TOUCHSCREEN=y
+CONFIG_SERIO_RAW=y
+CONFIG_VT_HW_CONSOLE_BINDING=y
+CONFIG_SERIAL_SAMSUNG=y
+CONFIG_SERIAL_SAMSUNG_CONSOLE=y
+CONFIG_LEGACY_PTY_COUNT=128
+CONFIG_IPMI_HANDLER=m
+CONFIG_IPMI_DEVICE_INTERFACE=m
+CONFIG_IPMI_SI=m
+CONFIG_IPMI_WATCHDOG=m
+CONFIG_IPMI_POWEROFF=m
+CONFIG_HW_RANDOM=y
+CONFIG_I2C=y
+CONFIG_I2C_CHARDEV=y
+CONFIG_I2C_S3C2410=y
+CONFIG_I2C_SIMTEC=y
+CONFIG_SPI=y
+CONFIG_SPI_S3C24XX=y
+CONFIG_SPI_SPIDEV=y
+CONFIG_GPIO_SYSFS=y
+CONFIG_SENSORS_LM75=y
+CONFIG_THERMAL=m
+CONFIG_WATCHDOG=y
+CONFIG_S3C2410_WATCHDOG=y
+CONFIG_VIDEO_OUTPUT_CONTROL=y
+CONFIG_FB=y
+CONFIG_FIRMWARE_EDID=y
+CONFIG_FB_MODE_HELPERS=y
+CONFIG_FB_TILEBLITTING=y
+CONFIG_FB_S3C2410=y
+CONFIG_BACKLIGHT_LCD_SUPPORT=y
+CONFIG_LCD_CLASS_DEVICE=y
+CONFIG_LCD_PLATFORM=y
+CONFIG_BACKLIGHT_CLASS_DEVICE=y
+# CONFIG_BACKLIGHT_GENERIC is not set
+CONFIG_BACKLIGHT_PWM=y
+CONFIG_DISPLAY_SUPPORT=y
+# CONFIG_VGA_CONSOLE is not set
+CONFIG_FRAMEBUFFER_CONSOLE=y
+CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
+CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
+CONFIG_FONTS=y
+CONFIG_FONT_8x8=y
+CONFIG_FONT_MINI_4x6=y
+CONFIG_LOGO=y
+# CONFIG_LOGO_LINUX_MONO is not set
+# CONFIG_LOGO_LINUX_VGA16 is not set
+CONFIG_SOUND=y
+CONFIG_SND=y
+CONFIG_SND_SEQUENCER=m
+CONFIG_SND_SEQ_DUMMY=m
+CONFIG_SND_MIXER_OSS=m
+CONFIG_SND_PCM_OSS=m
+CONFIG_SND_SEQUENCER_OSS=y
+CONFIG_SND_DYNAMIC_MINORS=y
+# CONFIG_SND_DRIVERS is not set
+# CONFIG_SND_ARM is not set
+# CONFIG_SND_SPI is not set
+CONFIG_SND_USB_AUDIO=m
+CONFIG_SND_USB_CAIAQ=m
+CONFIG_SND_USB_CAIAQ_INPUT=y
+CONFIG_SND_SOC=y
+CONFIG_SND_S3C24XX_SOC=y
+CONFIG_HIDRAW=y
+CONFIG_HID_PID=y
+CONFIG_USB_HIDDEV=y
+CONFIG_HID_GYRATION=y
+CONFIG_HID_NTRIG=y
+CONFIG_HID_PANTHERLORD=y
+CONFIG_HID_PETALYNX=y
+CONFIG_HID_SAMSUNG=y
+CONFIG_HID_SONY=y
+CONFIG_HID_SUNPLUS=y
+CONFIG_HID_TOPSEED=y
+CONFIG_USB=y
+CONFIG_USB_DEVICEFS=y
+# CONFIG_USB_DEVICE_CLASS is not set
+CONFIG_USB_OHCI_HCD=y
+CONFIG_USB_ACM=m
+CONFIG_USB_WDM=m
+CONFIG_USB_STORAGE=m
+CONFIG_USB_STORAGE_DATAFAB=m
+CONFIG_USB_STORAGE_ISD200=m
+CONFIG_USB_STORAGE_USBAT=m
+CONFIG_USB_STORAGE_SDDR09=m
+CONFIG_USB_STORAGE_SDDR55=m
+CONFIG_USB_STORAGE_JUMPSHOT=m
+CONFIG_USB_STORAGE_ALAUDA=m
+CONFIG_USB_LIBUSUAL=y
+CONFIG_USB_SERIAL=m
+CONFIG_USB_SERIAL_CP210X=m
+CONFIG_USB_SERIAL_FTDI_SIO=m
+CONFIG_USB_SERIAL_SPCP8X5=m
+CONFIG_USB_GADGET=y
+CONFIG_USB_GADGET_S3C2410=y
+CONFIG_USB_ZERO=m
+CONFIG_USB_ETH=m
+CONFIG_USB_GADGETFS=m
+CONFIG_USB_FILE_STORAGE=m
+CONFIG_USB_G_SERIAL=m
+CONFIG_USB_CDC_COMPOSITE=m
+CONFIG_MMC=y
+CONFIG_SDIO_UART=y
+CONFIG_MMC_SDHCI=y
+CONFIG_MMC_SPI=y
+CONFIG_MMC_S3C=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_S3C24XX=y
+CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_TRIGGER_TIMER=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+CONFIG_LEDS_TRIGGER_GPIO=y
+CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_INTF_DEV_UIE_EMUL=y
+CONFIG_RTC_DRV_S3C=y
+CONFIG_DMADEVICES=y
+CONFIG_EXT2_FS=m
+CONFIG_EXT2_FS_XATTR=y
+CONFIG_EXT2_FS_POSIX_ACL=y
+CONFIG_EXT2_FS_SECURITY=y
+CONFIG_EXT3_FS=y
+CONFIG_EXT3_FS_POSIX_ACL=y
+CONFIG_EXT3_FS_SECURITY=y
+CONFIG_INOTIFY=y
+CONFIG_AUTOFS_FS=y
+CONFIG_AUTOFS4_FS=y
+CONFIG_MSDOS_FS=y
+CONFIG_VFAT_FS=y
+CONFIG_TMPFS=y
+CONFIG_TMPFS_POSIX_ACL=y
+CONFIG_CONFIGFS_FS=m
+CONFIG_JFFS2_FS=y
+CONFIG_CRAMFS=y
+CONFIG_ROMFS_FS=y
+CONFIG_ROMFS_BACKED_BY_BOTH=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+CONFIG_NFS_V3_ACL=y
+CONFIG_NFS_V4=y
+CONFIG_ROOT_NFS=y
+CONFIG_PARTITION_ADVANCED=y
+CONFIG_BSD_DISKLABEL=y
+CONFIG_MINIX_SUBPARTITION=y
+CONFIG_SOLARIS_X86_PARTITION=y
+CONFIG_UNIXWARE_DISKLABEL=y
+CONFIG_LDM_PARTITION=y
+CONFIG_EFI_PARTITION=y
+CONFIG_NLS_DEFAULT="cp437"
+CONFIG_NLS_CODEPAGE_437=m
+CONFIG_NLS_CODEPAGE_737=m
+CONFIG_NLS_CODEPAGE_775=m
+CONFIG_NLS_CODEPAGE_850=m
+CONFIG_NLS_CODEPAGE_852=m
+CONFIG_NLS_CODEPAGE_855=m
+CONFIG_NLS_CODEPAGE_857=m
+CONFIG_NLS_CODEPAGE_860=m
+CONFIG_NLS_CODEPAGE_861=m
+CONFIG_NLS_CODEPAGE_862=m
+CONFIG_NLS_CODEPAGE_863=m
+CONFIG_NLS_CODEPAGE_864=m
+CONFIG_NLS_CODEPAGE_865=m
+CONFIG_NLS_CODEPAGE_866=m
+CONFIG_NLS_CODEPAGE_869=m
+CONFIG_NLS_CODEPAGE_936=m
+CONFIG_NLS_CODEPAGE_950=m
+CONFIG_NLS_CODEPAGE_932=m
+CONFIG_NLS_CODEPAGE_949=m
+CONFIG_NLS_CODEPAGE_874=m
+CONFIG_NLS_ISO8859_8=m
+CONFIG_NLS_CODEPAGE_1250=m
+CONFIG_NLS_CODEPAGE_1251=m
+CONFIG_NLS_ASCII=m
+CONFIG_NLS_ISO8859_1=m
+CONFIG_NLS_ISO8859_2=m
+CONFIG_NLS_ISO8859_3=m
+CONFIG_NLS_ISO8859_4=m
+CONFIG_NLS_ISO8859_5=m
+CONFIG_NLS_ISO8859_6=m
+CONFIG_NLS_ISO8859_7=m
+CONFIG_NLS_ISO8859_9=m
+CONFIG_NLS_ISO8859_13=m
+CONFIG_NLS_ISO8859_14=m
+CONFIG_NLS_ISO8859_15=m
+CONFIG_NLS_KOI8_R=m
+CONFIG_NLS_KOI8_U=m
+CONFIG_NLS_UTF8=m
+# CONFIG_ENABLE_WARN_DEPRECATED is not set
+# CONFIG_ENABLE_MUST_CHECK is not set
+CONFIG_STRIP_ASM_SYMS=y
+CONFIG_DEBUG_FS=y
+CONFIG_DEBUG_KERNEL=y
+# CONFIG_SCHED_DEBUG is not set
+CONFIG_DEBUG_INFO=y
+# CONFIG_RCU_CPU_STALL_DETECTOR is not set
+CONFIG_SYSCTL_SYSCALL_CHECK=y
+CONFIG_DEBUG_USER=y
+CONFIG_KEYS=y
+CONFIG_CRYPTO_FIPS=y
+CONFIG_CRYPTO_NULL=m
+CONFIG_CRYPTO_CRYPTD=m
+CONFIG_CRYPTO_AUTHENC=m
+CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_CCM=m
+CONFIG_CRYPTO_GCM=m
+CONFIG_CRYPTO_CTS=m
+CONFIG_CRYPTO_ECB=y
+CONFIG_CRYPTO_LRW=m
+CONFIG_CRYPTO_PCBC=m
+CONFIG_CRYPTO_XTS=m
+CONFIG_CRYPTO_HMAC=y
+CONFIG_CRYPTO_XCBC=m
+CONFIG_CRYPTO_MD4=m
+CONFIG_CRYPTO_MICHAEL_MIC=y
+CONFIG_CRYPTO_RMD128=m
+CONFIG_CRYPTO_RMD160=m
+CONFIG_CRYPTO_RMD256=m
+CONFIG_CRYPTO_RMD320=m
+CONFIG_CRYPTO_SHA256=m
+CONFIG_CRYPTO_SHA512=m
+CONFIG_CRYPTO_TGR192=m
+CONFIG_CRYPTO_WP512=m
+CONFIG_CRYPTO_AES=y
+CONFIG_CRYPTO_ANUBIS=m
+CONFIG_CRYPTO_ARC4=y
+CONFIG_CRYPTO_BLOWFISH=m
+CONFIG_CRYPTO_CAMELLIA=m
+CONFIG_CRYPTO_CAST5=m
+CONFIG_CRYPTO_CAST6=m
+CONFIG_CRYPTO_FCRYPT=m
+CONFIG_CRYPTO_KHAZAD=m
+CONFIG_CRYPTO_SALSA20=m
+CONFIG_CRYPTO_SEED=m
+CONFIG_CRYPTO_SERPENT=m
+CONFIG_CRYPTO_TEA=m
+CONFIG_CRYPTO_TWOFISH=m
+CONFIG_CRYPTO_DEFLATE=m
+CONFIG_CRYPTO_ZLIB=m
+CONFIG_CRYPTO_LZO=m
+CONFIG_CRC_T10DIF=y
+CONFIG_LIBCRC32C=m
diff --git a/arch/arm/mach-s3c2440/Kconfig b/arch/arm/mach-s3c2440/Kconfig
index 50825a3..1214909 100644
--- a/arch/arm/mach-s3c2440/Kconfig
+++ b/arch/arm/mach-s3c2440/Kconfig
@@ -176,6 +176,16 @@ config MACH_AT2440EVB
 	help
 	  Say Y here if you are using the AT2440EVB development board
 
+config MACH_OK2440
+	bool "OK2440 development board"
+	select CPU_S3C2440
+	select S3C2440_XTAL_12000000
+	select S3C_DEV_NAND
+	select S3C_DEV_USB_HOST
+	help
+	  Say y here to select support for OK2440. Now it is widely used for
+	  many students and Companies.
+
 config MACH_MINI2440
 	bool "MINI2440 development board"
 	select CPU_S3C2440
diff --git a/arch/arm/mach-s3c2440/Makefile b/arch/arm/mach-s3c2440/Makefile
index d5440fa..da4ad71 100644
--- a/arch/arm/mach-s3c2440/Makefile
+++ b/arch/arm/mach-s3c2440/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_MACH_ANUBIS)	+= mach-anubis.o
 obj-$(CONFIG_MACH_OSIRIS)	+= mach-osiris.o
 obj-$(CONFIG_MACH_RX3715)	+= mach-rx3715.o
 obj-$(CONFIG_ARCH_S3C2440)	+= mach-smdk2440.o
+obj-$(CONFIG_MACH_OK2440)	+= mach-ok2440.o
 obj-$(CONFIG_MACH_NEXCODER_2440) += mach-nexcoder.o
 obj-$(CONFIG_MACH_AT2440EVB) += mach-at2440evb.o
 obj-$(CONFIG_MACH_MINI2440) += mach-mini2440.o
diff --git a/arch/arm/mach-s3c2440/mach-ok2440.c b/arch/arm/mach-s3c2440/mach-ok2440.c
new file mode 100644
index 0000000..43700e8
--- /dev/null
+++ b/arch/arm/mach-s3c2440/mach-ok2440.c
@@ -0,0 +1,457 @@
+/* linux/arch/arm/mach-s3c2440/mach-ok2440.c
+ *
+ *	Copyright (c) 2011  Feiling Embedded
+ *	Base on mach-smdk2440.c by Ben Dooks <ben@simtec.co.uk>
+ *
+ *	Wu DaoGuang <wdgvip@gmail.com>
+ *
+ * Thanks to Dimity Andric and TomTom for the loan of an SMDK2440.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+*/
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/timer.h>
+#include <linux/init.h>
+#include <linux/serial_core.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/io.h>
+#include <linux/dm9000.h>
+#include <linux/i2c.h>
+#include <linux/i2c/at24.h>
+#include <linux/mmc/host.h>
+#include <linux/memblock.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
+
+#include <linux/leds.h>
+#include <linux/pwm.h>
+#include <linux/gpio.h>
+#include <linux/gpio_keys.h>
+
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/nand.h>
+#include <linux/mtd/nand_ecc.h>
+#include <linux/mtd/partitions.h>
+
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+
+#include <mach/hardware.h>
+#include <asm/irq.h>
+#include <asm/sizes.h>
+#include <asm/mach-types.h>
+
+#include <plat/regs-serial.h>
+#include <plat/nand.h>
+#include <plat/iic.h>
+#include <plat/udc.h>
+#include <plat/mci.h>
+
+#include <mach/regs-gpio.h>
+#include <mach/leds-gpio.h>
+#include <mach/regs-gpioj.h>
+#include <mach/regs-lcd.h>
+#include <mach/regs-mem.h>
+#include <mach/irqs.h>
+
+
+#include <mach/idle.h>
+#include <mach/fb.h>
+#include <plat/gpio-core.h>
+#include <plat/gpio-cfg-helpers.h>
+#include <plat/gpio-cfg.h>
+#include <plat/usb-control.h>
+
+#include <plat/s3c2410.h>
+#include <plat/s3c244x.h>
+#include <plat/clock.h>
+#include <plat/devs.h>
+#include <plat/cpu.h>
+#include <plat/pm.h>
+
+#include <plat/common-smdk.h>
+#include <sound/s3c24xx_uda134x.h>
+
+#define MACH_OK2440_DM9K_BASE (S3C2410_CS4 + 0x300)
+
+static struct map_desc ok2440_iodesc[] __initdata = {
+	/* ISA IO Space map (memory space selected by A24) */
+
+	{
+		.virtual	= (u32)S3C24XX_VA_ISA_WORD,
+		.pfn		= __phys_to_pfn(S3C2410_CS2),
+		.length		= 0x10000,
+		.type		= MT_DEVICE,
+	}, {
+		.virtual	= (u32)S3C24XX_VA_ISA_WORD + 0x10000,
+		.pfn		= __phys_to_pfn(S3C2410_CS2 + (1<<24)),
+		.length		= SZ_4M,
+		.type		= MT_DEVICE,
+	}, {
+		.virtual	= (u32)S3C24XX_VA_ISA_BYTE,
+		.pfn		= __phys_to_pfn(S3C2410_CS2),
+		.length		= 0x10000,
+		.type		= MT_DEVICE,
+	}, {
+		.virtual	= (u32)S3C24XX_VA_ISA_BYTE + 0x10000,
+		.pfn		= __phys_to_pfn(S3C2410_CS2 + (1<<24)),
+		.length		= SZ_4M,
+		.type		= MT_DEVICE,
+	}
+};
+
+#define UCON	(S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK)
+#define ULCON	(S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB)
+#define UFCON	(S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE)
+
+static struct s3c2410_uartcfg ok2440_uartcfgs[] __initdata = {
+	[0] = {
+		.hwport	     = 0,
+		.flags	     = 0,
+		.ucon	     = 0x3c5,
+		.ulcon	     = 0x03,
+		.ufcon	     = 0x51,
+	},
+	[1] = {
+		.hwport	     = 1,
+		.flags	     = 0,
+		.ucon	     = 0x3c5,
+		.ulcon	     = 0x03,
+		.ufcon	     = 0x51,
+	},
+	/* IR port */
+	[2] = {
+		.hwport	     = 2,
+		.flags	     = 0,
+		.ucon	     = 0x3c5,
+		.ulcon	     = 0x43,
+		.ufcon	     = 0x51,
+	}
+};
+
+/* LCD driver info */
+
+static struct s3c2410fb_display ok2440_lcd_cfg __initdata = {
+
+	.lcdcon5	= S3C2410_LCDCON5_FRM565 |
+			  S3C2410_LCDCON5_INVVLINE |
+			  S3C2410_LCDCON5_INVVFRAME |
+			  S3C2410_LCDCON5_PWREN |
+			  S3C2410_LCDCON5_HWSWP,
+
+	.type		= S3C2410_LCDCON1_TFT,
+
+	.width		= 320,
+	.height		= 240,
+
+	.pixclock	= 270000, /* HCLK 60 MHz, divisor 10 */
+	.xres		= 320,
+	.yres		= 240,
+	.bpp		= 16,
+	.left_margin	= 8,
+	.right_margin	= 5,
+	.hsync_len	= 16,
+	.upper_margin	= 8,
+	.lower_margin	= 5,
+	.vsync_len	= 2,
+};
+
+static struct s3c2410fb_mach_info ok2440_fb_info __initdata = {
+	.displays	= &ok2440_lcd_cfg,
+	.num_displays	= 1,
+	.default_display = 0,
+	.lpcsel		= ((0xCE6) & ~7) | 1<<4,
+};
+
+/* Nand flash partitions on ok2440 */
+static struct mtd_partition ok2440_default_nand_part[] = {
+	[0] = {
+		.name	= "u-boot",
+		.size	= SZ_1M,
+		.offset	= 0,
+	},
+	[1] = {
+		.name	= "App",
+		.size	= SZ_2M,
+		.offset	= MTDPART_OFS_APPEND,
+	},
+	[2] = {
+		.name	= "Kernel",
+		.size	= SZ_1M*4,
+		.offset	= MTDPART_OFS_APPEND,
+	},
+	[3] = {
+		.name	= "Ramdisk",
+		.size	= SZ_16M,
+		.offset	= MTDPART_OFS_APPEND,
+	},
+	[3] = {
+		.name	= "Rootfs",
+		.size	= MTDPART_SIZ_FULL,
+		.offset	= MTDPART_OFS_APPEND,
+	},
+};
+static struct s3c2410_nand_set ok2440_nand_sets[] = {
+	[0] = {
+		.name		= "nand",
+		.nr_chips	= 1,
+		.nr_partitions	= ARRAY_SIZE(ok2440_default_nand_part),
+		.partitions	= ok2440_default_nand_part,
+		.flash_bbt	= 1, /* We use u-boot to creat a BBT*/
+	}
+};
+
+static struct s3c2410_platform_nand ok2440_nand_info __initdata = {
+	.tacls		= 20,
+	.twrph0		= 60,
+	.twrph1		= 20,
+	.nr_sets	= ARRAY_SIZE(ok2440_nand_sets),
+	.sets		= ok2440_nand_sets,
+	.ignore_unset_ecc = 1,
+};
+
+
+/* DM9000AEP 10/100 ethernet controller */
+static struct resource ok2440_dm9k_resource[] = {
+	[0] = {
+		.start = MACH_OK2440_DM9K_BASE,
+		.end   = MACH_OK2440_DM9K_BASE + 3,
+		.flags = IORESOURCE_MEM
+	},
+	[1] = {
+		.start = MACH_OK2440_DM9K_BASE + 4,
+		.end   = MACH_OK2440_DM9K_BASE + 7,
+		.flags = IORESOURCE_MEM
+	},
+	[2] = {
+		.start = IRQ_EINT7,
+		.end   = IRQ_EINT7,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE,
+	}
+};
+/* The DM9000 has no eeprom ,and it's MAC address is set by
+ * the bootloader before starting the kernel.
+ */
+static struct dm9000_plat_data ok2440_dm9k_pdata = {
+	.flags		= (DM9000_PLATF_16BITONLY | DM9000_PLATF_NO_EEPROM),
+};
+static struct platform_device ok2440_device_eth = {
+	.name		= "dm9000",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(ok2440_dm9k_resource),
+	.resource	= ok2440_dm9k_resource,
+	.dev		= {
+		.platform_data	= &ok2440_dm9k_pdata,
+	},
+};
+
+/* LEDS sourport */
+static struct gpio_led ok2440_leds_desc[] = {
+	{
+		.name			= "led0",
+		.default_trigger	= "heartbeat",
+		.gpio			= S3C2410_GPF(3),
+	},
+	{
+		.name			= "led1",
+		.default_trigger	= "nand-disk",
+		.gpio			= S3C2410_GPF(4),
+	},
+	{
+		.name			= "led2",
+		.default_trigger	= "mmc",
+		.gpio			= S3C2410_GPF(5),
+	},
+	{
+		.name			= "led3",
+		.default_trigger	= "network",
+		.gpio			= S3C2410_GPF(6),
+	},
+};
+
+static struct gpio_led_platform_data ok2440_leds_pdata = {
+	.num_leds	= ARRAY_SIZE(ok2440_leds_desc),
+	.leds		= ok2440_leds_desc,
+};
+
+static struct platform_device ok2440_leds = {
+	.name	= "leds-gpio",
+	.id	= -1,
+	.dev	= {
+		.platform_data = &ok2440_leds_pdata,
+	},
+};
+/* GPIO KEYS */
+static struct gpio_keys_button ok2440_gpio_keys_table[] = {
+	{
+		.code		= KEY_LEFT,
+		.gpio		= S3C2410_GPF(0),
+		.active_low	= 1,
+		.desc		= "Left button",
+	},
+	{
+		.code		= KEY_RIGHT,
+		.gpio		= S3C2410_GPF(2),
+		.active_low	= 1,
+		.desc		= "Right button",
+	},
+	{
+		.code		= KEY_UP,
+		.gpio		= S3C2410_GPB(5),
+		.active_low	= 1,
+		.desc		= "Up button",
+	},
+	{
+		.code		= KEY_DOWN,
+		.gpio		= S3C2410_GPB(6),
+		.active_low	= 1,
+		.desc		= "Down button",
+	},
+	{
+		.code		= KEY_ENTER,
+		.gpio		= S3C2410_GPB(7),
+		.active_low	= 1,
+		.desc		= "Ok button",
+	},
+
+};
+static struct gpio_keys_platform_data ok2440_gpio_keys_pdata = {
+	.buttons	= ok2440_gpio_keys_table,
+	.nbuttons	= ARRAY_SIZE(ok2440_gpio_keys_table),
+};
+static struct platform_device ok2440_device_gpiokeys = {
+	.name			= "gpio-keys",
+	.dev.platform_data	= &ok2440_gpio_keys_pdata,
+};
+/* AUDIO */
+static struct s3c24xx_uda134x_platform_data ok2440_audio_pins = {
+	.l3_clk = S3C2410_GPB(4),
+	.l3_mode = S3C2410_GPB(2),
+	.l3_data = S3C2410_GPB(3),
+	.model   = UDA134X_UDA1341
+};
+
+static struct platform_device ok2440_audio = {
+	.name		= "s3c24xx_uda134x",
+	.id		= 0,
+	.dev		= {
+		.platform_data	= &ok2440_audio_pins,
+	}
+};
+
+static struct platform_device uda1340_codec = {
+	.name = "uda134x-codec",
+	.id   = -1,
+};
+
+/*
+ * I2C devices
+ */
+static struct at24_platform_data at24c08 = {
+	.byte_len	= SZ_8K / 8,
+	.page_size	= 16,
+};
+
+static struct i2c_board_info ok2440_i2c_devs[] __initdata = {
+	{
+		I2C_BOARD_INFO("24c08", 0x50),
+		.platform_data	= &at24c08,
+	},
+};
+
+/*  USB device UDC support */
+static struct s3c2410_udc_mach_info ok2440_udc_cfg __initdata = {
+	.pullup_pin = S3C2410_GPG(9),
+};
+
+/* USB */
+static struct s3c2410_hcd_info ok2440_usb_info __initdata = {
+	.port[0]	= {
+		.flags	= S3C_HCDFLG_USED,
+	},
+	.port[1]	= {
+		.flags	= 0,
+	},
+};
+
+/* MMC/SD */
+static struct s3c24xx_mci_pdata ok2440_mmc_cfg __initdata = {
+	.gpio_detect	= S3C2410_GPG(10),
+	.gpio_wprotect	= S3C2410_GPH(8),
+	.set_power	= NULL,
+	.ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34,
+};
+
+
+struct syscore_ops s3c24xx_irq_syscore_ops = {
+	.suspend	= s3c24xx_irq_suspend,
+	.resume		= s3c24xx_irq_resume,
+};
+
+static struct platform_device *ok2440_devices[] __initdata = {
+	&s3c_device_ohci,
+	&s3c_device_lcd,
+	&s3c_device_wdt,
+	&s3c_device_i2c0,
+	&s3c_device_iis,
+	&s3c_device_sdi,
+	&s3c_device_nand,
+	&s3c_device_rtc,
+	&s3c_device_usbgadget,
+	&ok2440_device_gpiokeys,
+	&uda1340_codec,
+	&ok2440_device_eth,
+	&ok2440_audio,
+	&ok2440_leds,
+	&samsung_asoc_dma,
+
+};
+
+static void __init ok2440_map_io(void)
+{
+	s3c24xx_init_io(ok2440_iodesc, ARRAY_SIZE(ok2440_iodesc));
+	s3c24xx_init_clocks(12000000);
+	s3c24xx_init_uarts(ok2440_uartcfgs, ARRAY_SIZE(ok2440_uartcfgs));
+}
+
+static void __init ok2440_machine_init(void)
+{
+	/*configure the mmc protect to pull high . */
+	WARN_ON(gpio_request(S3C2410_GPG(8), "mmc pull up"));
+	gpio_direction_output(S3C2410_GPG(8), 1);
+	s3c24xx_fb_set_platdata(&ok2440_fb_info);
+	s3c_i2c0_set_platdata(NULL);
+
+	s3c_ohci_set_platdata(&ok2440_usb_info);
+
+	s3c_nand_set_platdata(&ok2440_nand_info);
+	s3c24xx_udc_set_platdata(&ok2440_udc_cfg);
+	s3c24xx_mci_set_platdata(&ok2440_mmc_cfg);
+	i2c_register_board_info(0, ok2440_i2c_devs,
+				ARRAY_SIZE(ok2440_i2c_devs));
+
+	platform_add_devices(ok2440_devices, ARRAY_SIZE(ok2440_devices));
+	s3c_pm_init();
+}
+
+MACHINE_START(S3C2440, "OK2440 development board.")
+	/* Maintainer: Wu DaoGuang <wdgvip@gmail.com> */
+	.boot_params	= S3C2410_SDRAM_PA + 0x100,
+
+	.init_irq	= s3c24xx_init_irq,
+	.map_io		= ok2440_map_io,
+	.init_machine	= ok2440_machine_init,
+	.timer		= &s3c24xx_timer,
+MACHINE_END
-- 
1.7.1

