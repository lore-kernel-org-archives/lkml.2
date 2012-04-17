Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab2DQGey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 02:34:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51779 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2DQGex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 02:34:53 -0400
Message-ID: <1334644486.22780.5.camel@phoenix>
Subject: [PATCH RFT] regulator: tps65910: Use generic regmap enable/disable
 operations
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 17 Apr 2012 14:34:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65910-regulator.c |   69 +++++++-------------------------
 1 files changed, 15 insertions(+), 54 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 747bf57..1ff04a0 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -467,48 +467,6 @@ static int tps65911_get_ctrl_register(int id)
 	}
 }
 
-static int tps65910_is_enabled(struct regulator_dev *dev)
-{
-	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
-	int reg, value, id = rdev_get_id(dev);
-
-	reg = pmic->get_ctrl_reg(id);
-	if (reg < 0)
-		return reg;
-
-	value = tps65910_reg_read(pmic, reg);
-	if (value < 0)
-		return value;
-
-	return value & TPS65910_SUPPLY_STATE_ENABLED;
-}
-
-static int tps65910_enable(struct regulator_dev *dev)
-{
-	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
-	struct tps65910 *mfd = pmic->mfd;
-	int reg, id = rdev_get_id(dev);
-
-	reg = pmic->get_ctrl_reg(id);
-	if (reg < 0)
-		return reg;
-
-	return tps65910_set_bits(mfd, reg, TPS65910_SUPPLY_STATE_ENABLED);
-}
-
-static int tps65910_disable(struct regulator_dev *dev)
-{
-	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
-	struct tps65910 *mfd = pmic->mfd;
-	int reg, id = rdev_get_id(dev);
-
-	reg = pmic->get_ctrl_reg(id);
-	if (reg < 0)
-		return reg;
-
-	return tps65910_clear_bits(mfd, reg, TPS65910_SUPPLY_STATE_ENABLED);
-}
-
 static int tps65910_enable_time(struct regulator_dev *dev)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
@@ -914,9 +872,9 @@ static int tps65910_set_voltage_dcdc_time_sel(struct regulator_dev *dev,
 
 /* Regulator ops (except VRTC) */
 static struct regulator_ops tps65910_ops_dcdc = {
-	.is_enabled		= tps65910_is_enabled,
-	.enable			= tps65910_enable,
-	.disable		= tps65910_disable,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
 	.enable_time		= tps65910_enable_time,
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
@@ -927,9 +885,9 @@ static struct regulator_ops tps65910_ops_dcdc = {
 };
 
 static struct regulator_ops tps65910_ops_vdd3 = {
-	.is_enabled		= tps65910_is_enabled,
-	.enable			= tps65910_enable,
-	.disable		= tps65910_disable,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
 	.enable_time		= tps65910_enable_time,
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
@@ -938,9 +896,9 @@ static struct regulator_ops tps65910_ops_vdd3 = {
 };
 
 static struct regulator_ops tps65910_ops = {
-	.is_enabled		= tps65910_is_enabled,
-	.enable			= tps65910_enable,
-	.disable		= tps65910_disable,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
 	.enable_time		= tps65910_enable_time,
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
@@ -950,9 +908,9 @@ static struct regulator_ops tps65910_ops = {
 };
 
 static struct regulator_ops tps65911_ops = {
-	.is_enabled		= tps65910_is_enabled,
-	.enable			= tps65910_enable,
-	.disable		= tps65910_disable,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
 	.enable_time		= tps65910_enable_time,
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
@@ -1205,10 +1163,13 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 
 		pmic->desc[i].type = REGULATOR_VOLTAGE;
 		pmic->desc[i].owner = THIS_MODULE;
+		pmic->desc[i].enable_reg = pmic->get_ctrl_reg(i);
+		pmic->desc[i].enable_mask = TPS65910_SUPPLY_STATE_ENABLED;
 
 		config.dev = tps65910->dev;
 		config.init_data = reg_data;
 		config.driver_data = pmic;
+		config.regmap = tps65910->regmap;
 
 		rdev = regulator_register(&pmic->desc[i], &config);
 		if (IS_ERR(rdev)) {
-- 
1.7.5.4



