Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab2HULlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:41:39 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4033 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2HULlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:41:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 21 Aug 2012 04:35:48 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <a.zummo@towertech.it>, <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <swarren@nvidia.com>, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] rtc: Kconfig: remove unnecessary dependencies.
Date: Tue, 21 Aug 2012 17:01:12 +0530
Message-ID: <1345548672-17832-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

removed "depends on RTC_CLASS = y" for multiple Kconfig
definitions, as all of them were placed under "if RTC_CLASS".

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/rtc/Kconfig |   26 ++++++++------------------
 1 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 878ca31..86f3bbe 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -19,7 +19,6 @@ if RTC_CLASS
 
 config RTC_HCTOSYS
 	bool "Set system time from RTC on startup and resume"
-	depends on RTC_CLASS = y
 	default y
 	help
 	  If you say yes here, the system time (wall clock) will be set using
@@ -51,7 +50,6 @@ config RTC_HCTOSYS_DEVICE
 
 config RTC_DEBUG
 	bool "RTC debug support"
-	depends on RTC_CLASS = y
 	help
 	  Say yes here to enable debugging support in the RTC framework
 	  and individual RTC drivers.
@@ -61,7 +59,6 @@ comment "RTC interfaces"
 config RTC_INTF_SYSFS
 	boolean "/sys/class/rtc/rtcN (sysfs)"
 	depends on SYSFS
-	default RTC_CLASS
 	help
 	  Say yes here if you want to use your RTCs using sysfs interfaces,
 	  /sys/class/rtc/rtc0 through /sys/.../rtcN.
@@ -71,7 +68,6 @@ config RTC_INTF_SYSFS
 config RTC_INTF_PROC
 	boolean "/proc/driver/rtc (procfs for rtc0)"
 	depends on PROC_FS
-	default RTC_CLASS
 	help
 	  Say yes here if you want to use your first RTC through the proc
 	  interface, /proc/driver/rtc. Other RTCs will not be available
@@ -81,7 +77,6 @@ config RTC_INTF_PROC
 
 config RTC_INTF_DEV
 	boolean "/dev/rtcN (character devices)"
-	default RTC_CLASS
 	help
 	  Say yes here if you want to use your RTCs using the /dev
 	  interfaces, which "udev" sets up as /dev/rtc0 through
@@ -127,7 +122,7 @@ if I2C
 
 config RTC_DRV_88PM860X
 	tristate "Marvell 88PM860x"
-	depends on RTC_CLASS && I2C && MFD_88PM860X
+	depends on I2C && MFD_88PM860X
 	help
 	  If you say yes here you get support for RTC function in Marvell
 	  88PM860x chips.
@@ -137,7 +132,7 @@ config RTC_DRV_88PM860X
 
 config RTC_DRV_88PM80X
 	tristate "Marvell 88PM80x"
-	depends on RTC_CLASS && I2C && MFD_88PM800
+	depends on I2C && MFD_88PM800
 	help
 	  If you say yes here you get support for RTC function in Marvell
 	  88PM80x chips.
@@ -165,7 +160,7 @@ config RTC_DRV_DS1307
 
 config RTC_DRV_DS1374
 	tristate "Dallas/Maxim DS1374"
-	depends on RTC_CLASS && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for Dallas Semiconductor
 	  DS1374 real-time clock chips. If an interrupt is associated
@@ -185,7 +180,7 @@ config RTC_DRV_DS1672
 
 config RTC_DRV_DS3232
 	tristate "Dallas/Maxim DS3232"
-	depends on RTC_CLASS && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for Dallas Semiconductor
 	  DS3232 real-time clock chips. If an interrupt is associated
@@ -325,7 +320,7 @@ config RTC_DRV_TWL92330
 
 config RTC_DRV_TWL4030
 	tristate "TI TWL4030/TWL5030/TWL6030/TPS659x0"
-	depends on RTC_CLASS && TWL4030_CORE
+	depends on TWL4030_CORE
 	help
 	  If you say yes here you get support for the RTC on the
 	  TWL4030/TWL5030/TWL6030 family chips, used mostly with OMAP3 platforms.
@@ -548,7 +543,6 @@ config RTC_DRV_DS1302
 
 config RTC_DRV_DS1511
 	tristate "Dallas DS1511"
-	depends on RTC_CLASS
 	help
 	  If you say yes here you get support for the
 	  Dallas DS1511 timekeeping/watchdog chip.
@@ -593,7 +587,6 @@ config RTC_DRV_EFI
 
 config RTC_DRV_STK17TA8
 	tristate "Simtek STK17TA8"
-	depends on RTC_CLASS
 	help
 	  If you say yes here you get support for the
 	  Simtek STK17TA8 timekeeping chip.
@@ -721,7 +714,7 @@ config RTC_DRV_AB8500
 
 config RTC_DRV_NUC900
 	tristate "NUC910/NUC920 RTC driver"
-	depends on RTC_CLASS && ARCH_W90X900
+	depends on ARCH_W90X900
 	help
 	  If you say yes here you get support for the RTC subsystem of the
 	  NUC910/NUC920 used in embedded systems.
@@ -741,7 +734,6 @@ config RTC_DRV_DAVINCI
 config RTC_DRV_IMXDI
 	tristate "Freescale IMX DryIce Real Time Clock"
 	depends on SOC_IMX25
-	depends on RTC_CLASS
 	help
 	   Support for Freescale IMX DryIce RTC
 
@@ -801,7 +793,7 @@ config RTC_DRV_SA1100
 
 config RTC_DRV_SH
 	tristate "SuperH On-Chip RTC"
-	depends on RTC_CLASS && SUPERH && HAVE_CLK
+	depends on SUPERH && HAVE_CLK
 	help
 	  Say Y here to enable support for the on-chip RTC found in
 	  most SuperH processors.
@@ -1033,7 +1025,6 @@ config RTC_DRV_MPC5121
 
 config RTC_DRV_JZ4740
 	tristate "Ingenic JZ4740 SoC"
-	depends on RTC_CLASS
 	depends on MACH_JZ4740
 	help
 	  If you say yes here you get support for the Ingenic JZ4740 SoC RTC
@@ -1063,7 +1054,7 @@ config RTC_DRV_PM8XXX
 
 config RTC_DRV_TEGRA
 	tristate "NVIDIA Tegra Internal RTC driver"
-	depends on RTC_CLASS && ARCH_TEGRA
+	depends on ARCH_TEGRA
 	help
 	  If you say yes here you get support for the
 	  Tegra 200 series internal RTC module.
@@ -1100,7 +1091,6 @@ config RTC_DRV_LOONGSON1
 config RTC_DRV_MXC
 	tristate "Freescale MXC Real Time Clock"
 	depends on ARCH_MXC
-	depends on RTC_CLASS
 	help
 	   If you say yes here you get support for the Freescale MXC
 	   RTC module.
-- 
1.7.1.1

