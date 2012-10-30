Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761710Ab2J3BL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 21:11:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51380 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758902Ab2J3BL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 21:11:57 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2] ARM: Dove: update defconfig
Date: Tue, 30 Oct 2012 02:11:45 +0100
Message-Id: <1351559505-944-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1351539916-29561-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1351539916-29561-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been a while since dove_defconfig was updated to recent development.
This patch adds all currently available Dove boards, including a DT-enabled
machine.

DT support requires to allow ATAGS passed by boot loader as most of them are
not yet capable of passing DT blobs. Also OF_SERIAL is enabled to actually
see the bootlog.

Finally, sdhci driver for Dove, mv_cesa, GPIO LEDs, and highmem support is
added.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- also add mv_cesa crypto engine

Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/configs/dove_defconfig |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/configs/dove_defconfig b/arch/arm/configs/dove_defconfig
index 40db34c..0b7ee92 100644
--- a/arch/arm/configs/dove_defconfig
+++ b/arch/arm/configs/dove_defconfig
@@ -8,11 +8,19 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_ARCH_DOVE=y
 CONFIG_MACH_DOVE_DB=y
+CONFIG_MACH_CM_A510=y
+CONFIG_MACH_DOVE_DT=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_AEABI=y
 CONFIG_ZBOOT_ROM_TEXT=0x0
 CONFIG_ZBOOT_ROM_BSS=0x0
+CONFIG_HIGHMEM=y
+CONFIG_USE_OF=y
+CONFIG_ATAGS=y
+CONFIG_ARM_APPENDED_DTB=y
+CONFIG_ARM_ATAG_DTB_COMPAT=y
+CONFIG_ARM_ATAG_DTB_COMPAT_CMDLINE_FROM_BOOTLOADER=y
 CONFIG_VFP=y
 CONFIG_NET=y
 CONFIG_PACKET=y
@@ -62,6 +70,9 @@ CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 # CONFIG_SERIAL_8250_PCI is not set
 CONFIG_SERIAL_8250_RUNTIME_UARTS=2
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+CONFIG_SERIAL_OF_PLATFORM=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
@@ -74,6 +85,18 @@ CONFIG_USB_DEVICEFS=y
 CONFIG_USB_EHCI_HCD=y
 CONFIG_USB_EHCI_ROOT_HUB_TT=y
 CONFIG_USB_STORAGE=y
+CONFIG_MMC=y
+CONFIG_MMC_SDHCI=y
+CONFIG_MMC_SDHCI_IO_ACCESSORS=y
+CONFIG_MMC_SDHCI_PLTFM=y
+CONFIG_MMC_SDHCI_DOVE=y
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_TRIGGERS=y
+CONFIG_LEDS_TRIGGER_TIMER=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_MV=y
 CONFIG_DMADEVICES=y
@@ -122,6 +145,7 @@ CONFIG_CRYPTO_TWOFISH=y
 CONFIG_CRYPTO_DEFLATE=y
 CONFIG_CRYPTO_LZO=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
+CONFIG_CRYPTO_DEV_MV_CESA=y
 CONFIG_CRC_CCITT=y
 CONFIG_CRC16=y
 CONFIG_LIBCRC32C=y
-- 
1.7.10.4

