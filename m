Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab2EONlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:41:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49161 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729Ab2EONla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:41:30 -0400
Message-ID: <1337089278.6238.1.camel@phoenix>
Subject: [PATCH RFT 1/3] regulator: max8660: Convert to
 regulator_list_voltage_linear()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 15 May 2012 21:41:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8660.c |   43 ++++++++++++++++---------------------------
 1 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index 5d56817..67ec6ad 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -126,13 +126,6 @@ static int max8660_dcdc_disable(struct regulator_dev *rdev)
 	return max8660_write(max8660, MAX8660_OVER1, mask, 0);
 }
 
-static int max8660_dcdc_list(struct regulator_dev *rdev, unsigned selector)
-{
-	if (selector > MAX8660_DCDC_MAX_SEL)
-		return -EINVAL;
-	return MAX8660_DCDC_MIN_UV + selector * MAX8660_DCDC_STEP;
-}
-
 static int max8660_dcdc_get(struct regulator_dev *rdev)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
@@ -156,7 +149,7 @@ static int max8660_dcdc_set(struct regulator_dev *rdev, int min_uV, int max_uV,
 	selector = DIV_ROUND_UP(min_uV - MAX8660_DCDC_MIN_UV,
 				MAX8660_DCDC_STEP);
 
-	ret = max8660_dcdc_list(rdev, selector);
+	ret = regulator_list_voltage_linear(rdev, selector);
 	if (ret < 0 || ret > max_uV)
 		return -EINVAL;
 
@@ -174,7 +167,7 @@ static int max8660_dcdc_set(struct regulator_dev *rdev, int min_uV, int max_uV,
 
 static struct regulator_ops max8660_dcdc_ops = {
 	.is_enabled = max8660_dcdc_is_enabled,
-	.list_voltage = max8660_dcdc_list,
+	.list_voltage = regulator_list_voltage_linear,
 	.set_voltage = max8660_dcdc_set,
 	.get_voltage = max8660_dcdc_get,
 };
@@ -184,13 +177,6 @@ static struct regulator_ops max8660_dcdc_ops = {
  * LDO5 functions
  */
 
-static int max8660_ldo5_list(struct regulator_dev *rdev, unsigned selector)
-{
-	if (selector > MAX8660_LDO5_MAX_SEL)
-		return -EINVAL;
-	return MAX8660_LDO5_MIN_UV + selector * MAX8660_LDO5_STEP;
-}
-
 static int max8660_ldo5_get(struct regulator_dev *rdev)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
@@ -214,7 +200,7 @@ static int max8660_ldo5_set(struct regulator_dev *rdev, int min_uV, int max_uV,
 	selector = DIV_ROUND_UP(min_uV - MAX8660_LDO5_MIN_UV,
 				MAX8660_LDO5_STEP);
 
-	ret = max8660_ldo5_list(rdev, selector);
+	ret = regulator_list_voltage_linear(rdev, selector);
 	if (ret < 0 || ret > max_uV)
 		return -EINVAL;
 
@@ -229,7 +215,7 @@ static int max8660_ldo5_set(struct regulator_dev *rdev, int min_uV, int max_uV,
 }
 
 static struct regulator_ops max8660_ldo5_ops = {
-	.list_voltage = max8660_ldo5_list,
+	.list_voltage = regulator_list_voltage_linear,
 	.set_voltage = max8660_ldo5_set,
 	.get_voltage = max8660_ldo5_get,
 };
@@ -261,13 +247,6 @@ static int max8660_ldo67_disable(struct regulator_dev *rdev)
 	return max8660_write(max8660, MAX8660_OVER2, mask, 0);
 }
 
-static int max8660_ldo67_list(struct regulator_dev *rdev, unsigned selector)
-{
-	if (selector > MAX8660_LDO67_MAX_SEL)
-		return -EINVAL;
-	return MAX8660_LDO67_MIN_UV + selector * MAX8660_LDO67_STEP;
-}
-
 static int max8660_ldo67_get(struct regulator_dev *rdev)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
@@ -292,7 +271,7 @@ static int max8660_ldo67_set(struct regulator_dev *rdev, int min_uV,
 	selector = DIV_ROUND_UP(min_uV - MAX8660_LDO67_MIN_UV,
 				MAX8660_LDO67_STEP);
 
-	ret = max8660_ldo67_list(rdev, selector);
+	ret = regulator_list_voltage_linear(rdev, selector);
 	if (ret < 0 || ret > max_uV)
 		return -EINVAL;
 
@@ -308,7 +287,7 @@ static struct regulator_ops max8660_ldo67_ops = {
 	.is_enabled = max8660_ldo67_is_enabled,
 	.enable = max8660_ldo67_enable,
 	.disable = max8660_ldo67_disable,
-	.list_voltage = max8660_ldo67_list,
+	.list_voltage = regulator_list_voltage_linear,
 	.get_voltage = max8660_ldo67_get,
 	.set_voltage = max8660_ldo67_set,
 };
@@ -321,6 +300,8 @@ static const struct regulator_desc max8660_reg[] = {
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = MAX8660_DCDC_MAX_SEL + 1,
 		.owner = THIS_MODULE,
+		.min_uV = MAX8660_DCDC_MIN_UV,
+		.uV_step = MAX8660_DCDC_STEP,
 	},
 	{
 		.name = "V4(DCDC)",
@@ -329,6 +310,8 @@ static const struct regulator_desc max8660_reg[] = {
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = MAX8660_DCDC_MAX_SEL + 1,
 		.owner = THIS_MODULE,
+		.min_uV = MAX8660_DCDC_MIN_UV,
+		.uV_step = MAX8660_DCDC_STEP,
 	},
 	{
 		.name = "V5(LDO)",
@@ -337,6 +320,8 @@ static const struct regulator_desc max8660_reg[] = {
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = MAX8660_LDO5_MAX_SEL + 1,
 		.owner = THIS_MODULE,
+		.min_uV = MAX8660_LDO5_MIN_UV,
+		.uV_step = MAX8660_LDO5_STEP,
 	},
 	{
 		.name = "V6(LDO)",
@@ -345,6 +330,8 @@ static const struct regulator_desc max8660_reg[] = {
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = MAX8660_LDO67_MAX_SEL + 1,
 		.owner = THIS_MODULE,
+		.min_uV = MAX8660_LDO67_MIN_UV,
+		.uV_step = MAX8660_LDO67_STEP,
 	},
 	{
 		.name = "V7(LDO)",
@@ -353,6 +340,8 @@ static const struct regulator_desc max8660_reg[] = {
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = MAX8660_LDO67_MAX_SEL + 1,
 		.owner = THIS_MODULE,
+		.min_uV = MAX8660_LDO67_MIN_UV,
+		.uV_step = MAX8660_LDO67_STEP,
 	},
 };
 
-- 
1.7.5.4



