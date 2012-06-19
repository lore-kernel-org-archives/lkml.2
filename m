Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab2FSB1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 21:27:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46236 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab2FSB1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 21:27:03 -0400
Message-ID: <1340069212.7937.1.camel@phoenix>
Subject: [PATCH] regulator: rc5t583: Use regulator_set_voltage_time_sel()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 19 Jun 2012 09:26:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/rc5t583-regulator.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index 332eae8..8bf4e8c 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -42,7 +42,6 @@ struct rc5t583_regulator_info {
 
 	/* Regulator specific turn-on delay  and voltage settling time*/
 	int			enable_uv_per_us;
-	int			change_uv_per_us;
 
 	/* Used by regulator core */
 	struct regulator_desc	desc;
@@ -66,17 +65,6 @@ static int rc5t583_regulator_enable_time(struct regulator_dev *rdev)
 	return DIV_ROUND_UP(curr_uV, reg->reg_info->enable_uv_per_us);
 }
 
-static int rc5t583_set_voltage_time_sel(struct regulator_dev *rdev,
-		unsigned int old_selector, unsigned int new_selector)
-{
-	struct rc5t583_regulator *reg = rdev_get_drvdata(rdev);
-
-	return DIV_ROUND_UP(abs(new_selector - old_selector) *
-			    rdev->desc->uV_step,
-			    reg->reg_info->change_uv_per_us);
-}
-
-
 static struct regulator_ops rc5t583_ops = {
 	.is_enabled		= regulator_is_enabled_regmap,
 	.enable			= regulator_enable_regmap,
@@ -86,7 +74,7 @@ static struct regulator_ops rc5t583_ops = {
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.list_voltage		= regulator_list_voltage_linear,
 	.map_voltage		= regulator_map_voltage_linear,
-	.set_voltage_time_sel	= rc5t583_set_voltage_time_sel,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 };
 
 #define RC5T583_REG(_id, _en_reg, _en_bit, _disc_reg, _disc_bit, \
@@ -96,7 +84,6 @@ static struct regulator_ops rc5t583_ops = {
 	.disc_bit	= _disc_bit,				\
 	.deepsleep_reg	= RC5T583_REG_##_id##DAC_DS,		\
 	.enable_uv_per_us = _enable_mv * 1000,			\
-	.change_uv_per_us = 40 * 1000,				\
 	.deepsleep_id	= RC5T583_DS_##_id,			\
 	.desc = {						\
 		.name = "rc5t583-regulator-"#_id,		\
@@ -111,6 +98,7 @@ static struct regulator_ops rc5t583_ops = {
 		.enable_mask = BIT(_en_bit),			\
 		.min_uV	= _min_mv * 1000,			\
 		.uV_step = _step_uV,				\
+		.ramp_delay = 40 * 1000,			\
 	},							\
 }
 
-- 
1.7.9.5



