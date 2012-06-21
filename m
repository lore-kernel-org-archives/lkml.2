Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab2FUKsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 06:48:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59011 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab2FUKsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 06:48:07 -0400
Message-ID: <1340275680.2922.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: tps65910: Convert to
 regulator_list_voltage_table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Thu, 21 Jun 2012 18:48:00 +0800
In-Reply-To: <1340275546.2922.1.camel@phoenix>
References: <1340275546.2922.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert tps65910_ops and tps65910_ops_vdd3 to regulator_list_voltage_table.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65910-regulator.c |   94 ++++++++++++++------------------
 1 file changed, 40 insertions(+), 54 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index edeaa2c..66da87c 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -31,62 +31,62 @@
 			TPS65910_SLEEP_CONTROL_EXT_INPUT_EN3 |		\
 			TPS65911_SLEEP_CONTROL_EXT_INPUT_SLEEP)
 
-/* supported VIO voltages in millivolts */
-static const u16 VIO_VSEL_table[] = {
-	1500, 1800, 2500, 3300,
+/* supported VIO voltages in microvolts */
+static const unsigned int VIO_VSEL_table[] = {
+	1500000, 1800000, 2500000, 3300000,
 };
 
 /* VSEL tables for TPS65910 specific LDOs and dcdc's */
 
-/* supported VDD3 voltages in millivolts */
-static const u16 VDD3_VSEL_table[] = {
-	5000,
+/* supported VDD3 voltages in microvolts */
+static const unsigned int VDD3_VSEL_table[] = {
+	5000000,
 };
 
-/* supported VDIG1 voltages in millivolts */
-static const u16 VDIG1_VSEL_table[] = {
-	1200, 1500, 1800, 2700,
+/* supported VDIG1 voltages in microvolts */
+static const unsigned int VDIG1_VSEL_table[] = {
+	1200000, 1500000, 1800000, 2700000,
 };
 
-/* supported VDIG2 voltages in millivolts */
-static const u16 VDIG2_VSEL_table[] = {
-	1000, 1100, 1200, 1800,
+/* supported VDIG2 voltages in microvolts */
+static const unsigned int VDIG2_VSEL_table[] = {
+	1000000, 1100000, 1200000, 1800000,
 };
 
-/* supported VPLL voltages in millivolts */
-static const u16 VPLL_VSEL_table[] = {
-	1000, 1100, 1800, 2500,
+/* supported VPLL voltages in microvolts */
+static const unsigned int VPLL_VSEL_table[] = {
+	1000000, 1100000, 1800000, 2500000,
 };
 
-/* supported VDAC voltages in millivolts */
-static const u16 VDAC_VSEL_table[] = {
-	1800, 2600, 2800, 2850,
+/* supported VDAC voltages in microvolts */
+static const unsigned int VDAC_VSEL_table[] = {
+	1800000, 2600000, 2800000, 2850000,
 };
 
-/* supported VAUX1 voltages in millivolts */
-static const u16 VAUX1_VSEL_table[] = {
-	1800, 2500, 2800, 2850,
+/* supported VAUX1 voltages in microvolts */
+static const unsigned int VAUX1_VSEL_table[] = {
+	1800000, 2500000, 2800000, 2850000,
 };
 
-/* supported VAUX2 voltages in millivolts */
-static const u16 VAUX2_VSEL_table[] = {
-	1800, 2800, 2900, 3300,
+/* supported VAUX2 voltages in microvolts */
+static const unsigned int VAUX2_VSEL_table[] = {
+	1800000, 2800000, 2900000, 3300000,
 };
 
-/* supported VAUX33 voltages in millivolts */
-static const u16 VAUX33_VSEL_table[] = {
-	1800, 2000, 2800, 3300,
+/* supported VAUX33 voltages in microvolts */
+static const unsigned int VAUX33_VSEL_table[] = {
+	1800000, 2000000, 2800000, 3300000,
 };
 
-/* supported VMMC voltages in millivolts */
-static const u16 VMMC_VSEL_table[] = {
-	1800, 2800, 3000, 3300,
+/* supported VMMC voltages in microvolts */
+static const unsigned int VMMC_VSEL_table[] = {
+	1800000, 2800000, 3000000, 3300000,
 };
 
 struct tps_info {
 	const char *name;
 	u8 n_voltages;
-	const u16 *voltage_table;
+	const unsigned int *voltage_table;
 	int enable_time_us;
 };
 
@@ -559,7 +559,7 @@ static int tps65910_get_voltage_sel(struct regulator_dev *dev)
 
 static int tps65910_get_voltage_vdd3(struct regulator_dev *dev)
 {
-	return 5 * 1000 * 1000;
+	return dev->desc->volt_table[0];
 }
 
 static int tps65911_get_voltage_sel(struct regulator_dev *dev)
@@ -718,23 +718,6 @@ static int tps65910_list_voltage_dcdc(struct regulator_dev *dev,
 	return  volt * 100 * mult;
 }
 
-static int tps65910_list_voltage(struct regulator_dev *dev,
-					unsigned selector)
-{
-	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
-	int id = rdev_get_id(dev), voltage;
-
-	if (id < TPS65910_REG_VIO || id > TPS65910_REG_VMMC)
-		return -EINVAL;
-
-	if (selector >= pmic->info[id]->n_voltages)
-		return -EINVAL;
-	else
-		voltage = pmic->info[id]->voltage_table[selector] * 1000;
-
-	return voltage;
-}
-
 static int tps65911_list_voltage(struct regulator_dev *dev, unsigned selector)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
@@ -766,7 +749,7 @@ static int tps65911_list_voltage(struct regulator_dev *dev, unsigned selector)
 		step_mv = 100;
 		break;
 	case TPS65910_REG_VIO:
-		return pmic->info[id]->voltage_table[selector] * 1000;
+		return pmic->info[id]->voltage_table[selector];
 	default:
 		return -EINVAL;
 	}
@@ -796,7 +779,7 @@ static struct regulator_ops tps65910_ops_vdd3 = {
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
 	.get_voltage		= tps65910_get_voltage_vdd3,
-	.list_voltage		= tps65910_list_voltage,
+	.list_voltage		= regulator_list_voltage_table,
 };
 
 static struct regulator_ops tps65910_ops = {
@@ -808,7 +791,7 @@ static struct regulator_ops tps65910_ops = {
 	.get_mode		= tps65910_get_mode,
 	.get_voltage_sel	= tps65910_get_voltage_sel,
 	.set_voltage_sel	= tps65910_set_voltage_sel,
-	.list_voltage		= tps65910_list_voltage,
+	.list_voltage		= regulator_list_voltage_table,
 };
 
 static struct regulator_ops tps65911_ops = {
@@ -1165,15 +1148,18 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		} else if (i == TPS65910_REG_VDD3) {
 			if (tps65910_chip_id(tps65910) == TPS65910) {
 				pmic->desc[i].ops = &tps65910_ops_vdd3;
+				pmic->desc[i].volt_table = info->voltage_table;
 			} else {
 				pmic->desc[i].ops = &tps65910_ops_dcdc;
 				pmic->desc[i].ramp_delay = 5000;
 			}
 		} else {
-			if (tps65910_chip_id(tps65910) == TPS65910)
+			if (tps65910_chip_id(tps65910) == TPS65910) {
 				pmic->desc[i].ops = &tps65910_ops;
-			else
+				pmic->desc[i].volt_table = info->voltage_table;
+			} else {
 				pmic->desc[i].ops = &tps65911_ops;
+			}
 		}
 
 		err = tps65910_set_ext_sleep_config(pmic, i,
-- 
1.7.9.5



