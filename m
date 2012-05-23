Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab2EWOlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:41:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49709 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2EWOlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:41:08 -0400
Message-ID: <1337784058.12699.1.camel@phoenix>
Subject: [PATCH] regulator: wm8994: Convert wm8994_ldo1_ops to
 regulator_[list|map]_voltage_linear
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 23 May 2012 22:40:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8994-regulator.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 9a99431..0e2028b 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -77,22 +77,14 @@ static int wm8994_ldo_enable_time(struct regulator_dev *rdev)
 	return 3000;
 }
 
-static int wm8994_ldo1_list_voltage(struct regulator_dev *rdev,
-				    unsigned int selector)
-{
-	if (selector > WM8994_LDO1_MAX_SELECTOR)
-		return -EINVAL;
-
-	return (selector * 100000) + 2400000;
-}
-
 static struct regulator_ops wm8994_ldo1_ops = {
 	.enable = wm8994_ldo_enable,
 	.disable = wm8994_ldo_disable,
 	.is_enabled = wm8994_ldo_is_enabled,
 	.enable_time = wm8994_ldo_enable_time,
 
-	.list_voltage = wm8994_ldo1_list_voltage,
+	.list_voltage = regulator_list_voltage_linear,
+	.map_voltage = regulator_map_voltage_linear,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 };
@@ -143,6 +135,8 @@ static const struct regulator_desc wm8994_ldo_desc[] = {
 		.vsel_reg = WM8994_LDO_1,
 		.vsel_mask = WM8994_LDO1_VSEL_MASK,
 		.ops = &wm8994_ldo1_ops,
+		.min_uV = 2400000,
+		.uV_step = 100000,
 		.owner = THIS_MODULE,
 	},
 	{
-- 
1.7.5.4



