Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab2ENCgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:36:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37861 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab2ENCgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:36:46 -0400
Message-ID: <1336963000.24732.4.camel@phoenix>
Subject: [PATCH RFT 3/3] regulator: max8925: Convert to set_voltage_sel()
 and map_voltage()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 14 May 2012 10:36:40 +0800
In-Reply-To: <1336962890.24732.2.camel@phoenix>
References: <1336962890.24732.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8925-regulator.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 7dbae39..0ffcb55 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -52,22 +52,13 @@ static inline int check_range(struct max8925_regulator_info *info,
 	return 0;
 }
 
-static int max8925_set_voltage(struct regulator_dev *rdev,
-			       int min_uV, int max_uV, unsigned int *selector)
+static int max8925_set_voltage_sel(struct regulator_dev *rdev,
+				   unsigned int selector)
 {
 	struct max8925_regulator_info *info = rdev_get_drvdata(rdev);
-	unsigned char data, mask;
-
-	if (check_range(info, min_uV, max_uV)) {
-		dev_err(info->chip->dev, "invalid voltage range (%d, %d) uV\n",
-			min_uV, max_uV);
-		return -EINVAL;
-	}
-	data = DIV_ROUND_UP(min_uV - info->desc.min_uV, info->desc.uV_step);
-	*selector = data;
-	mask = rdev->desc->n_voltages - 1;
+	unsigned char mask = rdev->desc->n_voltages - 1;
 
-	return max8925_set_bits(info->i2c, info->vol_reg, mask, data);
+	return max8925_set_bits(info->i2c, info->vol_reg, mask, selector);
 }
 
 static int max8925_get_voltage_sel(struct regulator_dev *rdev)
@@ -152,8 +143,9 @@ static int max8925_set_dvm_disable(struct regulator_dev *rdev)
 }
 
 static struct regulator_ops max8925_regulator_sdv_ops = {
+	.map_voltage		= regulator_map_voltage_linear,
 	.list_voltage		= regulator_list_voltage_linear,
-	.set_voltage		= max8925_set_voltage,
+	.set_voltage_sel	= max8925_set_voltage_sel,
 	.get_voltage_sel	= max8925_get_voltage_sel,
 	.enable			= max8925_enable,
 	.disable		= max8925_disable,
@@ -164,8 +156,9 @@ static struct regulator_ops max8925_regulator_sdv_ops = {
 };
 
 static struct regulator_ops max8925_regulator_ldo_ops = {
+	.map_voltage		= regulator_map_voltage_linear,
 	.list_voltage		= regulator_list_voltage_linear,
-	.set_voltage		= max8925_set_voltage,
+	.set_voltage_sel	= max8925_set_voltage_sel,
 	.get_voltage_sel	= max8925_get_voltage_sel,
 	.enable			= max8925_enable,
 	.disable		= max8925_disable,
-- 
1.7.5.4



