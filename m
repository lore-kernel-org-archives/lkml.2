Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab2ETClM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:41:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43278 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab2ETCjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:39:18 -0400
Message-ID: <1337481552.7204.10.camel@phoenix>
Subject: [PATCH RFC/RFT 7/7] regulator: tps6507x: Use
 regulator_list_voltage_table()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Anuj Aggarwal <anuj.aggarwal@ti.com>
Date: Sun, 20 May 2012 10:39:12 +0800
In-Reply-To: <1337481021.7204.1.camel@phoenix>
References: <1337481021.7204.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6507x-regulator.c |  100 ++++++++++++++------------------
 1 files changed, 43 insertions(+), 57 deletions(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index da38be1..c771e10 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -43,50 +43,50 @@
 /* Number of total regulators available */
 #define TPS6507X_NUM_REGULATOR		(TPS6507X_NUM_DCDC + TPS6507X_NUM_LDO)
 
-/* Supported voltage values for regulators (in milliVolts) */
-static const u16 VDCDCx_VSEL_table[] = {
-	725, 750, 775, 800,
-	825, 850, 875, 900,
-	925, 950, 975, 1000,
-	1025, 1050, 1075, 1100,
-	1125, 1150, 1175, 1200,
-	1225, 1250, 1275, 1300,
-	1325, 1350, 1375, 1400,
-	1425, 1450, 1475, 1500,
-	1550, 1600, 1650, 1700,
-	1750, 1800, 1850, 1900,
-	1950, 2000, 2050, 2100,
-	2150, 2200, 2250, 2300,
-	2350, 2400, 2450, 2500,
-	2550, 2600, 2650, 2700,
-	2750, 2800, 2850, 2900,
-	3000, 3100, 3200, 3300,
+/* Supported voltage values for regulators (in microVolts) */
+static const unsigned int VDCDCx_VSEL_table[] = {
+	725000, 750000, 775000, 800000,
+	825000, 850000, 875000, 900000,
+	925000, 950000, 975000, 1000000,
+	1025000, 1050000, 1075000, 1100000,
+	1125000, 1150000, 1175000, 1200000,
+	1225000, 1250000, 1275000, 1300000,
+	1325000, 1350000, 1375000, 1400000,
+	1425000, 1450000, 1475000, 1500000,
+	1550000, 1600000, 1650000, 1700000,
+	1750000, 1800000, 1850000, 1900000,
+	1950000, 2000000, 2050000, 2100000,
+	2150000, 2200000, 2250000, 2300000,
+	2350000, 2400000, 2450000, 2500000,
+	2550000, 2600000, 2650000, 2700000,
+	2750000, 2800000, 2850000, 2900000,
+	3000000, 3100000, 3200000, 3300000,
 };
 
-static const u16 LDO1_VSEL_table[] = {
-	1000, 1100, 1200, 1250,
-	1300, 1350, 1400, 1500,
-	1600, 1800, 2500, 2750,
-	2800, 3000, 3100, 3300,
+static const unsigned int LDO1_VSEL_table[] = {
+	1000000, 1100000, 1200000, 1250000,
+	1300000, 1350000, 1400000, 1500000,
+	1600000, 1800000, 2500000, 2750000,
+	2800000, 3000000, 3100000, 3300000,
 };
 
-static const u16 LDO2_VSEL_table[] = {
-	725, 750, 775, 800,
-	825, 850, 875, 900,
-	925, 950, 975, 1000,
-	1025, 1050, 1075, 1100,
-	1125, 1150, 1175, 1200,
-	1225, 1250, 1275, 1300,
-	1325, 1350, 1375, 1400,
-	1425, 1450, 1475, 1500,
-	1550, 1600, 1650, 1700,
-	1750, 1800, 1850, 1900,
-	1950, 2000, 2050, 2100,
-	2150, 2200, 2250, 2300,
-	2350, 2400, 2450, 2500,
-	2550, 2600, 2650, 2700,
-	2750, 2800, 2850, 2900,
-	3000, 3100, 3200, 3300,
+static const unsigned int LDO2_VSEL_table[] = {
+	725000, 750000, 775000, 800000,
+	825000, 850000, 875000, 900000,
+	925000, 950000, 975000, 1000000,
+	1025000, 1050000, 1075000, 1100000,
+	1125000, 1150000, 1175000, 1200000,
+	1225000, 1250000, 1275000, 1300000,
+	1325000, 1350000, 1375000, 1400000,
+	1425000, 1450000, 1475000, 1500000,
+	1550000, 1600000, 1650000, 1700000,
+	1750000, 1800000, 1850000, 1900000,
+	1950000, 2000000, 2050000, 2100000,
+	2150000, 2200000, 2250000, 2300000,
+	2350000, 2400000, 2450000, 2500000,
+	2550000, 2600000, 2650000, 2700000,
+	2750000, 2800000, 2850000, 2900000,
+	3000000, 3100000, 3200000, 3300000,
 };
 
 struct tps_info {
@@ -94,7 +94,7 @@ struct tps_info {
 	unsigned min_uV;
 	unsigned max_uV;
 	u8 table_len;
-	const u16 *table;
+	const unsigned int *table;
 
 	/* Does DCDC high or the low register defines output voltage? */
 	bool defdcdc_default;
@@ -375,28 +375,13 @@ static int tps6507x_pmic_set_voltage_sel(struct regulator_dev *dev,
 	return tps6507x_pmic_reg_write(tps, reg, data);
 }
 
-static int tps6507x_pmic_list_voltage(struct regulator_dev *dev,
-					unsigned selector)
-{
-	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
-	int rid = rdev_get_id(dev);
-
-	if (rid < TPS6507X_DCDC_1 || rid > TPS6507X_LDO_2)
-		return -EINVAL;
-
-	if (selector >= tps->info[rid]->table_len)
-		return -EINVAL;
-	else
-		return tps->info[rid]->table[selector] * 1000;
-}
-
 static struct regulator_ops tps6507x_pmic_ops = {
 	.is_enabled = tps6507x_pmic_is_enabled,
 	.enable = tps6507x_pmic_enable,
 	.disable = tps6507x_pmic_disable,
 	.get_voltage_sel = tps6507x_pmic_get_voltage_sel,
 	.set_voltage_sel = tps6507x_pmic_set_voltage_sel,
-	.list_voltage = tps6507x_pmic_list_voltage,
+	.list_voltage = regulator_list_voltage_table,
 };
 
 static __devinit int tps6507x_pmic_probe(struct platform_device *pdev)
@@ -449,6 +434,7 @@ static __devinit int tps6507x_pmic_probe(struct platform_device *pdev)
 		tps->desc[i].name = info->name;
 		tps->desc[i].id = i;
 		tps->desc[i].n_voltages = info->table_len;
+		tps->desc[i].volt_table = info->table;
 		tps->desc[i].ops = &tps6507x_pmic_ops;
 		tps->desc[i].type = REGULATOR_VOLTAGE;
 		tps->desc[i].owner = THIS_MODULE;
-- 
1.7.5.4



