Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab2LFAYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 19:24:23 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:35133 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab2LFAYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 19:24:21 -0500
Message-ID: <1354753451.3144.1.camel@phoenix>
Subject: [PATCH] regulator: tps80031: Convert tps80031_ldo_ops to
 linear_min_sel and list_voltage_linear
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 08:24:11 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps80031-regulator.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/tps80031-regulator.c b/drivers/regulator/tps80031-regulator.c
index 50f89b0..b15d711 100644
--- a/drivers/regulator/tps80031-regulator.c
+++ b/drivers/regulator/tps80031-regulator.c
@@ -284,14 +284,6 @@ static int tps80031_ldo_get_voltage_sel(struct regulator_dev *rdev)
 	return vsel & rdev->desc->vsel_mask;
 }
 
-static int tps80031_ldo_list_voltage(struct regulator_dev *rdev, unsigned sel)
-{
-	if (sel == 0)
-		return 0;
-	else
-		return regulator_list_voltage_linear(rdev, sel - 1);
-}
-
 static int tps80031_vbus_is_enabled(struct regulator_dev *rdev)
 {
 	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
@@ -398,7 +390,7 @@ static struct regulator_ops tps80031_dcdc_ops = {
 };
 
 static struct regulator_ops tps80031_ldo_ops = {
-	.list_voltage		= tps80031_ldo_list_voltage,
+	.list_voltage		= regulator_list_voltage_linear,
 	.set_voltage_sel	= tps80031_ldo_set_voltage_sel,
 	.get_voltage_sel	= tps80031_ldo_get_voltage_sel,
 	.enable			= tps80031_reg_enable,
@@ -465,6 +457,7 @@ static struct regulator_ops tps80031_ext_reg_ops = {
 		.type = REGULATOR_VOLTAGE,			\
 		.min_uV = 1000000,				\
 		.uV_step = 100000,				\
+		.linear_min_sel = 1,				\
 		.n_voltages = 25,				\
 		.vsel_mask = LDO_VSEL_MASK,			\
 		.enable_time = 500,				\
-- 
1.7.9.5



