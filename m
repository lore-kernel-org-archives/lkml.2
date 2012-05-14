Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab2ENCz4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:55:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56356 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab2ENCzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:55:55 -0400
Message-ID: <1336964150.24732.8.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: rc5t583: Convert to
 regulator_set_voltage_sel_regmap and regulator_map_voltage_linear
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 14 May 2012 10:55:50 +0800
In-Reply-To: <1336964086.24732.7.camel@phoenix>
References: <1336964086.24732.7.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/rc5t583-regulator.c |   29 ++---------------------------
 1 files changed, 2 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index f5d8537..987fa34 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -60,32 +60,6 @@ struct rc5t583_regulator {
 	struct regulator_dev	*rdev;
 };
 
-static int rc5t583_set_voltage(struct regulator_dev *rdev,
-			       int min_uV, int max_uV, unsigned *selector)
-{
-	struct rc5t583_regulator *reg = rdev_get_drvdata(rdev);
-	int sel, ret;
-
-	if (min_uV < rdev->desc->min_uV)
-		min_uV = rdev->desc->min_uV;
-
-	sel = DIV_ROUND_UP(min_uV - rdev->desc->min_uV, rdev->desc->uV_step);
-
-	if (sel >= rdev->desc->n_voltages) {
-		dev_err(&rdev->dev, "Invalid selector 0x%02x\n", sel);
-		return -EINVAL;
-	}
-
-	*selector = sel;
-
-	ret = rc5t583_update(reg->mfd->dev, rdev->desc->vsel_reg, sel,
-			     rdev->desc->vsel_mask);
-	if (ret < 0)
-		dev_err(&rdev->dev, "Error in update voltage register 0x%02x\n",
-			rdev->desc->vsel_reg);
-	return ret;
-}
-
 static int rc5t583_regulator_enable_time(struct regulator_dev *rdev)
 {
 	struct rc5t583_regulator *reg = rdev_get_drvdata(rdev);
@@ -120,8 +94,9 @@ static struct regulator_ops rc5t583_ops = {
 	.disable		= regulator_disable_regmap,
 	.enable_time		= rc5t583_regulator_enable_time,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
-	.set_voltage		= rc5t583_set_voltage,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
 	.set_voltage_time_sel	= rc5t583_set_voltage_time_sel,
 };
 
-- 
1.7.5.4



