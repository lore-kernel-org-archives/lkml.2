Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab2DULG7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 07:06:59 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:36353 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751980Ab2DULG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 07:06:57 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] Defconfig update for LPC32xx
Date: Sat, 21 Apr 2012 13:06:34 +0200
Message-Id: <1335006394-26810-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the defconfig for the LPC32xx SoC after device tree
conversion:

* Adjustment to DT conversion, added new driver support
* Added IPv6
* Increased kernel log buffer

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 arch/arm/configs/lpc32xx_defconfig |   44 +++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

--- linux-2.6.orig/arch/arm/configs/lpc32xx_defconfig
+++ linux-2.6/arch/arm/configs/lpc32xx_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
-CONFIG_LOG_BUF_SHIFT=14
+CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
@@ -10,6 +10,7 @@ CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
+CONFIG_JUMP_LABEL=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
@@ -21,6 +22,8 @@ CONFIG_PREEMPT=y
 CONFIG_AEABI=y
 CONFIG_ZBOOT_ROM_TEXT=0x0
 CONFIG_ZBOOT_ROM_BSS=0x0
+CONFIG_ARM_APPENDED_DTB=y
+CONFIG_ARM_ATAG_DTB_COMPAT=y
 CONFIG_CMDLINE="console=ttyS0,115200n81 root=/dev/ram0"
 CONFIG_CPU_IDLE=y
 CONFIG_FPE_NWFPE=y
@@ -40,7 +43,8 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_INET_XFRM_MODE_BEET is not set
 # CONFIG_INET_LRO is not set
 # CONFIG_INET_DIAG is not set
-# CONFIG_IPV6 is not set
+CONFIG_IPV6=y
+CONFIG_IPV6_PRIVACY=y
 # CONFIG_WIRELESS is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
@@ -55,13 +59,24 @@ CONFIG_BLK_DEV_CRYPTOLOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=1
 CONFIG_BLK_DEV_RAM_SIZE=16384
-CONFIG_MISC_DEVICES=y
 CONFIG_EEPROM_AT25=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_NETDEVICES=y
 CONFIG_MII=y
-CONFIG_PHYLIB=y
+# CONFIG_NET_VENDOR_BROADCOM is not set
+# CONFIG_NET_VENDOR_CHELSIO is not set
+# CONFIG_NET_VENDOR_CIRRUS is not set
+# CONFIG_NET_VENDOR_FARADAY is not set
+# CONFIG_NET_VENDOR_INTEL is not set
+# CONFIG_NET_VENDOR_MARVELL is not set
+# CONFIG_NET_VENDOR_MICREL is not set
+# CONFIG_NET_VENDOR_MICROCHIP is not set
+# CONFIG_NET_VENDOR_NATSEMI is not set
+CONFIG_LPC_ENET=y
+# CONFIG_NET_VENDOR_SEEQ is not set
+# CONFIG_NET_VENDOR_SMSC is not set
+# CONFIG_NET_VENDOR_STMICRO is not set
 CONFIG_SMSC_PHY=y
 # CONFIG_WLAN is not set
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
@@ -97,16 +112,22 @@ CONFIG_SND_SEQUENCER=y
 CONFIG_SND_MIXER_OSS=y
 CONFIG_SND_PCM_OSS=y
 CONFIG_SND_SEQUENCER_OSS=y
-CONFIG_SND_DYNAMIC_MINORS=y
+# CONFIG_SND_SUPPORT_OLD_API is not set
 # CONFIG_SND_VERBOSE_PROCFS is not set
+CONFIG_SND_DEBUG=y
+CONFIG_SND_DEBUG_VERBOSE=y
 # CONFIG_SND_DRIVERS is not set
 # CONFIG_SND_ARM is not set
 # CONFIG_SND_SPI is not set
 CONFIG_SND_SOC=y
 # CONFIG_HID_SUPPORT is not set
 CONFIG_USB=y
+CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_STORAGE=y
-CONFIG_USB_LIBUSUAL=y
+CONFIG_USB_GADGET=y
+CONFIG_USB_LPC32XX=y
+CONFIG_USB_MASS_STORAGE=m
+CONFIG_USB_G_SERIAL=m
 CONFIG_MMC=y
 # CONFIG_MMC_BLOCK_BOUNCE is not set
 CONFIG_MMC_ARMMMCI=y
@@ -114,10 +135,21 @@ CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
+CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+CONFIG_LEDS_TRIGGER_BACKLIGHT=y
+CONFIG_LEDS_TRIGGER_GPIO=y
+CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_INTF_DEV_UIE_EMUL=y
+CONFIG_RTC_DRV_DS1374=y
+CONFIG_RTC_DRV_PCF8563=y
 CONFIG_RTC_DRV_LPC32XX=y
+CONFIG_DMADEVICES=y
+CONFIG_AMBA_PL08X=y
+CONFIG_STAGING=y
+CONFIG_IIO=y
+CONFIG_LPC32XX_ADC=y
 CONFIG_EXT2_FS=y
 CONFIG_AUTOFS4_FS=y
 CONFIG_MSDOS_FS=y
