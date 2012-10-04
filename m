Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab2JDGHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 02:07:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52843 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab2JDGHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 02:07:11 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Shawn Guo <shawn.guo@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Andrew Jones <drjones@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [PATCH] pwm: Get rid of HAVE_PWM
Date: Thu,  4 Oct 2012 08:06:59 +0200
Message-Id: <1349330819-11924-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12.2
X-Provags-ID: V02:K0:t+3IkztqagaoZMhV8mQLBKCWHaUFmCSy2GntzOG8jmB
 NtSySscUEmGFyiFQ2IRfv9ToQOcayIgdrK2surXnVqNMuBpixM
 p1yCepO+RYFjsLRYPxf7ZMdILyjuxjb6yS/VmYfts41bdEnKvs
 IW2vVkR5dhzsXyt6Jegz67dX3ZAgX/S0C0Bk+bLEGmu4t307da
 9Cs+dWOX2M8OC+bwqASHDUDB4dVjTuGg3f+sS0ERV+LOX8Yc1f
 ECqQI5qYr0MAUQR6pa9QqSwMIRMnFEF4zfI/zxUlPZtnZriqzf
 hz+mPRZ3HJlJ7sYOvopVuudszxccmeS85m4FrD+IKgm9wn+PW3
 99O1/rwd5eJ7l7n9Uw0fCaqpqm7oa6QUpVTBx6E1H+1+Ae8GGT
 FCo9wvIpc+FzEjv3zR2q6l+qaC/1MGjH2tpFWgEty2BRqkUsKy
 9wXCI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all drivers have been moved to the PWM subsystem, remove the
legacy HAVE_PWM symbol and replace it with the new PWM symbol. While at
it, select the PWM subsystem and corresponding PWM driver on boards that
require PWM functionality.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Bryan Wu <bryan.wu@canonical.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Andrew Jones <drjones@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org
Cc: linux-input@vger.kernel.org
Cc: linux-leds@vger.kernel.org
---
 arch/arm/Kconfig           |  6 ++----
 arch/arm/mach-mxs/Kconfig  |  6 ++++--
 arch/arm/mach-pxa/Kconfig  | 42 ++++++++++++++++++++++++++++--------------
 arch/mips/Kconfig          |  3 ++-
 drivers/input/misc/Kconfig |  4 ++--
 drivers/leds/Kconfig       |  2 +-
 include/linux/pwm.h        |  2 +-
 7 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e91c7cd..a0cebf8 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -69,9 +69,6 @@ config ARM_DMA_USE_IOMMU
 	select ARM_HAS_SG_CHAIN
 	bool
 
-config HAVE_PWM
-	bool
-
 config MIGHT_HAVE_PCI
 	bool
 
@@ -610,7 +607,8 @@ config ARCH_LPC32XX
 	select CLKDEV_LOOKUP
 	select GENERIC_CLOCKEVENTS
 	select USE_OF
-	select HAVE_PWM
+	select PWM
+	select PWM_LPC32XX
 	help
 	  Support for the NXP LPC32XX family of processors
 
diff --git a/arch/arm/mach-mxs/Kconfig b/arch/arm/mach-mxs/Kconfig
index 9a8bbda..2fc01bd 100644
--- a/arch/arm/mach-mxs/Kconfig
+++ b/arch/arm/mach-mxs/Kconfig
@@ -6,7 +6,8 @@ config SOC_IMX23
 	bool
 	select ARM_AMBA
 	select CPU_ARM926T
-	select HAVE_PWM
+	select PWM
+	select PWM_MXS
 	select PINCTRL_IMX23
 
 config SOC_IMX28
@@ -14,7 +15,8 @@ config SOC_IMX28
 	select ARM_AMBA
 	select CPU_ARM926T
 	select HAVE_CAN_FLEXCAN if CAN
-	select HAVE_PWM
+	select PWM
+	select PWM_MXS
 	select PINCTRL_IMX28
 
 comment "MXS platforms:"
diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index fe2d1f8..14f41c3 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -33,12 +33,14 @@ config ARCH_LUBBOCK
 config MACH_MAINSTONE
 	bool "Intel HCDDBBVA0 Development Platform (aka Mainstone)"
 	select PXA27x
-	select HAVE_PWM
+	select PWM
+	select PWM_PXA
 
 config MACH_ZYLONITE
 	bool
 	select PXA3xx
-	select HAVE_PWM
+	select PWM
+	select PWM_PXA
 
 config MACH_ZYLONITE300
 	bool "PXA3xx Development Platform (aka Zylonite) PXA300/310"
@@ -78,7 +80,8 @@ config ARCH_VIPER
 	select PXA25x
 	select ISA
 	select I2C_GPIO
-	select HAVE_PWM
+	select PWM
+	select PWM_PXA
 	select PXA_HAVE_ISA_IRQS
 	select ARCOM_PCMCIA
 
@@ -128,7 +131,8 @@ config MACH_CM_X300
 	select PXA3xx
 	select CPU_PXA300
 	select CPU_PXA310
-	select HAVE_PWM
+	select PWM
+	select PWM_PXA
 
 config MACH_CAPC7117
 	bool "Embedian CAPC-7117 evaluation kit based on the MXM-8x10 CoM"
@@ -220,7 +224,8 @@ config TRIZEPS_PCMCIA
 config MACH_LOGICPD_PXA270
 	bool "LogicPD PXA270 Card Engine Development Platform"
 	select PXA27x
-	select HAVE_PWM
+	select PWM
+	select PWM_PXA
 
 config MACH_PCM027
 	bool "Phytec phyCORE-PXA270 CPU module (PCM-027)"
@@ -229,7 +234,8 @@ config MACH_PCM027
 
 config MACH_PCM990_BASEBOARD
 	bool "PHYTEC PCM-990 development board"
-	select HAVE_PWM
+	select PWM
+	select PWM_PXA
 	depends on MACH_PCM027
 
 choice
@@ -255,7 +261,8 @@ config MACH_COLIBRI_PXA270_INCOME
 	bool "Income s.r.o. PXA270 SBC"
 	depends on MACH_COLIBRI
 	select PXA27x
-	select HAVE_PWM
+	select PWM
+	select PWM_PXA
 
 config MACH_COLIBRI300
 	bool "Toradex Colibri PXA300/310"
@@ -285,7 +292,8 @@ config MACH_H4700
 	bool "HP iPAQ hx4700"
 	select PXA27x
 	select IWMMXT
-	select HAVE_PWM
+	select PWM
+	select PWM_PXA
 
 config MACH_H5000
 	bool "HP iPAQ h5000"
@@ -299,13 +307,15 @@ config MACH_MAGICIAN
 	bool "Enable HTC Magician Support"
 	select PXA27x
 	select IWMMXT
-	select HAVE_PWM
+	select PWM
+	select PWM_PXA
 
 config MACH_MIOA701
 	bool "Mitac Mio A701 Support"
 	select PXA27x
 	select IWMMXT
-	select HAVE_PWM
+	select PWM
+	select PWM_PXA
 	select GPIO_SYSFS
 	help
 	  Say Y here if you intend to run this kernel on a
@@ -316,7 +326,8 @@ config PXA_EZX
 	bool "Motorola EZX Platform"
 	select PXA27x
 	select IWMMXT
-	select HAVE_PWM
+	select PWM
+	select PWM_PXA
 
 config MACH_EZX_A780
 	bool "Motorola EZX A780"
@@ -354,7 +365,8 @@ config MACH_MP900C
 
 config ARCH_PXA_PALM
 	bool "PXA based Palm PDAs"
-	select HAVE_PWM
+	select PWM
+	select PWM_PXA
 
 config MACH_PALM27X
 	bool
@@ -454,7 +466,8 @@ config MACH_RAUMFELD_RC
 	select PXA3xx
 	select CPU_PXA300
 	select POWER_SUPPLY
-	select HAVE_PWM
+	select PWM
+	select PWM_PXA
 
 config MACH_RAUMFELD_CONNECTOR
 	bool "Raumfeld Connector"
@@ -617,7 +630,8 @@ config MACH_E800
 config MACH_ZIPIT2
 	bool "Zipit Z2 Handheld"
 	select PXA27x
-	select HAVE_PWM
+	select PWM
+	select PWM_PXA
 endif
 endmenu
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 331d574..b38f23d 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -219,7 +219,8 @@ config MACH_JZ4740
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
 	select SYS_HAS_EARLY_PRINTK
-	select HAVE_PWM
+	select PWM
+	select PWM_JZ4740
 	select HAVE_CLK
 	select GENERIC_IRQ_CHIP
 
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 7c0f1ec..af6188b 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -146,7 +146,7 @@ config INPUT_MAX8925_ONKEY
 
 config INPUT_MAX8997_HAPTIC
 	tristate "MAXIM MAX8997 haptic controller support"
-	depends on HAVE_PWM && MFD_MAX8997
+	depends on PWM && MFD_MAX8997
 	select INPUT_FF_MEMLESS
 	help
 	  This option enables device driver support for the haptic controller
@@ -444,7 +444,7 @@ config INPUT_PCF8574
 
 config INPUT_PWM_BEEPER
 	tristate "PWM beeper support"
-	depends on HAVE_PWM
+	depends on PWM
 	help
 	  Say Y here to get support for PWM based beeper devices.
 
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index c96bbaa..a720d99 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -298,7 +298,7 @@ config LEDS_DAC124S085
 config LEDS_PWM
 	tristate "PWM driven LED Support"
 	depends on LEDS_CLASS
-	depends on HAVE_PWM
+	depends on PWM
 	help
 	  This option enables support for pwm driven LEDs
 
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 112b314..eea3f26 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -7,7 +7,7 @@
 struct pwm_device;
 struct seq_file;
 
-#if IS_ENABLED(CONFIG_PWM) || IS_ENABLED(CONFIG_HAVE_PWM)
+#if IS_ENABLED(CONFIG_PWM)
 /*
  * pwm_request - request a PWM device
  */
-- 
1.7.12.2

