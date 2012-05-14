Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab2ENQOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:14:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40194 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab2ENQOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:14:11 -0400
Message-ID: <1337012045.13224.3.camel@phoenix>
Subject: [PATCH 3/4] regulator: max8649: Convert to
 regulator_list_voltage_linear()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jonghwan Choi <jhbird.choi@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 15 May 2012 00:14:05 +0800
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
 drivers/regulator/max8649.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 575cf48..0cfd172 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -70,11 +70,6 @@ static inline int check_range(int min_uV, int max_uV)
 	return 0;
 }
 
-static int max8649_list_voltage(struct regulator_dev *rdev, unsigned index)
-{
-	return (MAX8649_DCDC_VMIN + index * MAX8649_DCDC_STEP);
-}
-
 static int max8649_set_voltage(struct regulator_dev *rdev,
 			       int min_uV, int max_uV, unsigned *selector)
 {
@@ -135,7 +130,7 @@ static int max8649_enable_time(struct regulator_dev *rdev)
 	if (ret != 0)
 		return ret;
 	val &= MAX8649_VOL_MASK;
-	voltage = max8649_list_voltage(rdev, (unsigned char)val); /* uV */
+	voltage = regulator_list_voltage_linear(rdev, (unsigned char)val);
 
 	/* get rate */
 	ret = regmap_read(info->regmap, MAX8649_RAMP, &val);
@@ -183,7 +178,7 @@ static unsigned int max8649_get_mode(struct regulator_dev *rdev)
 static struct regulator_ops max8649_dcdc_ops = {
 	.set_voltage	= max8649_set_voltage,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
-	.list_voltage	= max8649_list_voltage,
+	.list_voltage	= regulator_list_voltage_linear,
 	.enable		= max8649_enable,
 	.disable	= max8649_disable,
 	.is_enabled	= max8649_is_enabled,
@@ -200,6 +195,8 @@ static struct regulator_desc dcdc_desc = {
 	.n_voltages	= 1 << 6,
 	.owner		= THIS_MODULE,
 	.vsel_mask	= MAX8649_VOL_MASK,
+	.min_uV		= MAX8649_DCDC_VMIN,
+	.uV_step	= MAX8649_DCDC_STEP,
 };
 
 static struct regmap_config max8649_regmap_config = {
-- 
1.7.5.4



