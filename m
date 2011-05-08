Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab1EHXbG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 19:31:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34100 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754068Ab1EHXa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 19:30:58 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Convert WM8400 to get_voltage_sel()
Date: Sun,  8 May 2011 22:19:09 +0100
Message-Id: <1304889549-15490-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8400-regulator.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index b42d01c..0f12c70 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -55,7 +55,7 @@ static int wm8400_ldo_list_voltage(struct regulator_dev *dev,
 		return 1600000 + ((selector - 14) * 100000);
 }
 
-static int wm8400_ldo_get_voltage(struct regulator_dev *dev)
+static int wm8400_ldo_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
 	u16 val;
@@ -63,7 +63,7 @@ static int wm8400_ldo_get_voltage(struct regulator_dev *dev)
 	val = wm8400_reg_read(wm8400, WM8400_LDO1_CONTROL + rdev_get_id(dev));
 	val &= WM8400_LDO1_VSEL_MASK;
 
-	return wm8400_ldo_list_voltage(dev, val);
+	return val;
 }
 
 static int wm8400_ldo_set_voltage(struct regulator_dev *dev,
@@ -104,7 +104,7 @@ static struct regulator_ops wm8400_ldo_ops = {
 	.enable = wm8400_ldo_enable,
 	.disable = wm8400_ldo_disable,
 	.list_voltage = wm8400_ldo_list_voltage,
-	.get_voltage = wm8400_ldo_get_voltage,
+	.get_voltage_sel = wm8400_ldo_get_voltage_sel,
 	.set_voltage = wm8400_ldo_set_voltage,
 };
 
@@ -145,7 +145,7 @@ static int wm8400_dcdc_list_voltage(struct regulator_dev *dev,
 	return 850000 + (selector * 25000);
 }
 
-static int wm8400_dcdc_get_voltage(struct regulator_dev *dev)
+static int wm8400_dcdc_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
 	u16 val;
@@ -154,7 +154,7 @@ static int wm8400_dcdc_get_voltage(struct regulator_dev *dev)
 	val = wm8400_reg_read(wm8400, WM8400_DCDC1_CONTROL_1 + offset);
 	val &= WM8400_DC1_VSEL_MASK;
 
-	return 850000 + (25000 * val);
+	return val;
 }
 
 static int wm8400_dcdc_set_voltage(struct regulator_dev *dev,
@@ -261,7 +261,7 @@ static struct regulator_ops wm8400_dcdc_ops = {
 	.enable = wm8400_dcdc_enable,
 	.disable = wm8400_dcdc_disable,
 	.list_voltage = wm8400_dcdc_list_voltage,
-	.get_voltage = wm8400_dcdc_get_voltage,
+	.get_voltage_sel = wm8400_dcdc_get_voltage_sel,
 	.set_voltage = wm8400_dcdc_set_voltage,
 	.get_mode = wm8400_dcdc_get_mode,
 	.set_mode = wm8400_dcdc_set_mode,
-- 
1.7.4.1

