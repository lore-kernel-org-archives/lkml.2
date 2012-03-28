Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab2C1Lqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:46:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59036 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab2C1Lqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:46:45 -0400
Message-ID: <1332935199.2438.1.camel@phoenix>
Subject: [PATCH 2/2] regulator: Convert tps6524x to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Cyril Chemparathy <cyril@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 28 Mar 2012 19:46:39 +0800
In-Reply-To: <1332935143.2438.0.camel@phoenix>
References: <1332935143.2438.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6524x-regulator.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 3a4a1d5..2a828a0 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -472,7 +472,7 @@ static int set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
 	return write_field(hw, &info->voltage, selector);
 }
 
-static int get_voltage(struct regulator_dev *rdev)
+static int get_voltage_sel(struct regulator_dev *rdev)
 {
 	const struct supply_info *info;
 	struct tps6524x *hw;
@@ -490,7 +490,7 @@ static int get_voltage(struct regulator_dev *rdev)
 	if (WARN_ON(ret >= info->n_voltages))
 		return -EIO;
 
-	return info->voltages[ret];
+	return ret;
 }
 
 static int set_current_limit(struct regulator_dev *rdev, int min_uA,
@@ -575,7 +575,7 @@ static struct regulator_ops regulator_ops = {
 	.is_enabled		= is_supply_enabled,
 	.enable			= enable_supply,
 	.disable		= disable_supply,
-	.get_voltage		= get_voltage,
+	.get_voltage_sel	= get_voltage_sel,
 	.set_voltage_sel	= set_voltage_sel,
 	.list_voltage		= list_voltage,
 	.set_current_limit	= set_current_limit,
-- 
1.7.5.4



