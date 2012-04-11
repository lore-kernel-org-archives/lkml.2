Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045Ab2DKDGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 23:06:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34117 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab2DKDGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 23:06:11 -0400
Message-ID: <1334113557.7919.2.camel@phoenix>
Subject: [PATCH 1/2] regulator: twl-regulator: Implement enable_time callback
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 11 Apr 2012 11:05:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let regulator core do the necessary delay for us.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/twl-regulator.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 68d9a7b..d9ba4c4 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -205,8 +205,6 @@ static int twl4030reg_enable(struct regulator_dev *rdev)
 
 	ret = twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_GRP, grp);
 
-	udelay(info->delay);
-
 	return ret;
 }
 
@@ -224,10 +222,21 @@ static int twl6030reg_enable(struct regulator_dev *rdev)
 	ret = twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_STATE,
 			grp << TWL6030_CFG_STATE_GRP_SHIFT |
 			TWL6030_CFG_STATE_ON);
+	return ret;
+}
 
-	udelay(info->delay);
+static int twl4030reg_enable_time(struct regulator_dev *rdev)
+{
+	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 
-	return ret;
+	return info->delay;
+}
+
+static int twl6030reg_enable_time(struct regulator_dev *rdev)
+{
+	struct twlreg_info	*info = rdev_get_drvdata(rdev);
+
+	return info->delay;
 }
 
 static int twl4030reg_disable(struct regulator_dev *rdev)
@@ -503,6 +512,7 @@ static struct regulator_ops twl4030ldo_ops = {
 	.enable		= twl4030reg_enable,
 	.disable	= twl4030reg_disable,
 	.is_enabled	= twl4030reg_is_enabled,
+	.enable_time	= twl4030reg_enable_time,
 
 	.set_mode	= twl4030reg_set_mode,
 
@@ -623,6 +633,7 @@ static struct regulator_ops twl6030ldo_ops = {
 	.enable		= twl6030reg_enable,
 	.disable	= twl6030reg_disable,
 	.is_enabled	= twl6030reg_is_enabled,
+	.enable_time	= twl6030reg_enable_time,
 
 	.set_mode	= twl6030reg_set_mode,
 
@@ -656,6 +667,7 @@ static struct regulator_ops twl4030fixed_ops = {
 	.enable		= twl4030reg_enable,
 	.disable	= twl4030reg_disable,
 	.is_enabled	= twl4030reg_is_enabled,
+	.enable_time	= twl4030reg_enable_time,
 
 	.set_mode	= twl4030reg_set_mode,
 
@@ -670,6 +682,7 @@ static struct regulator_ops twl6030fixed_ops = {
 	.enable		= twl6030reg_enable,
 	.disable	= twl6030reg_disable,
 	.is_enabled	= twl6030reg_is_enabled,
+	.enable_time	= twl6030reg_enable_time,
 
 	.set_mode	= twl6030reg_set_mode,
 
@@ -680,6 +693,7 @@ static struct regulator_ops twl6030_fixed_resource = {
 	.enable		= twl6030reg_enable,
 	.disable	= twl6030reg_disable,
 	.is_enabled	= twl6030reg_is_enabled,
+	.enable_time	= twl6030reg_enable_time,
 	.get_status	= twl6030reg_get_status,
 };
 
@@ -876,6 +890,7 @@ static struct regulator_ops twlsmps_ops = {
 	.enable			= twl6030reg_enable,
 	.disable		= twl6030reg_disable,
 	.is_enabled		= twl6030reg_is_enabled,
+	.enable_time		= twl6030reg_enable_time,
 
 	.set_mode		= twl6030reg_set_mode,
 
-- 
1.7.5.4



