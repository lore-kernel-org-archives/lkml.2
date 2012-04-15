Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab2DOLvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 07:51:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44646 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753509Ab2DOLtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 07:49:43 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/8] regulator: wm8994: Use core voltage selector operations
Date: Sun, 15 Apr 2012 12:49:22 +0100
Message-Id: <1334490565-19808-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334490565-19808-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1334490565-19808-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8994-regulator.c |   59 +++++----------------------------
 1 files changed, 9 insertions(+), 50 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 0ee81e1..e07972f 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -86,29 +86,6 @@ static int wm8994_ldo1_list_voltage(struct regulator_dev *rdev,
 	return (selector * 100000) + 2400000;
 }
 
-static int wm8994_ldo1_get_voltage_sel(struct regulator_dev *rdev)
-{
-	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
-	int val;
-
-	val = wm8994_reg_read(ldo->wm8994, WM8994_LDO_1);
-	if (val < 0)
-		return val;
-
-	return (val & WM8994_LDO1_VSEL_MASK) >> WM8994_LDO1_VSEL_SHIFT;
-}
-
-static int wm8994_ldo1_set_voltage_sel(struct regulator_dev *rdev,
-				       unsigned selector)
-{
-	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
-
-	selector <<= WM8994_LDO1_VSEL_SHIFT;
-
-	return wm8994_set_bits(ldo->wm8994, WM8994_LDO_1,
-			       WM8994_LDO1_VSEL_MASK, selector);
-}
-
 static struct regulator_ops wm8994_ldo1_ops = {
 	.enable = wm8994_ldo_enable,
 	.disable = wm8994_ldo_disable,
@@ -116,8 +93,8 @@ static struct regulator_ops wm8994_ldo1_ops = {
 	.enable_time = wm8994_ldo_enable_time,
 
 	.list_voltage = wm8994_ldo1_list_voltage,
-	.get_voltage_sel = wm8994_ldo1_get_voltage_sel,
-	.set_voltage_sel = wm8994_ldo1_set_voltage_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 };
 
 static int wm8994_ldo2_list_voltage(struct regulator_dev *rdev,
@@ -146,29 +123,6 @@ static int wm8994_ldo2_list_voltage(struct regulator_dev *rdev,
 	}
 }
 
-static int wm8994_ldo2_get_voltage_sel(struct regulator_dev *rdev)
-{
-	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
-	int val;
-
-	val = wm8994_reg_read(ldo->wm8994, WM8994_LDO_2);
-	if (val < 0)
-		return val;
-
-	return (val & WM8994_LDO2_VSEL_MASK) >> WM8994_LDO2_VSEL_SHIFT;
-}
-
-static int wm8994_ldo2_set_voltage_sel(struct regulator_dev *rdev,
-				       unsigned selector)
-{
-	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
-
-	selector <<= WM8994_LDO2_VSEL_SHIFT;
-
-	return wm8994_set_bits(ldo->wm8994, WM8994_LDO_2,
-			       WM8994_LDO2_VSEL_MASK, selector);
-}
-
 static struct regulator_ops wm8994_ldo2_ops = {
 	.enable = wm8994_ldo_enable,
 	.disable = wm8994_ldo_disable,
@@ -176,8 +130,8 @@ static struct regulator_ops wm8994_ldo2_ops = {
 	.enable_time = wm8994_ldo_enable_time,
 
 	.list_voltage = wm8994_ldo2_list_voltage,
-	.get_voltage_sel = wm8994_ldo2_get_voltage_sel,
-	.set_voltage_sel = wm8994_ldo2_set_voltage_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 };
 
 static const struct regulator_desc wm8994_ldo_desc[] = {
@@ -186,6 +140,8 @@ static const struct regulator_desc wm8994_ldo_desc[] = {
 		.id = 1,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8994_LDO1_MAX_SELECTOR + 1,
+		.vsel_reg = WM8994_LDO_1,
+		.vsel_mask = WM8994_LDO1_VSEL_MASK,
 		.ops = &wm8994_ldo1_ops,
 		.owner = THIS_MODULE,
 	},
@@ -194,6 +150,8 @@ static const struct regulator_desc wm8994_ldo_desc[] = {
 		.id = 2,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8994_LDO2_MAX_SELECTOR + 1,
+		.vsel_reg = WM8994_LDO_2,
+		.vsel_mask = WM8994_LDO2_VSEL_MASK,
 		.ops = &wm8994_ldo2_ops,
 		.owner = THIS_MODULE,
 	},
@@ -243,6 +201,7 @@ static __devinit int wm8994_ldo_probe(struct platform_device *pdev)
 	config.dev = &pdev->dev;
 	config.init_data = pdata->ldo[id].init_data;
 	config.driver_data = ldo;
+	config.regmap = wm8994->regmap;
 
 	ldo->regulator = regulator_register(&wm8994_ldo_desc[id], &config);
 	if (IS_ERR(ldo->regulator)) {
-- 
1.7.9.1

