Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab2BVB32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:29:28 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42699 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab2BVB30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:29:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.241.170 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1329874156.3210.2.camel@phoenix>
Subject: [PATCH] regulator: Sort Kconfig and Makefile entries
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Rapoport <mike@compulab.co.il>, Cyril Chemparathy <cyril@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 22 Feb 2012 09:29:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sort Kconfig entries by company name/driver in alphabetical order.
Sort Makefile entries by alphabetical order.

In order to group all the Kconfig entries by company name,
this patch also adds company name to some Kconfig entries.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/Kconfig  |  304 ++++++++++++++++++++++----------------------
 drivers/regulator/Makefile |   44 +++---
 2 files changed, 174 insertions(+), 174 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index edcd9e2..c733df5 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -74,13 +74,64 @@ config REGULATOR_GPIO
 	  and the platform has to provide a mapping of GPIO-states
 	  to target volts/amps.
 
-config REGULATOR_BQ24022
-	tristate "TI bq24022 Dual Input 1-Cell Li-Ion Charger IC"
+config REGULATOR_AD5398
+	tristate "Analog Devices AD5398/AD5821 regulators"
+	depends on I2C
 	help
-	  This driver controls a TI bq24022 Charger attached via
-	  GPIOs. The provided current regulator can enable/disable
-	  charging select between 100 mA and 500 mA charging current
-	  limit.
+	  This driver supports AD5398 and AD5821 current regulator chips.
+	  If building into module, its name is ad5398.ko.
+
+config REGULATOR_AAT2870
+	tristate "AnalogicTech AAT2870 Regulators"
+	depends on MFD_AAT2870_CORE
+	help
+	  If you have a AnalogicTech AAT2870 say Y to enable the
+	  regulator driver.
+
+config REGULATOR_DA903X
+	tristate "Dialog Semiconductor DA9030/DA9034 regulators"
+	depends on PMIC_DA903X
+	help
+	  Say y here to support the BUCKs and LDOs regulators found on
+	  Dialog Semiconductor DA9030/DA9034 PMIC.
+
+config REGULATOR_DA9052
+	tristate "Dialog Semiconductor DA9052/DA9053 regulators"
+	depends on PMIC_DA9052
+	help
+	  This driver supports the voltage regulators of DA9052-BC and
+	  DA9053-AA/Bx PMIC.
+
+config REGULATOR_MC13XXX_CORE
+	tristate
+
+config REGULATOR_MC13783
+	tristate "Freescale MC13783 regulator driver"
+	depends on MFD_MC13783
+	select REGULATOR_MC13XXX_CORE
+	help
+	  Say y here to support the regulators found on the Freescale MC13783
+	  PMIC.
+
+config REGULATOR_MC13892
+	tristate "Freescale MC13892 regulator driver"
+	depends on MFD_MC13XXX
+	select REGULATOR_MC13XXX_CORE
+	help
+	  Say y here to support the regulators found on the Freescale MC13892
+	  PMIC.
+
+config REGULATOR_ISL6271A
+	tristate "Intersil ISL6271A Power regulator"
+	depends on I2C
+	help
+	  This driver supports ISL6271A voltage regulator chip.
+
+config REGULATOR_88PM8607
+	bool "Marvell 88PM8607 Power regulators"
+	depends on MFD_88PM860X=y
+	help
+	  This driver supports 88PM8607 voltage regulator chips.
 
 config REGULATOR_MAX1586
 	tristate "Maxim 1586/1587 voltage regulator"
@@ -136,69 +187,12 @@ config REGULATOR_MAX8998
 	  via I2C bus. The provided regulator is suitable for S3C6410
 	  and S5PC1XX chips to control VCC_CORE and VCC_USIM voltages.
 
-config REGULATOR_S5M8767
-	tristate "Samsung S5M8767A voltage regulator"
-	depends on MFD_S5M_CORE
-	help
-	 This driver supports a Samsung S5M8767A voltage output regulator
-	 via I2C bus. S5M8767A have 9 Bucks and 28 LDOs output and
-	 supports DVS mode with 8bits of output voltage control.
-
-config REGULATOR_TWL4030
-	bool "TI TWL4030/TWL5030/TWL6030/TPS659x0 PMIC"
-	depends on TWL4030_CORE
-	help
-	  This driver supports the voltage regulators provided by
-	  this family of companion chips.
-
-config REGULATOR_WM831X
-	tristate "Wolfson Microelcronics WM831x PMIC regulators"
-	depends on MFD_WM831X
-	help
-	  Support the voltage and current regulators of the WM831x series
-	  of PMIC devices.
-
-config REGULATOR_WM8350
-	tristate "Wolfson Microelectronics WM8350 AudioPlus PMIC"
-	depends on MFD_WM8350
-	help
-	  This driver provides support for the voltage and current regulators
-          of the WM8350 AudioPlus PMIC.
-
-config REGULATOR_WM8400
-	tristate "Wolfson Microelectronics WM8400 AudioPlus PMIC"
-	depends on MFD_WM8400
-	help
-	  This driver provides support for the voltage regulators of the
-	  WM8400 AudioPlus PMIC.
-
-config REGULATOR_WM8994
-	tristate "Wolfson Microelectronics WM8994 CODEC"
-	depends on MFD_WM8994
-	help
-	  This driver provides support for the voltage regulators on the
-	  WM8994 CODEC.
-
-config REGULATOR_DA903X
-	tristate "Support regulators on Dialog Semiconductor DA9030/DA9034 PMIC"
-	depends on PMIC_DA903X
-	help
-	  Say y here to support the BUCKs and LDOs regulators found on
-	  Dialog Semiconductor DA9030/DA9034 PMIC.
-
-config REGULATOR_DA9052
-	tristate "Dialog DA9052/DA9053 regulators"
-	depends on PMIC_DA9052
-	help
-	  This driver supports the voltage regulators of DA9052-BC and
-	  DA9053-AA/Bx PMIC.
-
-config REGULATOR_PCF50633
-	tristate "PCF50633 regulator driver"
-        depends on MFD_PCF50633
+config REGULATOR_PCAP
+	tristate "Motorola PCAP2 regulator driver"
+	depends on EZX_PCAP
 	help
-	 Say Y here to support the voltage regulators and convertors
-	 on PCF50633
+	 This driver provides support for the voltage regulators of the
+	 PCAP2 PMIC.
 
 config REGULATOR_LP3971
 	tristate "National Semiconductors LP3971 PMIC regulator driver"
@@ -214,31 +208,20 @@ config REGULATOR_LP3972
 	 Say Y here to support the voltage regulators and convertors
 	 on National Semiconductors LP3972 PMIC
 
-config REGULATOR_PCAP
-	tristate "PCAP2 regulator driver"
-	depends on EZX_PCAP
-	help
-	 This driver provides support for the voltage regulators of the
-	 PCAP2 PMIC.
-
-config REGULATOR_MC13XXX_CORE
-	tristate
-
-config REGULATOR_MC13783
-	tristate "Support regulators on Freescale MC13783 PMIC"
-	depends on MFD_MC13783
-	select REGULATOR_MC13XXX_CORE
+config REGULATOR_PCF50633
+	tristate "NXP PCF50633 regulator driver"
+        depends on MFD_PCF50633
 	help
-	  Say y here to support the regulators found on the Freescale MC13783
-	  PMIC.
+	 Say Y here to support the voltage regulators and convertors
+	 on PCF50633
 
-config REGULATOR_MC13892
-	tristate "Support regulators on Freescale MC13892 PMIC"
-	depends on MFD_MC13XXX
-	select REGULATOR_MC13XXX_CORE
+config REGULATOR_S5M8767
+	tristate "Samsung S5M8767A voltage regulator"
+	depends on MFD_S5M_CORE
 	help
-	  Say y here to support the regulators found on the Freescale MC13892
-	  PMIC.
+	 This driver supports a Samsung S5M8767A voltage output regulator
+	 via I2C bus. S5M8767A have 9 Bucks and 28 LDOs output and
+	 supports DVS mode with 8bits of output voltage control.
 
 config REGULATOR_AB3100
 	tristate "ST-Ericsson AB3100 Regulator functions"
@@ -249,6 +232,32 @@ config REGULATOR_AB3100
 	 AB3100 analog baseband dealing with power regulators
 	 for the system.
 
+config REGULATOR_AB8500
+	bool "ST-Ericsson AB8500 Power Regulators"
+	depends on AB8500_CORE
+	help
+	  This driver supports the regulators found on the ST-Ericsson mixed
+	  signal AB8500 PMIC
+
+config REGULATOR_DBX500_PRCMU
+	bool
+
+config REGULATOR_DB8500_PRCMU
+	bool "ST-Ericsson DB8500 Voltage Domain Regulators"
+	depends on MFD_DB8500_PRCMU
+	select REGULATOR_DBX500_PRCMU
+	help
+	  This driver supports the voltage domain regulators controlled by the
+	  DB8500 PRCMU
+
+config REGULATOR_BQ24022
+	tristate "TI bq24022 Dual Input 1-Cell Li-Ion Charger IC"
+	help
+	  This driver controls a TI bq24022 Charger attached via
+	  GPIOs. The provided current regulator can enable/disable
+	  charging select between 100 mA and 500 mA charging current
+	  limit.
+
 config REGULATOR_TPS6105X
 	tristate "TI TPS6105X Power regulators"
 	depends on TPS6105X
@@ -258,6 +267,16 @@ config REGULATOR_TPS6105X
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
@@ -284,55 +303,6 @@ config REGULATOR_TPS65217
 	  voltage regulators. It supports software based voltage control
 	  for different voltage domains
 
-config REGULATOR_TPS65912
-	tristate "TI TPS65912 Power regulator"
-	depends on (MFD_TPS65912_I2C || MFD_TPS65912_SPI)
-	help
-	    This driver supports TPS65912 voltage regulator chip.
-
-config REGULATOR_88PM8607
-	bool "Marvell 88PM8607 Power regulators"
-	depends on MFD_88PM860X=y
-	help
-	  This driver supports 88PM8607 voltage regulator chips.
-
-config REGULATOR_ISL6271A
-	tristate "Intersil ISL6271A Power regulator"
-	depends on I2C
-	help
-	  This driver supports ISL6271A voltage regulator chip.
-
-config REGULATOR_AD5398
-	tristate "Analog Devices AD5398/AD5821 regulators"
-	depends on I2C
-	help
-	  This driver supports AD5398 and AD5821 current regulator chips.
-	  If building into module, its name is ad5398.ko.
-
-config REGULATOR_AB8500
-	bool "ST-Ericsson AB8500 Power Regulators"
-	depends on AB8500_CORE
-	help
-	  This driver supports the regulators found on the ST-Ericsson mixed
-	  signal AB8500 PMIC
-
-config REGULATOR_DBX500_PRCMU
-	bool
-
-config REGULATOR_DB8500_PRCMU
-	bool "ST-Ericsson DB8500 Voltage Domain Regulators"
-	depends on MFD_DB8500_PRCMU
-	select REGULATOR_DBX500_PRCMU
-	help
-	  This driver supports the voltage domain regulators controlled by the
-	  DB8500 PRCMU
-
-config REGULATOR_TPS6586X
-	tristate "TI TPS6586X Power regulators"
-	depends on MFD_TPS6586X
-	help
-	  This driver supports TPS6586X voltage regulator chips.
-
 config REGULATOR_TPS6524X
 	tristate "TI TPS6524X Power regulators"
 	depends on SPI
@@ -343,28 +313,58 @@ config REGULATOR_TPS6524X
 	  serial interface currently supported on the sequencer serial
 	  port controller.
 
+config REGULATOR_TPS6586X
+	tristate "TI TPS6586X Power regulators"
+	depends on MFD_TPS6586X
+	help
+	  This driver supports TPS6586X voltage regulator chips.
+
 config REGULATOR_TPS65910
 	tristate "TI TPS65910/TPS65911 Power Regulators"
 	depends on MFD_TPS65910
 	help
 	  This driver supports TPS65910/TPS65911 voltage regulator chips.
 
-config REGULATOR_TPS62360
-	tristate "TI TPS62360 Power Regulator"
-	depends on I2C
-	select REGMAP_I2C
+config REGULATOR_TPS65912
+	tristate "TI TPS65912 Power regulator"
+	depends on (MFD_TPS65912_I2C || MFD_TPS65912_SPI)
 	help
-	  This driver supports TPS62360 voltage regulator chip. This
-	  regulator is meant for processor core supply. This chip is
-	  high-frequency synchronous step down dc-dc converter optimized
-	  for battery-powered portable applications.
+	    This driver supports TPS65912 voltage regulator chip.
 
-config REGULATOR_AAT2870
-	tristate "AnalogicTech AAT2870 Regulators"
-	depends on MFD_AAT2870_CORE
+config REGULATOR_TWL4030
+	bool "TI TWL4030/TWL5030/TWL6030/TPS659x0 PMIC"
+	depends on TWL4030_CORE
 	help
-	  If you have a AnalogicTech AAT2870 say Y to enable the
-	  regulator driver.
+	  This driver supports the voltage regulators provided by
+	  this family of companion chips.
+
+config REGULATOR_WM831X
+	tristate "Wolfson Microelectronics WM831x PMIC regulators"
+	depends on MFD_WM831X
+	help
+	  Support the voltage and current regulators of the WM831x series
+	  of PMIC devices.
+
+config REGULATOR_WM8350
+	tristate "Wolfson Microelectronics WM8350 AudioPlus PMIC"
+	depends on MFD_WM8350
+	help
+	  This driver provides support for the voltage and current regulators
+          of the WM8350 AudioPlus PMIC.
+
+config REGULATOR_WM8400
+	tristate "Wolfson Microelectronics WM8400 AudioPlus PMIC"
+	depends on MFD_WM8400
+	help
+	  This driver provides support for the voltage regulators of the
+	  WM8400 AudioPlus PMIC.
+
+config REGULATOR_WM8994
+	tristate "Wolfson Microelectronics WM8994 CODEC"
+	depends on MFD_WM8994
+	help
+	  This driver provides support for the voltage regulators on the
+	  WM8994 CODEC.
 
 endif
 
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 4cbf8c5..cf0934b 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -10,48 +10,48 @@ obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
 
 obj-$(CONFIG_REGULATOR_GPIO) += gpio-regulator.o
+obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
+obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
+obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
+obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
 obj-$(CONFIG_REGULATOR_AD5398) += ad5398.o
 obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
+obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
+obj-$(CONFIG_REGULATOR_DA9052)	+= da9052-regulator.o
+obj-$(CONFIG_REGULATOR_DBX500_PRCMU) += dbx500-prcmu.o
+obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
+obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
 obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
 obj-$(CONFIG_REGULATOR_LP3972) += lp3972.o
 obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
-obj-$(CONFIG_REGULATOR_TWL4030) += twl-regulator.o
 obj-$(CONFIG_REGULATOR_MAX8649)	+= max8649.o
 obj-$(CONFIG_REGULATOR_MAX8660) += max8660.o
 obj-$(CONFIG_REGULATOR_MAX8925) += max8925-regulator.o
 obj-$(CONFIG_REGULATOR_MAX8952) += max8952.o
 obj-$(CONFIG_REGULATOR_MAX8997) += max8997.o
 obj-$(CONFIG_REGULATOR_MAX8998) += max8998.o
-obj-$(CONFIG_REGULATOR_WM831X) += wm831x-dcdc.o
-obj-$(CONFIG_REGULATOR_WM831X) += wm831x-isink.o
-obj-$(CONFIG_REGULATOR_WM831X) += wm831x-ldo.o
-obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
-obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
-obj-$(CONFIG_REGULATOR_WM8994) += wm8994-regulator.o
-obj-$(CONFIG_REGULATOR_TPS6586X) += tps6586x-regulator.o
-obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
-obj-$(CONFIG_REGULATOR_DA9052)	+= da9052-regulator.o
-obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
-obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
 obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
 obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o
 obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
-obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
+obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
+obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
+obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
 obj-$(CONFIG_REGULATOR_TPS6105X) += tps6105x-regulator.o
+obj-$(CONFIG_REGULATOR_TPS62360) += tps62360-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65023) += tps65023-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6507X) += tps6507x-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65217) += tps65217-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6524X) += tps6524x-regulator.o
-obj-$(CONFIG_REGULATOR_TPS65912) += tps65912-regulator.o
-obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
-obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
-obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
-obj-$(CONFIG_REGULATOR_DBX500_PRCMU) += dbx500-prcmu.o
-obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
+obj-$(CONFIG_REGULATOR_TPS6586X) += tps6586x-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
-obj-$(CONFIG_REGULATOR_TPS62360) += tps62360-regulator.o
-obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
-obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
+obj-$(CONFIG_REGULATOR_TPS65912) += tps65912-regulator.o
+obj-$(CONFIG_REGULATOR_TWL4030) += twl-regulator.o
+obj-$(CONFIG_REGULATOR_WM831X) += wm831x-dcdc.o
+obj-$(CONFIG_REGULATOR_WM831X) += wm831x-isink.o
+obj-$(CONFIG_REGULATOR_WM831X) += wm831x-ldo.o
+obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
+obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
+obj-$(CONFIG_REGULATOR_WM8994) += wm8994-regulator.o
 
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
-- 
1.7.5.4



