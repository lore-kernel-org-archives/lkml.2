Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617Ab2EWO7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:59:36 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63709 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562Ab2EWO7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:59:33 -0400
Message-ID: <1337785166.12699.3.camel@phoenix>
Subject: [PATCH 1/2] regulator: wm8350: Convert wm8350_dcdc_ops to
 regulator_list_voltage_linear
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 23 May 2012 22:59:26 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8350-regulator.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 94e550d..6d143a918 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -433,14 +433,6 @@ static int wm8350_dcdc_get_voltage_sel(struct regulator_dev *rdev)
 	return wm8350_reg_read(wm8350, volt_reg) & WM8350_DC1_VSEL_MASK;
 }
 
-static int wm8350_dcdc_list_voltage(struct regulator_dev *rdev,
-				    unsigned selector)
-{
-	if (selector > WM8350_DCDC_MAX_VSEL)
-		return -EINVAL;
-	return wm8350_dcdc_val_to_mvolts(selector) * 1000;
-}
-
 static int wm8350_dcdc_set_suspend_voltage(struct regulator_dev *rdev, int uV)
 {
 	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
@@ -1226,7 +1218,7 @@ static int wm8350_ldo_is_enabled(struct regulator_dev *rdev)
 static struct regulator_ops wm8350_dcdc_ops = {
 	.set_voltage = wm8350_dcdc_set_voltage,
 	.get_voltage_sel = wm8350_dcdc_get_voltage_sel,
-	.list_voltage = wm8350_dcdc_list_voltage,
+	.list_voltage = regulator_list_voltage_linear,
 	.enable = wm8350_dcdc_enable,
 	.disable = wm8350_dcdc_disable,
 	.get_mode = wm8350_dcdc_get_mode,
@@ -1277,6 +1269,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_DC1,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
+		.min_uV = 850000,
+		.uV_step = 25000,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1294,6 +1288,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_DC3,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
+		.min_uV = 850000,
+		.uV_step = 25000,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1303,6 +1299,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_DC4,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
+		.min_uV = 850000,
+		.uV_step = 25000,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1320,6 +1318,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_DC6,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
+		.min_uV = 850000,
+		.uV_step = 25000,
 		.owner = THIS_MODULE,
 	},
 	{
-- 
1.7.5.4



