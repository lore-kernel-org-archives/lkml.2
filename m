Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab2ENQPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:15:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38963 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab2ENQPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:15:16 -0400
Message-ID: <1337012111.13224.4.camel@phoenix>
Subject: [PATCH 4/4] regulator: max8649: Convert to
 regulator_set_voltage_sel_regmap and regulator_map_voltage_linear
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jonghwan Choi <jhbird.choi@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 15 May 2012 00:15:11 +0800
In-Reply-To: <1337011930.13224.1.camel@phoenix>
References: <1337011930.13224.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8649.c |   22 ++--------------------
 1 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 0cfd172..39fffb2 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -70,25 +70,6 @@ static inline int check_range(int min_uV, int max_uV)
 	return 0;
 }
 
-static int max8649_set_voltage(struct regulator_dev *rdev,
-			       int min_uV, int max_uV, unsigned *selector)
-{
-	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
-	unsigned char data, mask;
-
-	if (check_range(min_uV, max_uV)) {
-		dev_err(info->dev, "invalid voltage range (%d, %d) uV\n",
-			min_uV, max_uV);
-		return -EINVAL;
-	}
-	data = DIV_ROUND_UP(min_uV - MAX8649_DCDC_VMIN, MAX8649_DCDC_STEP);
-	mask = MAX8649_VOL_MASK;
-	*selector = data & mask;
-
-	return regmap_update_bits(info->regmap, rdev->desc->vsel_reg, mask,
-				  data);
-}
-
 /* EN_PD means pulldown on EN input */
 static int max8649_enable(struct regulator_dev *rdev)
 {
@@ -176,9 +157,10 @@ static unsigned int max8649_get_mode(struct regulator_dev *rdev)
 }
 
 static struct regulator_ops max8649_dcdc_ops = {
-	.set_voltage	= max8649_set_voltage,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.list_voltage	= regulator_list_voltage_linear,
+	.map_voltage	= regulator_map_voltage_linear,
 	.enable		= max8649_enable,
 	.disable	= max8649_disable,
 	.is_enabled	= max8649_is_enabled,
-- 
1.7.5.4



