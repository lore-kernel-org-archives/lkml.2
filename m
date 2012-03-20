Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451Ab2CTCOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 22:14:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58331 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759438Ab2CTCOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 22:14:46 -0400
Message-ID: <1332209680.10843.3.camel@phoenix>
Subject: [PATCH RFT] regulator: Convert ab3100 to set_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 20 Mar 2012 10:14:40 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ab3100.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index 042271a..ed56c93 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -338,20 +338,12 @@ static int ab3100_get_best_voltage_index(struct regulator_dev *reg,
 	return bestindex;
 }
 
-static int ab3100_set_voltage_regulator(struct regulator_dev *reg,
-					int min_uV, int max_uV,
-					unsigned *selector)
+static int ab3100_set_voltage_regulator_sel(struct regulator_dev *reg,
+					    unsigned selector)
 {
 	struct ab3100_regulator *abreg = reg->reg_data;
 	u8 regval;
 	int err;
-	int bestindex;
-
-	bestindex = ab3100_get_best_voltage_index(reg, min_uV, max_uV);
-	if (bestindex < 0)
-		return bestindex;
-
-	*selector = bestindex;
 
 	err = abx500_get_register_interruptible(abreg->dev, 0,
 						abreg->regreg, &regval);
@@ -364,7 +356,7 @@ static int ab3100_set_voltage_regulator(struct regulator_dev *reg,
 
 	/* The highest three bits control the variable regulators */
 	regval &= ~0xE0;
-	regval |= (bestindex << 5);
+	regval |= (selector << 5);
 
 	err = abx500_set_register_interruptible(abreg->dev, 0,
 						abreg->regreg, regval);
@@ -464,7 +456,7 @@ static struct regulator_ops regulator_ops_variable = {
 	.disable     = ab3100_disable_regulator,
 	.is_enabled  = ab3100_is_enabled_regulator,
 	.get_voltage = ab3100_get_voltage_regulator,
-	.set_voltage = ab3100_set_voltage_regulator,
+	.set_voltage_sel = ab3100_set_voltage_regulator_sel,
 	.list_voltage = ab3100_list_voltage_regulator,
 	.enable_time = ab3100_enable_time_regulator,
 };
@@ -474,7 +466,7 @@ static struct regulator_ops regulator_ops_variable_sleepable = {
 	.disable     = ab3100_disable_regulator,
 	.is_enabled  = ab3100_is_enabled_regulator,
 	.get_voltage = ab3100_get_voltage_regulator,
-	.set_voltage = ab3100_set_voltage_regulator,
+	.set_voltage_sel = ab3100_set_voltage_regulator_sel,
 	.set_suspend_voltage = ab3100_set_suspend_voltage_regulator,
 	.list_voltage = ab3100_list_voltage_regulator,
 	.enable_time = ab3100_enable_time_regulator,
-- 
1.7.5.4



