Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab2BUEpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 23:45:04 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57795 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2BUEpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 23:45:01 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.219.232 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1329799491.7033.1.camel@phoenix>
Subject: [PATCH] regulator: Group TI TPSxxxxx regulators together
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Rapoport <mike@compulab.co.il>, Cyril Chemparathy <cyril@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 21 Feb 2012 12:44:51 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group TI TPSxxxxx regulators together and sort them in alphabetical order.
This change makes it easier for users to find config options.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Mike Rapoport <mike@compulab.co.il>
Cc: Cyril Chemparathy <cyril@ti.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/Kconfig  |   64 ++++++++++++++++++++++----------------------
 drivers/regulator/Makefile |    6 ++--
 2 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index edcd9e2..343ab78 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -258,6 +258,16 @@ config REGULATOR_TPS6105X
 	  It is a single boost converter primarily for white LEDs and
 	  audio amplifiers.
 
+config REGULATOR_TPS62360
+	tristate "TI TPS62360 Power Regulator"
+	depends on I2C
+	select REGMAP_I2C
+	help
+	  This driver supports TPS62360 voltage regulator chip. This
+	  regulator is meant for processor core supply. This chip is
+	  high-frequency synchronous step down dc-dc converter optimized
+	  for battery-powered portable applications.
+
 config REGULATOR_TPS65023
 	tristate "TI TPS65023 Power regulators"
 	depends on I2C
@@ -284,6 +294,28 @@ config REGULATOR_TPS65217
 	  voltage regulators. It supports software based voltage control
 	  for different voltage domains
 
+config REGULATOR_TPS6524X
+	tristate "TI TPS6524X Power regulators"
+	depends on SPI
+	help
+	  This driver supports TPS6524X voltage regulator chips. TPS6524X
+	  provides three step-down converters and two general-purpose LDO
+	  voltage regulators.  This device is interfaced using a customized
+	  serial interface currently supported on the sequencer serial
+	  port controller.
+
+config REGULATOR_TPS6586X
+	tristate "TI TPS6586X Power regulators"
+	depends on MFD_TPS6586X
+	help
+	  This driver supports TPS6586X voltage regulator chips.
+
+config REGULATOR_TPS65910
+	tristate "TI TPS65910/TPS65911 Power Regulators"
+	depends on MFD_TPS65910
+	help
+	  This driver supports TPS65910/TPS65911 voltage regulator chips.
+
 config REGULATOR_TPS65912
 	tristate "TI TPS65912 Power regulator"
 	depends on (MFD_TPS65912_I2C || MFD_TPS65912_SPI)
@@ -327,38 +359,6 @@ config REGULATOR_DB8500_PRCMU
 	  This driver supports the voltage domain regulators controlled by the
 	  DB8500 PRCMU
 
-config REGULATOR_TPS6586X
-	tristate "TI TPS6586X Power regulators"
-	depends on MFD_TPS6586X
-	help
-	  This driver supports TPS6586X voltage regulator chips.
-
-config REGULATOR_TPS6524X
-	tristate "TI TPS6524X Power regulators"
-	depends on SPI
-	help
-	  This driver supports TPS6524X voltage regulator chips. TPS6524X
-	  provides three step-down converters and two general-purpose LDO
-	  voltage regulators.  This device is interfaced using a customized
-	  serial interface currently supported on the sequencer serial
-	  port controller.
-
-config REGULATOR_TPS65910
-	tristate "TI TPS65910/TPS65911 Power Regulators"
-	depends on MFD_TPS65910
-	help
-	  This driver supports TPS65910/TPS65911 voltage regulator chips.
-
-config REGULATOR_TPS62360
-	tristate "TI TPS62360 Power Regulator"
-	depends on I2C
-	select REGMAP_I2C
-	help
-	  This driver supports TPS62360 voltage regulator chip. This
-	  regulator is meant for processor core supply. This chip is
-	  high-frequency synchronous step down dc-dc converter optimized
-	  for battery-powered portable applications.
-
 config REGULATOR_AAT2870
 	tristate "AnalogicTech AAT2870 Regulators"
 	depends on MFD_AAT2870_CORE
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 4cbf8c5..eb1920b 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -28,7 +28,6 @@ obj-$(CONFIG_REGULATOR_WM831X) += wm831x-ldo.o
 obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 obj-$(CONFIG_REGULATOR_WM8994) += wm8994-regulator.o
-obj-$(CONFIG_REGULATOR_TPS6586X) += tps6586x-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_DA9052)	+= da9052-regulator.o
 obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
@@ -38,18 +37,19 @@ obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o
 obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
 obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
 obj-$(CONFIG_REGULATOR_TPS6105X) += tps6105x-regulator.o
+obj-$(CONFIG_REGULATOR_TPS62360) += tps62360-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65023) += tps65023-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6507X) += tps6507x-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65217) += tps65217-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6524X) += tps6524x-regulator.o
+obj-$(CONFIG_REGULATOR_TPS6586X) += tps6586x-regulator.o
+obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65912) += tps65912-regulator.o
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
 obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
 obj-$(CONFIG_REGULATOR_DBX500_PRCMU) += dbx500-prcmu.o
 obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
-obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
-obj-$(CONFIG_REGULATOR_TPS62360) += tps62360-regulator.o
 obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
 obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
 
-- 
1.7.5.4



