Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab0LMPd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:33:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58754 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751441Ab0LMPd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:33:26 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Convert WM8994 to use get_voltage_sel()
Date: Mon, 13 Dec 2010 15:33:18 +0000
Message-Id: <1292254398-32626-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8994-regulator.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 1b162e6..594f88e 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -86,7 +86,7 @@ static int wm8994_ldo1_list_voltage(struct regulator_dev *rdev,
 	return (selector * 100000) + 2400000;
 }
 
-static int wm8994_ldo1_get_voltage(struct regulator_dev *rdev)
+static int wm8994_ldo1_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
 	int val;
@@ -95,9 +95,7 @@ static int wm8994_ldo1_get_voltage(struct regulator_dev *rdev)
 	if (val < 0)
 		return val;
 
-	val = (val & WM8994_LDO1_VSEL_MASK) >> WM8994_LDO1_VSEL_SHIFT;
-
-	return wm8994_ldo1_list_voltage(rdev, val);
+	return (val & WM8994_LDO1_VSEL_MASK) >> WM8994_LDO1_VSEL_SHIFT;
 }
 
 static int wm8994_ldo1_set_voltage(struct regulator_dev *rdev,
@@ -125,7 +123,7 @@ static struct regulator_ops wm8994_ldo1_ops = {
 	.enable_time = wm8994_ldo_enable_time,
 
 	.list_voltage = wm8994_ldo1_list_voltage,
-	.get_voltage = wm8994_ldo1_get_voltage,
+	.get_voltage_sel = wm8994_ldo1_get_voltage_sel,
 	.set_voltage = wm8994_ldo1_set_voltage,
 };
 
@@ -138,7 +136,7 @@ static int wm8994_ldo2_list_voltage(struct regulator_dev *rdev,
 	return (selector * 100000) + 900000;
 }
 
-static int wm8994_ldo2_get_voltage(struct regulator_dev *rdev)
+static int wm8994_ldo2_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
 	int val;
@@ -147,9 +145,7 @@ static int wm8994_ldo2_get_voltage(struct regulator_dev *rdev)
 	if (val < 0)
 		return val;
 
-	val = (val & WM8994_LDO2_VSEL_MASK) >> WM8994_LDO2_VSEL_SHIFT;
-
-	return wm8994_ldo2_list_voltage(rdev, val);
+	return (val & WM8994_LDO2_VSEL_MASK) >> WM8994_LDO2_VSEL_SHIFT;
 }
 
 static int wm8994_ldo2_set_voltage(struct regulator_dev *rdev,
@@ -177,7 +173,7 @@ static struct regulator_ops wm8994_ldo2_ops = {
 	.enable_time = wm8994_ldo_enable_time,
 
 	.list_voltage = wm8994_ldo2_list_voltage,
-	.get_voltage = wm8994_ldo2_get_voltage,
+	.get_voltage_sel = wm8994_ldo2_get_voltage_sel,
 	.set_voltage = wm8994_ldo2_set_voltage,
 };
 
-- 
1.7.1

