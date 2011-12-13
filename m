Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1LMGdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 01:33:13 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:55289 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457Ab1LMGdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 01:33:10 -0500
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        Wolfram Sang <w.sang@pengutronix.de> (commit_signer:1/3=33%),
        David Woodhouse <david.woodhouse@intel.com> (commit_signer:1/3=33%),
        Andrew Morton <akpm@linux-foundation.org> (commit_signer:1/3=33%),
        Ingo Molnar <mingo@elte.hu> (commit_signer:1/3=33%),
        Sascha Hauer <s.hauer@pengutronix.de> (commit_signer:1/3=33%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 15/19] mx3_defconfig: update default configuration
Date: Tue, 13 Dec 2011 07:31:47 +0100
Message-Id: <1323757911-25217-15-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323757911-25217-1-git-send-email-eric@eukrea.com>
References: <1323757911-25217-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- add new machine VPR200
- update CPUIMX35 -> CPUIMX35SD
- add drivers :
	- DNET & SMSC911X
	- EVDEV & TOUCHSCREEN & TSC2007
	- LCD & BACKLIGHT support
	- SPI & SPIdev support
	- LEDS support
	- PCF8563 RTC support

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
---
 arch/arm/configs/mx3_defconfig |   31 ++++++++++++++++++++++++-------
 1 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/arm/configs/mx3_defconfig b/arch/arm/configs/mx3_defconfig
index cb0717f..afb6b04 100644
--- a/arch/arm/configs/mx3_defconfig
+++ b/arch/arm/configs/mx3_defconfig
@@ -23,7 +23,8 @@ CONFIG_MACH_ARMADILLO5X0=y
 CONFIG_MACH_KZM_ARM11_01=y
 CONFIG_MACH_PCM043=y
 CONFIG_MACH_MX35_3DS=y
-CONFIG_MACH_EUKREA_CPUIMX35=y
+CONFIG_MACH_EUKREA_CPUIMX35SD=y
+CONFIG_MACH_VPR200=y
 CONFIG_MXC_IRQ_PRIOR=y
 CONFIG_MXC_PWM=y
 CONFIG_ARM_ERRATA_411920=y
@@ -63,18 +64,17 @@ CONFIG_MTD_UBI=y
 CONFIG_MISC_DEVICES=y
 CONFIG_EEPROM_AT24=y
 CONFIG_NETDEVICES=y
-CONFIG_SMSC_PHY=y
-CONFIG_NET_ETHERNET=y
-CONFIG_SMSC911X=y
 CONFIG_DNET=y
-# CONFIG_NETDEV_1000 is not set
-# CONFIG_NETDEV_10000 is not set
+CONFIG_SMSC911X=y
+CONFIG_SMSC_PHY=y
 # CONFIG_INPUT_MOUSEDEV is not set
+CONFIG_INPUT_EVDEV=y
 # CONFIG_KEYBOARD_ATKBD is not set
 CONFIG_KEYBOARD_IMX=y
 # CONFIG_INPUT_MOUSE is not set
+CONFIG_INPUT_TOUCHSCREEN=y
+CONFIG_TOUCHSCREEN_TSC2007=y
 # CONFIG_SERIO is not set
-# CONFIG_VT is not set
 # CONFIG_LEGACY_PTYS is not set
 CONFIG_SERIAL_8250=m
 CONFIG_SERIAL_8250_EXTENDED=y
@@ -86,6 +86,9 @@ CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_IMX=y
 CONFIG_SPI=y
+CONFIG_SPI_IMX=y
+CONFIG_SPI_SPIDEV=y
+CONFIG_GPIO_SYSFS=y
 CONFIG_W1=y
 CONFIG_W1_MASTER_MXC=y
 CONFIG_W1_SLAVE_THERM=y
@@ -109,6 +112,10 @@ CONFIG_SOC_CAMERA_OV772X=y
 CONFIG_VIDEO_MX3=y
 # CONFIG_RADIO_ADAPTERS is not set
 CONFIG_FB=y
+CONFIG_BACKLIGHT_LCD_SUPPORT=y
+CONFIG_LCD_CLASS_DEVICE=y
+CONFIG_LCD_PLATFORM=y
+CONFIG_BACKLIGHT_CLASS_DEVICE=y
 CONFIG_SOUND=y
 CONFIG_SND=y
 # CONFIG_SND_ARM is not set
@@ -127,7 +134,17 @@ CONFIG_USB_G_SERIAL=m
 CONFIG_USB_ULPI=y
 CONFIG_MMC=y
 CONFIG_MMC_MXC=y
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_TRIGGERS=y
+CONFIG_LEDS_TRIGGER_TIMER=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+CONFIG_LEDS_TRIGGER_BACKLIGHT=y
+CONFIG_LEDS_TRIGGER_GPIO=y
+CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
 CONFIG_RTC_CLASS=y
+CONFIG_RTC_DRV_PCF8563=y
 CONFIG_RTC_MXC=y
 CONFIG_DMADEVICES=y
 # CONFIG_DNOTIFY is not set
-- 
1.7.6.4

