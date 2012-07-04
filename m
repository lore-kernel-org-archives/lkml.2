Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab2GDCqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 22:46:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62109 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab2GDCqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 22:46:42 -0400
Message-ID: <1341369994.10587.10.camel@phoenix>
Subject: [PATCH RFT] regulator: twl: Set enable enable_time in regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 04 Jul 2012 10:46:34 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/twl-regulator.c |   31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index ca308cb..8f0bd56 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -43,9 +43,6 @@ struct twlreg_info {
 	u8			table_len;
 	const u16		*table;
 
-	/* regulator specific turn-on delay */
-	u16			delay;
-
 	/* State REMAP default configuration */
 	u8			remap;
 
@@ -223,20 +220,6 @@ static int twl6030reg_enable(struct regulator_dev *rdev)
 	return ret;
 }
 
-static int twl4030reg_enable_time(struct regulator_dev *rdev)
-{
-	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-
-	return info->delay;
-}
-
-static int twl6030reg_enable_time(struct regulator_dev *rdev)
-{
-	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-
-	return info->delay;
-}
-
 static int twl4030reg_disable(struct regulator_dev *rdev)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
@@ -508,7 +491,6 @@ static struct regulator_ops twl4030ldo_ops = {
 	.enable		= twl4030reg_enable,
 	.disable	= twl4030reg_disable,
 	.is_enabled	= twl4030reg_is_enabled,
-	.enable_time	= twl4030reg_enable_time,
 
 	.set_mode	= twl4030reg_set_mode,
 
@@ -622,7 +604,6 @@ static struct regulator_ops twl6030ldo_ops = {
 	.enable		= twl6030reg_enable,
 	.disable	= twl6030reg_disable,
 	.is_enabled	= twl6030reg_is_enabled,
-	.enable_time	= twl6030reg_enable_time,
 
 	.set_mode	= twl6030reg_set_mode,
 
@@ -656,7 +637,6 @@ static struct regulator_ops twl4030fixed_ops = {
 	.enable		= twl4030reg_enable,
 	.disable	= twl4030reg_disable,
 	.is_enabled	= twl4030reg_is_enabled,
-	.enable_time	= twl4030reg_enable_time,
 
 	.set_mode	= twl4030reg_set_mode,
 
@@ -671,7 +651,6 @@ static struct regulator_ops twl6030fixed_ops = {
 	.enable		= twl6030reg_enable,
 	.disable	= twl6030reg_disable,
 	.is_enabled	= twl6030reg_is_enabled,
-	.enable_time	= twl6030reg_enable_time,
 
 	.set_mode	= twl6030reg_set_mode,
 
@@ -682,7 +661,6 @@ static struct regulator_ops twl6030_fixed_resource = {
 	.enable		= twl6030reg_enable,
 	.disable	= twl6030reg_disable,
 	.is_enabled	= twl6030reg_is_enabled,
-	.enable_time	= twl6030reg_enable_time,
 	.get_status	= twl6030reg_get_status,
 };
 
@@ -879,7 +857,6 @@ static struct regulator_ops twlsmps_ops = {
 	.enable			= twl6030reg_enable,
 	.disable		= twl6030reg_disable,
 	.is_enabled		= twl6030reg_is_enabled,
-	.enable_time		= twl6030reg_enable_time,
 
 	.set_mode		= twl6030reg_set_mode,
 
@@ -902,7 +879,6 @@ static struct twlreg_info TWL4030_INFO_##label = { \
 	.id = num, \
 	.table_len = ARRAY_SIZE(label##_VSEL_table), \
 	.table = label##_VSEL_table, \
-	.delay = turnon_delay, \
 	.remap = remap_conf, \
 	.desc = { \
 		.name = #label, \
@@ -911,6 +887,7 @@ static struct twlreg_info TWL4030_INFO_##label = { \
 		.ops = &twl4030ldo_ops, \
 		.type = REGULATOR_VOLTAGE, \
 		.owner = THIS_MODULE, \
+		.enable_time = turnon_delay, \
 		}, \
 	}
 
@@ -918,7 +895,6 @@ static struct twlreg_info TWL4030_INFO_##label = { \
 static struct twlreg_info TWL4030_INFO_##label = { \
 	.base = offset, \
 	.id = num, \
-	.delay = turnon_delay, \
 	.remap = remap_conf, \
 	.desc = { \
 		.name = #label, \
@@ -926,6 +902,7 @@ static struct twlreg_info TWL4030_INFO_##label = { \
 		.ops = &twl4030smps_ops, \
 		.type = REGULATOR_VOLTAGE, \
 		.owner = THIS_MODULE, \
+		.enable_time = turnon_delay, \
 		}, \
 	}
 
@@ -980,7 +957,6 @@ static struct twlreg_info TWLFIXED_INFO_##label = { \
 	.base = offset, \
 	.id = num, \
 	.min_mV = mVolts, \
-	.delay = turnon_delay, \
 	.remap = remap_conf, \
 	.desc = { \
 		.name = #label, \
@@ -989,19 +965,20 @@ static struct twlreg_info TWLFIXED_INFO_##label = { \
 		.ops = &operations, \
 		.type = REGULATOR_VOLTAGE, \
 		.owner = THIS_MODULE, \
+		.enable_time = turnon_delay, \
 		}, \
 	}
 
 #define TWL6030_FIXED_RESOURCE(label, offset, turnon_delay) \
 static struct twlreg_info TWLRES_INFO_##label = { \
 	.base = offset, \
-	.delay = turnon_delay, \
 	.desc = { \
 		.name = #label, \
 		.id = TWL6030_REG_##label, \
 		.ops = &twl6030_fixed_resource, \
 		.type = REGULATOR_VOLTAGE, \
 		.owner = THIS_MODULE, \
+		.enable_time = turnon_delay, \
 		}, \
 	}
 
-- 
1.7.9.5



