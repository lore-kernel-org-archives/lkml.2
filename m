Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab2FDCT0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 22:19:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60879 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab2FDCTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 22:19:25 -0400
Message-ID: <1338776358.5855.5.camel@phoenix>
Subject: [PATCH v2] regulator: max77686: Fix checkpatch warnings
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Mon, 04 Jun 2012 10:19:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below checkpatch warnings:

$ scripts/checkpatch.pl -f drivers/regulator/max77686.c
ERROR: return is not a function, parentheses are not required
+       return (DIV_ROUND_UP(rdev->desc->uV_step

WARNING: line over 80 characters
+       .ops            = &max77686_buck_dvs_ops,                               \

total: 1 errors, 1 warnings, 339 lines checked

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
v2: Also remove unnecessary parentheses in max77686_set_voltage_time_sel.

 drivers/regulator/max77686.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 4e9f4f3..b76a038 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -75,17 +75,18 @@ static int max77686_set_dvs_voltage_time_sel(struct regulator_dev *rdev,
 {
 	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
 	int ramp_rate[] = {13, 27, 55, 100};
-	return (DIV_ROUND_UP(rdev->desc->uV_step
-			* abs(new_selector - old_selector),
-			ramp_rate[max77686->ramp_delay]));
+
+	return DIV_ROUND_UP(rdev->desc->uV_step *
+			    abs(new_selector - old_selector),
+			    ramp_rate[max77686->ramp_delay]);
 }
 
 static int max77686_set_voltage_time_sel(struct regulator_dev *rdev,
 			unsigned int old_selector, unsigned int new_selector)
 {
 	/* Unconditionally 100 mV/us */
-	return (DIV_ROUND_UP(rdev->desc->uV_step
-		 * abs(new_selector - old_selector), 100));
+	return DIV_ROUND_UP(rdev->desc->uV_step *
+			    abs(new_selector - old_selector), 100);
 }
 
 static struct regulator_ops max77686_ops = {
@@ -171,7 +172,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 #define regulator_desc_buck_dvs(num)		{			\
 	.name		= "BUCK"#num,					\
 	.id		= MAX77686_BUCK##num,				\
-	.ops		= &max77686_buck_dvs_ops,				\
+	.ops		= &max77686_buck_dvs_ops,			\
 	.type		= REGULATOR_VOLTAGE,				\
 	.owner		= THIS_MODULE,					\
 	.min_uV		= MAX77686_DVS_MINUV,				\
-- 
1.7.9.5



