Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab2FWM4m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 08:56:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45501 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754394Ab2FWMzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 08:55:31 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 7/7] mfd: wm5102: Build system hookup
Date: Sat, 23 Jun 2012 13:55:18 +0100
Message-Id: <1340456118-22366-7-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340456118-22366-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20120623125446.GX4037@opensource.wolfsonmicro.com>
 <1340456118-22366-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several forthcoming Wolfson devices are based on a common platform
known as Arizona allowing a great deal of reuse of driver code. This
patch adds the build system hookup for the core driver and the WM5102.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig  |   29 +++++++++++++++++++++++++++++
 drivers/mfd/Makefile |    7 +++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index e129c82..238e4df 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -479,6 +479,35 @@ config MFD_S5M_CORE
 	 additional drivers must be enabled in order to use the functionality
 	 of the device
 
+config MFD_ARIZONA
+	tristate
+
+config MFD_ARIZONA_I2C
+	tristate "Support Wolfson Microelectronics Arizona platform with I2C"
+	select MFD_ARIZONA
+	select MFD_CORE
+	select REGMAP_I2C
+	depends on I2C
+	help
+	  Support for the Wolfson Microelectronics Arizona platform audio SoC
+	  core functionality controlled via I2C.
+
+config MFD_ARIZONA_SPI
+	tristate "Support Wolfson Microelectronics Arizona platform with SPI"
+	select MFD_ARIZONA
+	select MFD_CORE
+	select REGMAP_SPI
+	depends on SPI_MASTER
+	help
+	  Support for the Wolfson Microelectronics Arizona platform audio SoC
+	  core functionality controlled via I2C.
+
+config MFD_WM5102
+	bool "Support Wolfson Microelectronics WM5102"
+	depends on MFD_ARIZONA
+	help
+	  Support for Wolfson Microelectronics WM5102 low power audio SoC
+
 config MFD_WM8400
 	bool "Support Wolfson Microelectronics WM8400"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 75f6ed6..d29a96d 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -24,6 +24,13 @@ obj-$(CONFIG_MFD_T7L66XB)	+= t7l66xb.o tmio_core.o
 obj-$(CONFIG_MFD_TC6387XB)	+= tc6387xb.o tmio_core.o
 obj-$(CONFIG_MFD_TC6393XB)	+= tc6393xb.o tmio_core.o
 
+obj-$(CONFIG_MFD_ARIZONA)	+= arizona-core.o
+obj-$(CONFIG_MFD_ARIZONA)	+= arizona-irq.o
+obj-$(CONFIG_MFD_ARIZONA_I2C)	+= arizona-i2c.o
+obj-$(CONFIG_MFD_ARIZONA_SPI)	+= arizona-spi.o
+ifneq ($(CONFIG_MFD_WM5102),n)
+obj-$(CONFIG_MFD_ARIZONA)	+= wm5102-tables.o
+endif
 obj-$(CONFIG_MFD_WM8400)	+= wm8400-core.o
 wm831x-objs			:= wm831x-core.o wm831x-irq.o wm831x-otp.o
 wm831x-objs			+= wm831x-auxadc.o
-- 
1.7.10

