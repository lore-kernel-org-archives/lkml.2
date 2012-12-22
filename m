Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751007Ab2LVFbd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 00:31:33 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:59063 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab2LVFba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 00:31:30 -0500
Message-ID: <1356154279.21963.2.camel@phoenix>
Subject: [PATCH] regulator: twl: Convert twl[6030|4030]fixed_ops to
 regulator_list_voltage_linear
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Sat, 22 Dec 2012 13:31:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/twl-regulator.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 493c8c6..87c55d0 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -616,18 +616,8 @@ static struct regulator_ops twl6030ldo_ops = {
 
 /*----------------------------------------------------------------------*/
 
-/*
- * Fixed voltage LDOs don't have a VSEL field to update.
- */
-static int twlfixed_list_voltage(struct regulator_dev *rdev, unsigned index)
-{
-	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-
-	return info->min_mV * 1000;
-}
-
 static struct regulator_ops twl4030fixed_ops = {
-	.list_voltage	= twlfixed_list_voltage,
+	.list_voltage	= regulator_list_voltage_linear,
 
 	.enable		= twl4030reg_enable,
 	.disable	= twl4030reg_disable,
@@ -639,7 +629,7 @@ static struct regulator_ops twl4030fixed_ops = {
 };
 
 static struct regulator_ops twl6030fixed_ops = {
-	.list_voltage	= twlfixed_list_voltage,
+	.list_voltage	= regulator_list_voltage_linear,
 
 	.enable		= twl6030reg_enable,
 	.disable	= twl6030reg_disable,
@@ -945,6 +935,7 @@ static const struct twlreg_info TWLFIXED_INFO_##label = { \
 		.ops = &operations, \
 		.type = REGULATOR_VOLTAGE, \
 		.owner = THIS_MODULE, \
+		.min_uV = mVolts * 1000, \
 		.enable_time = turnon_delay, \
 		}, \
 	}
-- 
1.7.9.5



