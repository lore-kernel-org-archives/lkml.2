Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab2CXBih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 21:38:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41945 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab2CXBig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 21:38:36 -0400
Message-ID: <1332553110.14114.2.camel@phoenix>
Subject: [PATCH 2/4] regulator: Convert tps6586x to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Rapoport <mike@compulab.co.il>, Danny Huang <dahuang@nvidia.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sat, 24 Mar 2012 09:38:30 +0800
In-Reply-To: <1332553050.14114.1.camel@phoenix>
References: <1332553050.14114.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This also fixes a bug, LDO0 has minimal voltage 1.2V rather than 1.25V.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6586x-regulator.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index cfc1f16..af3559b 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -129,7 +129,7 @@ static int tps6586x_ldo_set_voltage(struct regulator_dev *rdev,
 					  selector);
 }
 
-static int tps6586x_ldo_get_voltage(struct regulator_dev *rdev)
+static int tps6586x_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct tps6586x_regulator *ri = rdev_get_drvdata(rdev);
 	struct device *parent = to_tps6586x_dev(rdev);
@@ -146,7 +146,7 @@ static int tps6586x_ldo_get_voltage(struct regulator_dev *rdev)
 	if (val >= ri->desc.n_voltages)
 		BUG();
 
-	return ri->voltages[val] * 1000;
+	return val;
 }
 
 static int tps6586x_dvm_set_voltage(struct regulator_dev *rdev,
@@ -198,7 +198,7 @@ static int tps6586x_regulator_is_enabled(struct regulator_dev *rdev)
 
 static struct regulator_ops tps6586x_regulator_ldo_ops = {
 	.list_voltage = tps6586x_ldo_list_voltage,
-	.get_voltage = tps6586x_ldo_get_voltage,
+	.get_voltage_sel = tps6586x_get_voltage_sel,
 	.set_voltage = tps6586x_ldo_set_voltage,
 
 	.is_enabled = tps6586x_regulator_is_enabled,
@@ -208,7 +208,7 @@ static struct regulator_ops tps6586x_regulator_ldo_ops = {
 
 static struct regulator_ops tps6586x_regulator_dvm_ops = {
 	.list_voltage = tps6586x_ldo_list_voltage,
-	.get_voltage = tps6586x_ldo_get_voltage,
+	.get_voltage_sel = tps6586x_get_voltage_sel,
 	.set_voltage = tps6586x_dvm_set_voltage,
 
 	.is_enabled = tps6586x_regulator_is_enabled,
-- 
1.7.5.4



