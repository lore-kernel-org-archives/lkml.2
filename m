Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2LZI2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 03:28:48 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38428 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2LZI2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 03:28:46 -0500
Message-ID: <1356510519.16892.3.camel@phoenix>
Subject: [PATCH 1/2] regulator: max8997: Remove set_voltage_time_sel setting
 for max8997_ldo_ops
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Dec 2012 16:28:39 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max8997_set_voltage_ldobuck_time_sel() returns 0 for all LDOs.
Thus remove set_voltage_time_sel setting for max8997_ldo_ops.

max8997_set_voltage_ldobuck_time_sel() is only used for max8997_buck_ops now,
rename it to max8997_set_voltage_buck_time_sel().

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max8997.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index df0eafb..57e8907 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -523,7 +523,7 @@ static int max8997_set_voltage_ldobuck(struct regulator_dev *rdev,
 	return ret;
 }
 
-static int max8997_set_voltage_ldobuck_time_sel(struct regulator_dev *rdev,
+static int max8997_set_voltage_buck_time_sel(struct regulator_dev *rdev,
 						unsigned int old_selector,
 						unsigned int new_selector)
 {
@@ -801,7 +801,6 @@ static struct regulator_ops max8997_ldo_ops = {
 	.disable		= max8997_reg_disable,
 	.get_voltage_sel	= max8997_get_voltage_sel,
 	.set_voltage		= max8997_set_voltage_ldobuck,
-	.set_voltage_time_sel	= max8997_set_voltage_ldobuck_time_sel,
 	.set_suspend_disable	= max8997_reg_disable_suspend,
 };
 
@@ -812,7 +811,7 @@ static struct regulator_ops max8997_buck_ops = {
 	.disable		= max8997_reg_disable,
 	.get_voltage_sel	= max8997_get_voltage_sel,
 	.set_voltage		= max8997_set_voltage_buck,
-	.set_voltage_time_sel	= max8997_set_voltage_ldobuck_time_sel,
+	.set_voltage_time_sel	= max8997_set_voltage_buck_time_sel,
 	.set_suspend_disable	= max8997_reg_disable_suspend,
 };
 
-- 
1.7.9.5



