Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab2FMM1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:27:24 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49157 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab2FMM1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:27:23 -0400
Message-ID: <1339590434.9672.1.camel@phoenix>
Subject: [PATCH RESEND 1/3] regulator: wm831x-dcdc: Convert wm831x_buckp_ops
 to regulator_list_voltage_linear
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 13 Jun 2012 20:27:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-dcdc.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 099da11..fbcff56 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -599,15 +599,6 @@ static struct platform_driver wm831x_buckv_driver = {
  * BUCKP specifics
  */
 
-static int wm831x_buckp_list_voltage(struct regulator_dev *rdev,
-				      unsigned selector)
-{
-	if (selector <= WM831X_BUCKP_MAX_SELECTOR)
-		return 850000 + (selector * 25000);
-	else
-		return -EINVAL;
-}
-
 static int wm831x_buckp_set_voltage_int(struct regulator_dev *rdev, int reg,
 					int min_uV, int max_uV, int *selector)
 {
@@ -620,7 +611,7 @@ static int wm831x_buckp_set_voltage_int(struct regulator_dev *rdev, int reg,
 	else
 		return -EINVAL;
 
-	if (wm831x_buckp_list_voltage(rdev, vsel) > max_uV)
+	if (regulator_list_voltage_linear(rdev, vsel) > max_uV)
 		return -EINVAL;
 
 	*selector = vsel;
@@ -652,7 +643,7 @@ static int wm831x_buckp_set_suspend_voltage(struct regulator_dev *rdev,
 static struct regulator_ops wm831x_buckp_ops = {
 	.set_voltage = wm831x_buckp_set_voltage,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
-	.list_voltage = wm831x_buckp_list_voltage,
+	.list_voltage = regulator_list_voltage_linear,
 	.set_suspend_voltage = wm831x_buckp_set_suspend_voltage,
 
 	.is_enabled = regulator_is_enabled_regmap,
@@ -715,6 +706,8 @@ static __devinit int wm831x_buckp_probe(struct platform_device *pdev)
 	dcdc->desc.vsel_mask = WM831X_DC3_ON_VSEL_MASK;
 	dcdc->desc.enable_reg = WM831X_DCDC_ENABLE;
 	dcdc->desc.enable_mask = 1 << id;
+	dcdc->desc.min_uV = 850000;
+	dcdc->desc.uV_step = 25000;
 
 	config.dev = pdev->dev.parent;
 	if (pdata)
-- 
1.7.9.5



