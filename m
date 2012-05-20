Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab2ETCgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:36:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63535 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757541Ab2ETCgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:36:23 -0400
Message-ID: <1337481377.7204.7.camel@phoenix>
Subject: [PATCH RFC/RFT 5/7] regulator: lp3972: Use
 regulator_list_voltage_table()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Date: Sun, 20 May 2012 10:36:17 +0800
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
 drivers/regulator/lp3972.c |  102 +++++++++++++++----------------------------
 1 files changed, 36 insertions(+), 66 deletions(-)

diff --git a/drivers/regulator/lp3972.c b/drivers/regulator/lp3972.c
index de073df..3cdc755 100644
--- a/drivers/regulator/lp3972.c
+++ b/drivers/regulator/lp3972.c
@@ -74,54 +74,40 @@ struct lp3972 {
 #define LP3972_OVER2_LDO4_EN	BIT(4)
 #define LP3972_OVER1_S_EN	BIT(2)
 
-static const int ldo1_voltage_map[] = {
-	1700, 1725, 1750, 1775, 1800, 1825, 1850, 1875,
-	1900, 1925, 1950, 1975, 2000,
+static const unsigned int ldo1_voltage_map[] = {
+	1700000, 1725000, 1750000, 1775000, 1800000, 1825000, 1850000, 1875000,
+	1900000, 1925000, 1950000, 1975000, 2000000,
 };
 
-static const int ldo23_voltage_map[] = {
-	1800, 1900, 2000, 2100, 2200, 2300, 2400, 2500,
-	2600, 2700, 2800, 2900, 3000, 3100, 3200, 3300,
+static const unsigned int ldo23_voltage_map[] = {
+	1800000, 1900000, 2000000, 2100000, 2200000, 2300000, 2400000, 2500000,
+	2600000, 2700000, 2800000, 2900000, 3000000, 3100000, 3200000, 3300000,
 };
 
-static const int ldo4_voltage_map[] = {
-	1000, 1050, 1100, 1150, 1200, 1250, 1300, 1350,
-	1400, 1500, 1800, 1900, 2500, 2800, 3000, 3300,
+static const unsigned int ldo4_voltage_map[] = {
+	1000000, 1050000, 1100000, 1150000, 1200000, 1250000, 1300000, 1350000,
+	1400000, 1500000, 1800000, 1900000, 2500000, 2800000, 3000000, 3300000,
 };
 
-static const int ldo5_voltage_map[] = {
-	   0,    0,    0,    0,    0,  850,  875,  900,
-	 925,  950,  975, 1000, 1025, 1050, 1075, 1100,
-	1125, 1150, 1175, 1200, 1225, 1250, 1275, 1300,
-	1325, 1350, 1375, 1400, 1425, 1450, 1475, 1500,
+static const unsigned int ldo5_voltage_map[] = {
+	      0,       0,       0,       0,       0,  850000,  875000,  900000,
+	 925000,  950000,  975000, 1000000, 1025000, 1050000, 1075000, 1100000,
+	1125000, 1150000, 1175000, 1200000, 1225000, 1250000, 1275000, 1300000,
+	1325000, 1350000, 1375000, 1400000, 1425000, 1450000, 1475000, 1500000,
 };
 
-static const int buck1_voltage_map[] = {
-	 725,  750,  775,  800,  825,  850,  875,  900,
-	 925,  950,  975, 1000, 1025, 1050, 1075, 1100,
-	1125, 1150, 1175, 1200, 1225, 1250, 1275, 1300,
-	1325, 1350, 1375, 1400, 1425, 1450, 1475, 1500,
+static const unsigned int buck1_voltage_map[] = {
+	 725000,  750000,  775000,  800000,  825000,  850000,  875000,  900000,
+	 925000,  950000,  975000, 1000000, 1025000, 1050000, 1075000, 1100000,
+	1125000, 1150000, 1175000, 1200000, 1225000, 1250000, 1275000, 1300000,
+	1325000, 1350000, 1375000, 1400000, 1425000, 1450000, 1475000, 1500000,
 };
 
-static const int buck23_voltage_map[] = {
-	   0,  800,  850,  900,  950, 1000, 1050, 1100,
-	1150, 1200, 1250, 1300, 1350, 1400, 1450, 1500,
-	1550, 1600, 1650, 1700, 1800, 1900, 2500, 2800,
-	3000, 3300,
-};
-
-static const int *ldo_voltage_map[] = {
-	ldo1_voltage_map,
-	ldo23_voltage_map,
-	ldo23_voltage_map,
-	ldo4_voltage_map,
-	ldo5_voltage_map,
-};
-
-static const int *buck_voltage_map[] = {
-	buck1_voltage_map,
-	buck23_voltage_map,
-	buck23_voltage_map,
+static const unsigned int buck23_voltage_map[] = {
+	      0,  800000,  850000,  900000,  950000, 1000000, 1050000, 1100000,
+	1150000, 1200000, 1250000, 1300000, 1350000, 1400000, 1450000, 1500000,
+	1550000, 1600000, 1650000, 1700000, 1800000, 1900000, 2500000, 2800000,
+	3000000, 3300000,
 };
 
 static const int ldo_output_enable_mask[] = {
@@ -160,7 +146,6 @@ static const int buck_base_addr[] = {
 	LP3972_B3TV_REG,
 };
 
-#define LP3972_LDO_VOL_VALUE_MAP(x) (ldo_voltage_map[x])
 #define LP3972_LDO_OUTPUT_ENABLE_MASK(x) (ldo_output_enable_mask[x])
 #define LP3972_LDO_OUTPUT_ENABLE_REG(x) (ldo_output_enable_addr[x])
 
@@ -177,7 +162,6 @@ static const int buck_base_addr[] = {
 #define LP3972_LDO_VOL_MIN_IDX(x) (((x) == 4) ? 0x05 : 0x00)
 #define LP3972_LDO_VOL_MAX_IDX(x) ((x) ? (((x) == 4) ? 0x1f : 0x0f) : 0x0c)
 
-#define LP3972_BUCK_VOL_VALUE_MAP(x) (buck_voltage_map[x])
 #define LP3972_BUCK_VOL_ENABLE_REG(x) (buck_vol_enable_addr[x])
 #define LP3972_BUCK_VOL1_REG(x) (buck_base_addr[x])
 #define LP3972_BUCK_VOL_MASK 0x1f
@@ -242,17 +226,6 @@ static int lp3972_set_bits(struct lp3972 *lp3972, u8 reg, u16 mask, u16 val)
 	return ret;
 }
 
-static int lp3972_ldo_list_voltage(struct regulator_dev *dev, unsigned index)
-{
-	int ldo = rdev_get_id(dev) - LP3972_LDO1;
-
-	if (index < LP3972_LDO_VOL_MIN_IDX(ldo) ||
-	    index > LP3972_LDO_VOL_MAX_IDX(ldo))
-		return -EINVAL;
-
-	return 1000 * LP3972_LDO_VOL_VALUE_MAP(ldo)[index];
-}
-
 static int lp3972_ldo_is_enabled(struct regulator_dev *dev)
 {
 	struct lp3972 *lp3972 = rdev_get_drvdata(dev);
@@ -294,7 +267,7 @@ static int lp3972_ldo_get_voltage(struct regulator_dev *dev)
 	reg = lp3972_reg_read(lp3972, LP3972_LDO_VOL_CONTR_REG(ldo));
 	val = (reg >> LP3972_LDO_VOL_CONTR_SHIFT(ldo)) & mask;
 
-	return 1000 * LP3972_LDO_VOL_VALUE_MAP(ldo)[val];
+	return dev->desc->volt_table[val];
 }
 
 static int lp3972_ldo_set_voltage_sel(struct regulator_dev *dev,
@@ -337,7 +310,7 @@ static int lp3972_ldo_set_voltage_sel(struct regulator_dev *dev,
 }
 
 static struct regulator_ops lp3972_ldo_ops = {
-	.list_voltage = lp3972_ldo_list_voltage,
+	.list_voltage = regulator_list_voltage_table,
 	.is_enabled = lp3972_ldo_is_enabled,
 	.enable = lp3972_ldo_enable,
 	.disable = lp3972_ldo_disable,
@@ -345,17 +318,6 @@ static struct regulator_ops lp3972_ldo_ops = {
 	.set_voltage_sel = lp3972_ldo_set_voltage_sel,
 };
 
-static int lp3972_dcdc_list_voltage(struct regulator_dev *dev, unsigned index)
-{
-	int buck = rdev_get_id(dev) - LP3972_DCDC1;
-
-	if (index < LP3972_BUCK_VOL_MIN_IDX(buck) ||
-	    index > LP3972_BUCK_VOL_MAX_IDX(buck))
-		return -EINVAL;
-
-	return 1000 * buck_voltage_map[buck][index];
-}
-
 static int lp3972_dcdc_is_enabled(struct regulator_dev *dev)
 {
 	struct lp3972 *lp3972 = rdev_get_drvdata(dev);
@@ -401,7 +363,7 @@ static int lp3972_dcdc_get_voltage(struct regulator_dev *dev)
 	reg = lp3972_reg_read(lp3972, LP3972_BUCK_VOL1_REG(buck));
 	reg &= LP3972_BUCK_VOL_MASK;
 	if (reg <= LP3972_BUCK_VOL_MAX_IDX(buck))
-		val = 1000 * buck_voltage_map[buck][reg];
+		val = dev->desc->volt_table[reg];
 	else {
 		val = 0;
 		dev_warn(&dev->dev, "chip reported incorrect voltage value."
@@ -436,7 +398,7 @@ static int lp3972_dcdc_set_voltage_sel(struct regulator_dev *dev,
 }
 
 static struct regulator_ops lp3972_dcdc_ops = {
-	.list_voltage = lp3972_dcdc_list_voltage,
+	.list_voltage = regulator_list_voltage_table,
 	.is_enabled = lp3972_dcdc_is_enabled,
 	.enable = lp3972_dcdc_enable,
 	.disable = lp3972_dcdc_disable,
@@ -450,6 +412,7 @@ static const struct regulator_desc regulators[] = {
 		.id = LP3972_LDO1,
 		.ops = &lp3972_ldo_ops,
 		.n_voltages = ARRAY_SIZE(ldo1_voltage_map),
+		.volt_table = ldo1_voltage_map,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -458,6 +421,7 @@ static const struct regulator_desc regulators[] = {
 		.id = LP3972_LDO2,
 		.ops = &lp3972_ldo_ops,
 		.n_voltages = ARRAY_SIZE(ldo23_voltage_map),
+		.volt_table = ldo23_voltage_map,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -466,6 +430,7 @@ static const struct regulator_desc regulators[] = {
 		.id = LP3972_LDO3,
 		.ops = &lp3972_ldo_ops,
 		.n_voltages = ARRAY_SIZE(ldo23_voltage_map),
+		.volt_table = ldo23_voltage_map,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -474,6 +439,7 @@ static const struct regulator_desc regulators[] = {
 		.id = LP3972_LDO4,
 		.ops = &lp3972_ldo_ops,
 		.n_voltages = ARRAY_SIZE(ldo4_voltage_map),
+		.volt_table = ldo4_voltage_map,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -482,6 +448,7 @@ static const struct regulator_desc regulators[] = {
 		.id = LP3972_LDO5,
 		.ops = &lp3972_ldo_ops,
 		.n_voltages = ARRAY_SIZE(ldo5_voltage_map),
+		.volt_table = ldo5_voltage_map,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -490,6 +457,7 @@ static const struct regulator_desc regulators[] = {
 		.id = LP3972_DCDC1,
 		.ops = &lp3972_dcdc_ops,
 		.n_voltages = ARRAY_SIZE(buck1_voltage_map),
+		.volt_table = buck1_voltage_map,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -498,6 +466,7 @@ static const struct regulator_desc regulators[] = {
 		.id = LP3972_DCDC2,
 		.ops = &lp3972_dcdc_ops,
 		.n_voltages = ARRAY_SIZE(buck23_voltage_map),
+		.volt_table = buck23_voltage_map,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -506,6 +475,7 @@ static const struct regulator_desc regulators[] = {
 		.id = LP3972_DCDC3,
 		.ops = &lp3972_dcdc_ops,
 		.n_voltages = ARRAY_SIZE(buck23_voltage_map),
+		.volt_table = buck23_voltage_map,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
-- 
1.7.5.4



