Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab1IBOoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 10:44:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53382 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab1IBOo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 10:44:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jean Delvare <khali@linux-fr.org>
Subject: [PATCH 2/2] mfd: remove CONFIG_MFD_SUPPORT
Date: Fri, 2 Sep 2011 16:43:36 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Luciano Coelho <coelho@ti.com>, Randy Dunlap <rdunlap@xenotime.net>,
        matti.j.aaltonen@nokia.com, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net> <201108311849.37273.arnd@arndb.de> <20110902143713.307bbebe@endymion.delvare>
In-Reply-To: <20110902143713.307bbebe@endymion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109021643.36369.arnd@arndb.de>
X-Provags-ID: V02:K0:+NqpHAipdvszACtvtW7JClMFWqRFFq9xPYyzpi7e76k
 A9m+BseH8fPTb5jX71KUfv1jw805OfyewYgMVe3idzrSshcSV6
 000XJFRjinl04my0Km9MrmIvBF3t2eeHLY8P3fgWtlLKic+nFq
 7jZjENkyIsA+U3HLtRLPm5GdKfgXXErdijCYn9HhQHoGkZBO7j
 ovZjuPGZotBa1pKMUASXHKOtgg6QirgS9vSzCG2oQ+5JeFd20c
 68cx6EKWQn9j+yi6SJTepAG51xqquhuHjKvw8Uqim0a0bKwH/R
 87YApHXM8VyAknGl1U2yeNQOxdkb/aYEgMCkiBv3w4THp8+Twj
 zjWsp5T4lWxnkeWonlZo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently have two symbols to control compilation the MFD subsystem,
MFD_SUPPORT and MFD_CORE. The MFD_SUPPORT is actually not required
at all, it only hides the submenu when not set, with the effect that
Kconfig warns about missing dependencies when another driver selects
an MFD driver while MFD_SUPPORT is disabled. Turning the MFD submenu
back from menuconfig into a plain menu simplifies the Kconfig syntax
for those kinds of users and avoids the surprise when the menu
suddenly appears because another driver was enabled that selects this
symbol.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-omap2/Kconfig |    1 -
 drivers/gpio/Kconfig        |    3 +--
 drivers/i2c/busses/Kconfig  |    1 -
 drivers/media/radio/Kconfig |    1 -
 drivers/mfd/Kconfig         |   22 ++++------------------
 5 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 57b66d5..1aee224 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -14,7 +14,6 @@ config ARCH_OMAP2PLUS_TYPICAL
 	select SERIAL_OMAP_CONSOLE
 	select I2C
 	select I2C_OMAP
-	select MFD_SUPPORT
 	select MENELAUS if ARCH_OMAP2
 	select TWL4030_CORE if ARCH_OMAP3 || ARCH_OMAP4
 	select TWL4030_POWER if ARCH_OMAP3 || ARCH_OMAP4
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d539efd..fbc5fd4 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -180,7 +180,7 @@ config GPIO_SCH
 
 config GPIO_VX855
 	tristate "VIA VX855/VX875 GPIO"
-	depends on MFD_SUPPORT && PCI
+	depends on PCI
 	select MFD_CORE
 	select MFD_VX855
 	help
@@ -417,7 +417,6 @@ config GPIO_TIMBERDALE
 config GPIO_RDC321X
 	tristate "RDC R-321x GPIO support"
 	depends on PCI
-	select MFD_SUPPORT
 	select MFD_CORE
 	select MFD_RDC321X
 	help
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 646068e..d625a48 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -110,7 +110,6 @@ config I2C_I801
 config I2C_ISCH
 	tristate "Intel SCH SMBus 1.0"
 	depends on PCI
-	select MFD_CORE
 	select LPC_SCH
 	help
 	  Say Y here if you want to use SMBus controller on the Intel SCH
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 52798a1..ccd5f0d 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -426,7 +426,6 @@ config RADIO_TIMBERDALE
 config RADIO_WL1273
 	tristate "Texas Instruments WL1273 I2C FM Radio"
 	depends on I2C && VIDEO_V4L2
-	select MFD_CORE
 	select MFD_WL1273_CORE
 	select FW_LOADER
 	---help---
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 21574bd..a7f1137 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -2,23 +2,8 @@
 # Multifunction miscellaneous devices
 #
 
-menuconfig MFD_SUPPORT
-	bool "Multifunction device drivers"
-	depends on HAS_IOMEM
-	default y
-	help
-	  Multifunction devices embed several functions (e.g. GPIOs,
-	  touchscreens, keyboards, current regulators, power management chips,
-	  etc...) in one single integrated circuit. They usually talk to the
-	  main CPU through one or more IRQ lines and low speed data busses (SPI,
-	  I2C, etc..). They appear as one single device to the main system
-	  through the data bus and the MFD framework allows for sub devices
-	  (a.k.a. functions) to appear as discrete platform devices.
-	  MFDs are typically found on embedded platforms.
-
-	  This option alone does not add any kernel code.
-
-if MFD_SUPPORT
+if HAS_IOMEM
+menu "Multifunction device drivers"
 
 config MFD_CORE
 	tristate
@@ -770,7 +755,8 @@ config MFD_AAT2870_CORE
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
 
-endif # MFD_SUPPORT
+endmenu
+endif
 
 menu "Multimedia Capabilities Port drivers"
 	depends on ARCH_SA1100
-- 
1.7.1

