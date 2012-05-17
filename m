Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052Ab2EQAzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:55:53 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:35671 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab2EQAzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:55:51 -0400
Message-ID: <1337216145.5759.3.camel@phoenix>
Subject: [PATCH] regulator: max8925: Remove check_range function and max_uV
 from struct rc5t583_regulator_info
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 17 May 2012 08:55:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has been converted to use regulator_map_voltage_linear and
set_voltage_sel now. regulator_map_voltage_linear will check the the voltage
falls within specified range. The check_range() function and max_uV field are
not used now, remove them.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8925-regulator.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 0ffcb55..43dc97ec 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -38,20 +38,10 @@ struct max8925_regulator_info {
 	struct i2c_client	*i2c;
 	struct max8925_chip	*chip;
 
-	int	max_uV;
 	int	vol_reg;
 	int	enable_reg;
 };
 
-static inline int check_range(struct max8925_regulator_info *info,
-			      int min_uV, int max_uV)
-{
-	if (min_uV < info->desc.min_uV || min_uV > info->max_uV)
-		return -EINVAL;
-
-	return 0;
-}
-
 static int max8925_set_voltage_sel(struct regulator_dev *rdev,
 				   unsigned int selector)
 {
@@ -177,7 +167,6 @@ static struct regulator_ops max8925_regulator_ldo_ops = {
 		.min_uV = min * 1000,				\
 		.uV_step = step * 1000,				\
 	},							\
-	.max_uV		= max * 1000,				\
 	.vol_reg	= MAX8925_SDV##_id,			\
 	.enable_reg	= MAX8925_SDCTL##_id,			\
 }
@@ -194,7 +183,6 @@ static struct regulator_ops max8925_regulator_ldo_ops = {
 		.min_uV = min * 1000,				\
 		.uV_step = step * 1000,				\
 	},							\
-	.max_uV		= max * 1000,				\
 	.vol_reg	= MAX8925_LDOVOUT##_id,			\
 	.enable_reg	= MAX8925_LDOCTL##_id,			\
 }
-- 
1.7.5.4



