Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab2DQPtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:49:35 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38691 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab2DQPtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:49:33 -0400
Message-ID: <1334677768.14393.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: max8997: Remove empty set_suspend_enable
 callback implementation
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 17 Apr 2012 23:49:28 +0800
In-Reply-To: <1334677707.14393.2.camel@phoenix>
References: <1334677707.14393.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 8ac0e95 "regulator: core: Support setting suspend_[mode|voltage]
if set_suspend_[en|dis]able is NULL", now the regulator core can properly
handle the case set_suspend_enable callback is NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8997.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 0796ad8..f4ab2e3 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -766,11 +766,6 @@ static int max8997_set_voltage_safeout(struct regulator_dev *rdev,
 	return ret;
 }
 
-static int max8997_reg_enable_suspend(struct regulator_dev *rdev)
-{
-	return 0;
-}
-
 static int max8997_reg_disable_suspend(struct regulator_dev *rdev)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
@@ -806,7 +801,6 @@ static struct regulator_ops max8997_ldo_ops = {
 	.get_voltage_sel	= max8997_get_voltage_sel,
 	.set_voltage		= max8997_set_voltage_ldobuck,
 	.set_voltage_time_sel	= max8997_set_voltage_ldobuck_time_sel,
-	.set_suspend_enable	= max8997_reg_enable_suspend,
 	.set_suspend_disable	= max8997_reg_disable_suspend,
 };
 
@@ -818,7 +812,6 @@ static struct regulator_ops max8997_buck_ops = {
 	.get_voltage_sel	= max8997_get_voltage_sel,
 	.set_voltage		= max8997_set_voltage_buck,
 	.set_voltage_time_sel	= max8997_set_voltage_ldobuck_time_sel,
-	.set_suspend_enable	= max8997_reg_enable_suspend,
 	.set_suspend_disable	= max8997_reg_disable_suspend,
 };
 
@@ -827,7 +820,6 @@ static struct regulator_ops max8997_fixedvolt_ops = {
 	.is_enabled		= max8997_reg_is_enabled,
 	.enable			= max8997_reg_enable,
 	.disable		= max8997_reg_disable,
-	.set_suspend_enable	= max8997_reg_enable_suspend,
 	.set_suspend_disable	= max8997_reg_disable_suspend,
 };
 
@@ -838,7 +830,6 @@ static struct regulator_ops max8997_safeout_ops = {
 	.disable		= max8997_reg_disable,
 	.get_voltage_sel	= max8997_get_voltage_sel,
 	.set_voltage		= max8997_set_voltage_safeout,
-	.set_suspend_enable	= max8997_reg_enable_suspend,
 	.set_suspend_disable	= max8997_reg_disable_suspend,
 };
 
-- 
1.7.5.4



