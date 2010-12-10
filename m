Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab0LJR2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:28:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55349 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752665Ab0LJR2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:28:12 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] regulator: Convert WM831x drivers to use get_voltage_sel()
Date: Fri, 10 Dec 2010 17:28:08 +0000
Message-Id: <1292002088-9644-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292002088-9644-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1292002088-9644-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-dcdc.c |   14 +++++++-------
 drivers/regulator/wm831x-ldo.c  |   18 +++++++++---------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 71da6b2..8b0d2c4 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -377,14 +377,14 @@ static int wm831x_buckv_set_suspend_voltage(struct regulator_dev *rdev,
 	return wm831x_set_bits(wm831x, reg, WM831X_DC1_SLP_VSEL_MASK, vsel);
 }
 
-static int wm831x_buckv_get_voltage(struct regulator_dev *rdev)
+static int wm831x_buckv_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
 
 	if (dcdc->dvs_gpio && dcdc->dvs_gpio_state)
-		return wm831x_buckv_list_voltage(rdev, dcdc->dvs_vsel);
+		return dcdc->dvs_vsel;
 	else
-		return wm831x_buckv_list_voltage(rdev, dcdc->on_vsel);
+		return dcdc->on_vsel;
 }
 
 /* Current limit options */
@@ -426,7 +426,7 @@ static int wm831x_buckv_get_current_limit(struct regulator_dev *rdev)
 
 static struct regulator_ops wm831x_buckv_ops = {
 	.set_voltage = wm831x_buckv_set_voltage,
-	.get_voltage = wm831x_buckv_get_voltage,
+	.get_voltage_sel = wm831x_buckv_get_voltage_sel,
 	.list_voltage = wm831x_buckv_list_voltage,
 	.set_suspend_voltage = wm831x_buckv_set_suspend_voltage,
 	.set_current_limit = wm831x_buckv_set_current_limit,
@@ -678,7 +678,7 @@ static int wm831x_buckp_set_suspend_voltage(struct regulator_dev *rdev,
 	return wm831x_buckp_set_voltage_int(rdev, reg, uV, uV, &selector);
 }
 
-static int wm831x_buckp_get_voltage(struct regulator_dev *rdev)
+static int wm831x_buckp_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
 	struct wm831x *wm831x = dcdc->wm831x;
@@ -689,12 +689,12 @@ static int wm831x_buckp_get_voltage(struct regulator_dev *rdev)
 	if (val < 0)
 		return val;
 
-	return wm831x_buckp_list_voltage(rdev, val & WM831X_DC3_ON_VSEL_MASK);
+	return val & WM831X_DC3_ON_VSEL_MASK;
 }
 
 static struct regulator_ops wm831x_buckp_ops = {
 	.set_voltage = wm831x_buckp_set_voltage,
-	.get_voltage = wm831x_buckp_get_voltage,
+	.get_voltage_sel = wm831x_buckp_get_voltage_sel,
 	.list_voltage = wm831x_buckp_list_voltage,
 	.set_suspend_voltage = wm831x_buckp_set_suspend_voltage,
 
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 9594e71..c94fc5b 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -160,7 +160,7 @@ static int wm831x_gp_ldo_set_suspend_voltage(struct regulator_dev *rdev,
 	return wm831x_gp_ldo_set_voltage_int(rdev, reg, uV, uV, &selector);
 }
 
-static int wm831x_gp_ldo_get_voltage(struct regulator_dev *rdev)
+static int wm831x_gp_ldo_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
 	struct wm831x *wm831x = ldo->wm831x;
@@ -173,7 +173,7 @@ static int wm831x_gp_ldo_get_voltage(struct regulator_dev *rdev)
 
 	ret &= WM831X_LDO1_ON_VSEL_MASK;
 
-	return wm831x_gp_ldo_list_voltage(rdev, ret);
+	return ret;
 }
 
 static unsigned int wm831x_gp_ldo_get_mode(struct regulator_dev *rdev)
@@ -293,7 +293,7 @@ static unsigned int wm831x_gp_ldo_get_optimum_mode(struct regulator_dev *rdev,
 
 static struct regulator_ops wm831x_gp_ldo_ops = {
 	.list_voltage = wm831x_gp_ldo_list_voltage,
-	.get_voltage = wm831x_gp_ldo_get_voltage,
+	.get_voltage_sel = wm831x_gp_ldo_get_voltage_sel,
 	.set_voltage = wm831x_gp_ldo_set_voltage,
 	.set_suspend_voltage = wm831x_gp_ldo_set_suspend_voltage,
 	.get_mode = wm831x_gp_ldo_get_mode,
@@ -465,7 +465,7 @@ static int wm831x_aldo_set_suspend_voltage(struct regulator_dev *rdev,
 	return wm831x_aldo_set_voltage_int(rdev, reg, uV, uV, &selector);
 }
 
-static int wm831x_aldo_get_voltage(struct regulator_dev *rdev)
+static int wm831x_aldo_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
 	struct wm831x *wm831x = ldo->wm831x;
@@ -478,7 +478,7 @@ static int wm831x_aldo_get_voltage(struct regulator_dev *rdev)
 
 	ret &= WM831X_LDO7_ON_VSEL_MASK;
 
-	return wm831x_aldo_list_voltage(rdev, ret);
+	return ret;
 }
 
 static unsigned int wm831x_aldo_get_mode(struct regulator_dev *rdev)
@@ -559,7 +559,7 @@ static int wm831x_aldo_get_status(struct regulator_dev *rdev)
 
 static struct regulator_ops wm831x_aldo_ops = {
 	.list_voltage = wm831x_aldo_list_voltage,
-	.get_voltage = wm831x_aldo_get_voltage,
+	.get_voltage_sel = wm831x_aldo_get_voltage_sel,
 	.set_voltage = wm831x_aldo_set_voltage,
 	.set_suspend_voltage = wm831x_aldo_set_suspend_voltage,
 	.get_mode = wm831x_aldo_get_mode,
@@ -718,7 +718,7 @@ static int wm831x_alive_ldo_set_suspend_voltage(struct regulator_dev *rdev,
 	return wm831x_alive_ldo_set_voltage_int(rdev, reg, uV, uV, &selector);
 }
 
-static int wm831x_alive_ldo_get_voltage(struct regulator_dev *rdev)
+static int wm831x_alive_ldo_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
 	struct wm831x *wm831x = ldo->wm831x;
@@ -731,7 +731,7 @@ static int wm831x_alive_ldo_get_voltage(struct regulator_dev *rdev)
 
 	ret &= WM831X_LDO11_ON_VSEL_MASK;
 
-	return wm831x_alive_ldo_list_voltage(rdev, ret);
+	return ret;
 }
 
 static int wm831x_alive_ldo_get_status(struct regulator_dev *rdev)
@@ -753,7 +753,7 @@ static int wm831x_alive_ldo_get_status(struct regulator_dev *rdev)
 
 static struct regulator_ops wm831x_alive_ldo_ops = {
 	.list_voltage = wm831x_alive_ldo_list_voltage,
-	.get_voltage = wm831x_alive_ldo_get_voltage,
+	.get_voltage_sel = wm831x_alive_ldo_get_voltage_sel,
 	.set_voltage = wm831x_alive_ldo_set_voltage,
 	.set_suspend_voltage = wm831x_alive_ldo_set_suspend_voltage,
 	.get_status = wm831x_alive_ldo_get_status,
-- 
1.7.1

