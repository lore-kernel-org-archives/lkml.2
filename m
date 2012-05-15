Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869Ab2EONmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:42:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52295 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729Ab2EONmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:42:18 -0400
Message-ID: <1337089332.6238.2.camel@phoenix>
Subject: [PATCH RFT 2/3] regulator: max8660: Convert to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 15 May 2012 21:42:12 +0800
In-Reply-To: <1337089278.6238.1.camel@phoenix>
References: <1337089278.6238.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8660.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index 67ec6ad..93bcfc8 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -126,12 +126,13 @@ static int max8660_dcdc_disable(struct regulator_dev *rdev)
 	return max8660_write(max8660, MAX8660_OVER1, mask, 0);
 }
 
-static int max8660_dcdc_get(struct regulator_dev *rdev)
+static int max8660_dcdc_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
+
 	u8 reg = (rdev_get_id(rdev) == MAX8660_V3) ? MAX8660_ADTV2 : MAX8660_SDTV2;
 	u8 selector = max8660->shadow_regs[reg];
-	return MAX8660_DCDC_MIN_UV + selector * MAX8660_DCDC_STEP;
+	return selector;
 }
 
 static int max8660_dcdc_set(struct regulator_dev *rdev, int min_uV, int max_uV,
@@ -169,7 +170,7 @@ static struct regulator_ops max8660_dcdc_ops = {
 	.is_enabled = max8660_dcdc_is_enabled,
 	.list_voltage = regulator_list_voltage_linear,
 	.set_voltage = max8660_dcdc_set,
-	.get_voltage = max8660_dcdc_get,
+	.get_voltage_sel = max8660_dcdc_get_voltage_sel,
 };
 
 
@@ -177,12 +178,12 @@ static struct regulator_ops max8660_dcdc_ops = {
  * LDO5 functions
  */
 
-static int max8660_ldo5_get(struct regulator_dev *rdev)
+static int max8660_ldo5_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
-	u8 selector = max8660->shadow_regs[MAX8660_MDTV2];
 
-	return MAX8660_LDO5_MIN_UV + selector * MAX8660_LDO5_STEP;
+	u8 selector = max8660->shadow_regs[MAX8660_MDTV2];
+	return selector;
 }
 
 static int max8660_ldo5_set(struct regulator_dev *rdev, int min_uV, int max_uV,
@@ -217,7 +218,7 @@ static int max8660_ldo5_set(struct regulator_dev *rdev, int min_uV, int max_uV,
 static struct regulator_ops max8660_ldo5_ops = {
 	.list_voltage = regulator_list_voltage_linear,
 	.set_voltage = max8660_ldo5_set,
-	.get_voltage = max8660_ldo5_get,
+	.get_voltage_sel = max8660_ldo5_get_voltage_sel,
 };
 
 
@@ -247,13 +248,13 @@ static int max8660_ldo67_disable(struct regulator_dev *rdev)
 	return max8660_write(max8660, MAX8660_OVER2, mask, 0);
 }
 
-static int max8660_ldo67_get(struct regulator_dev *rdev)
+static int max8660_ldo67_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
+
 	u8 shift = (rdev_get_id(rdev) == MAX8660_V6) ? 0 : 4;
 	u8 selector = (max8660->shadow_regs[MAX8660_L12VCR] >> shift) & 0xf;
-
-	return MAX8660_LDO67_MIN_UV + selector * MAX8660_LDO67_STEP;
+	return selector;
 }
 
 static int max8660_ldo67_set(struct regulator_dev *rdev, int min_uV,
@@ -288,7 +289,7 @@ static struct regulator_ops max8660_ldo67_ops = {
 	.enable = max8660_ldo67_enable,
 	.disable = max8660_ldo67_disable,
 	.list_voltage = regulator_list_voltage_linear,
-	.get_voltage = max8660_ldo67_get,
+	.get_voltage_sel = max8660_ldo67_get_voltage_sel,
 	.set_voltage = max8660_ldo67_set,
 };
 
-- 
1.7.5.4



