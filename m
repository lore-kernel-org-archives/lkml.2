Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab2GIDXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 23:23:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49393 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2GIDXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 23:23:31 -0400
Message-ID: <1341804203.14367.2.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: twl: Convert twl6030ldo_ops to
 [get|set]_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 11:23:23 +0800
In-Reply-To: <1341625605.7754.1.camel@phoenix>
References: <1341625605.7754.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/twl-regulator.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index bb51dec..de99b78 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -560,37 +560,27 @@ static struct regulator_ops twl6030coresmps_ops = {
 };
 
 static int
-twl6030ldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
-		       unsigned *selector)
+twl6030ldo_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-	int			vsel;
 
-	if ((min_uV/1000 < info->min_mV) || (max_uV/1000 > info->max_mV))
-		return -EDOM;
-
-	vsel = DIV_ROUND_UP(min_uV - rdev->desc->min_uV, rdev->desc->uV_step);
-	*selector = vsel;
-
-	return twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_VOLTAGE, vsel);
+	return twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_VOLTAGE,
+			    selector);
 }
 
-static int twl6030ldo_get_voltage(struct regulator_dev *rdev)
+static int twl6030ldo_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 	int vsel = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_VOLTAGE);
 
-	if (vsel < 0)
-		return vsel;
-
-	return rdev->desc->min_uV + vsel * rdev->desc->uV_step;
+	return vsel;
 }
 
 static struct regulator_ops twl6030ldo_ops = {
 	.list_voltage	= regulator_list_voltage_linear,
 
-	.set_voltage	= twl6030ldo_set_voltage,
-	.get_voltage	= twl6030ldo_get_voltage,
+	.set_voltage_sel = twl6030ldo_set_voltage_sel,
+	.get_voltage_sel = twl6030ldo_get_voltage_sel,
 
 	.enable		= twl6030reg_enable,
 	.disable	= twl6030reg_disable,
-- 
1.7.9.5



