Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031865Ab2COQpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:45:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47749 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031794Ab2COQob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:44:31 -0400
From: jean.pihet@newoldbits.com
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Jean Pihet <j-pihet@ti.com>
Subject: [PATCH 09/10] ARM: OMAP2+: SmartReflex: add POWER_AVS Kconfig options
Date: Thu, 15 Mar 2012 17:44:04 +0100
Message-Id: <1331829845-9526-10-git-send-email-j-pihet@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1331829845-9526-1-git-send-email-j-pihet@ti.com>
References: <1331829845-9526-1-git-send-email-j-pihet@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <j-pihet@ti.com>

Add a Kconfig menu (POWER_AVS) and rename the Kconfig options
for the OMAP SmartReflex implementation:
 CONFIG_OMAP_SMARTREFLEX renames to CONFIG_POWER_AVS_OMAP
 CONFIG_OMAP_SMARTREFLEX_CLASS3 renames to CONFIG_POWER_AVS_OMAP_CLASS3

This change makes the SmartReflex implementation ready for the move
to drivers/.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
---
 arch/arm/mach-omap2/Makefile      |    5 ++-
 arch/arm/mach-omap2/pm.h          |    2 +-
 arch/arm/mach-omap2/smartreflex.h |    6 ++--
 arch/arm/plat-omap/Kconfig        |   45 ++++++++++++++++++++++++------------
 4 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 9746529..30666fd 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -68,8 +68,9 @@ obj-$(CONFIG_ARCH_OMAP3)		+= pm34xx.o sleep34xx.o \
 obj-$(CONFIG_ARCH_OMAP4)		+= pm44xx.o omap-mpuss-lowpower.o \
 					   cpuidle44xx.o
 obj-$(CONFIG_PM_DEBUG)			+= pm-debug.o
-obj-$(CONFIG_OMAP_SMARTREFLEX)          += sr_device.o smartreflex.o
-obj-$(CONFIG_OMAP_SMARTREFLEX_CLASS3)	+= smartreflex-class3.o
+
+obj-$(CONFIG_POWER_AVS_OMAP)		+= sr_device.o smartreflex.o
+obj-$(CONFIG_POWER_AVS_OMAP_CLASS3)	+= smartreflex-class3.o
 
 AFLAGS_sleep24xx.o			:=-Wa,-march=armv6
 AFLAGS_sleep34xx.o			:=-Wa,-march=armv7-a$(plus_sec)
diff --git a/arch/arm/mach-omap2/pm.h b/arch/arm/mach-omap2/pm.h
index a051431..1a2d483 100644
--- a/arch/arm/mach-omap2/pm.h
+++ b/arch/arm/mach-omap2/pm.h
@@ -110,7 +110,7 @@ extern void enable_omap3630_toggle_l2_on_restore(void);
 static inline void enable_omap3630_toggle_l2_on_restore(void) { }
 #endif		/* defined(CONFIG_PM) && defined(CONFIG_ARCH_OMAP3) */
 
-#ifdef CONFIG_OMAP_SMARTREFLEX
+#ifdef CONFIG_POWER_AVS_OMAP
 extern int omap_devinit_smartreflex(void);
 extern void omap_enable_smartreflex_on_init(void);
 #else
diff --git a/arch/arm/mach-omap2/smartreflex.h b/arch/arm/mach-omap2/smartreflex.h
index 3bd4fee..dbfb554 100644
--- a/arch/arm/mach-omap2/smartreflex.h
+++ b/arch/arm/mach-omap2/smartreflex.h
@@ -17,8 +17,8 @@
  * published by the Free Software Foundation.
  */
 
-#ifndef __ASM_ARM_OMAP_SMARTREFLEX_H
-#define __ASM_ARM_OMAP_SMARTREFLEX_H
+#ifndef __DRIVERS_POWER_AVS_SMARTREFLEX_H
+#define __DRIVERS_POWER_AVS_SMARTREFLEX_H
 
 #include <linux/platform_device.h>
 #include <linux/delay.h>
@@ -177,7 +177,7 @@ struct omap_sr_pmic_data {
 };
 
 
-#ifdef CONFIG_OMAP_SMARTREFLEX
+#ifdef CONFIG_POWER_AVS_OMAP
 /*
  * The smart reflex driver supports CLASS1 CLASS2 and CLASS3 SR.
  * The smartreflex class driver should pass the class type.
diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index f419a08..6ec9237 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -44,37 +44,52 @@ config OMAP_DEBUG_LEDS
 	depends on OMAP_DEBUG_DEVICES
 	default y if LEDS_CLASS
 
-config OMAP_SMARTREFLEX
-	bool "SmartReflex support"
-	depends on (ARCH_OMAP3 || ARCH_OMAP4) && PM
+menuconfig POWER_AVS
+	tristate "Adaptive Voltage Scaling class support"
 	help
-	  Say Y if you want to enable SmartReflex.
+	  AVS is a power management technique which finely controls the
+	  operating voltage of a device in order to optimize (i.e. reduce)
+	  its power consumption.
+	  At a given operating point the voltage is adapted depending on
+	  static factors (chip manufacturing process) and dynamic factors
+	  (temperature depending performance).
+	  AVS is also called SmartReflex on OMAP devices.
+
+	  Say Y here to enable Adaptive Voltage Scaling class support.
+
+if POWER_AVS
 
-	  SmartReflex can perform continuous dynamic voltage
-	  scaling around the nominal operating point voltage
-	  according to silicon characteristics and operating
-	  conditions. Enabling SmartReflex reduces power
-	  consumption.
+config POWER_AVS_OMAP
+	bool "AVS support for the OMAP IP versions 1&2"
+	depends on (ARCH_OMAP3 || ARCH_OMAP4) && PM
+	help
+	  Say Y to enable AVS support on OMAP containing the version 1 or
+	  version 2 of the SmartReflex IP.
+	  V1 is the 65nm version used in OMAP3430.
+	  V2 is the update for the 45nm version of the IP used in OMAP3630
+	  and OMAP4430
 
 	  Please note, that by default SmartReflex is only
-	  initialized. To enable the automatic voltage
-	  compensation for vdd mpu  and vdd core from user space,
+	  initialized and not enabled. To enable the automatic voltage
+	  compensation for vdd mpu and vdd core from user space,
 	  user must write 1 to
-		/debug/voltage/vdd_<X>/smartreflex/autocomp,
-	  where X is mpu or core for OMAP3.
+		/debug/smartreflex/sr_<X>/autocomp,
+	  where X is mpu_iva or core for OMAP3.
 	  Optionally autocompensation can be enabled in the kernel
 	  by default during system init via the enable_on_init flag
 	  which an be passed as platform data to the smartreflex driver.
 
-config OMAP_SMARTREFLEX_CLASS3
+config POWER_AVS_OMAP_CLASS3
 	bool "Class 3 mode of Smartreflex Implementation"
-	depends on OMAP_SMARTREFLEX && TWL4030_CORE
+	depends on POWER_AVS_OMAP && TWL4030_CORE
 	help
 	  Say Y to enable Class 3 implementation of Smartreflex
 
 	  Class 3 implementation of Smartreflex employs continuous hardware
 	  voltage calibration.
 
+endif # POWER_AVS
+
 config OMAP_RESET_CLOCKS
 	bool "Reset unused clocks during boot"
 	depends on ARCH_OMAP
-- 
1.7.5.4

