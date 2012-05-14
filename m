Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab2ENCe5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:34:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62585 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab2ENCe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:34:56 -0400
Message-ID: <1336962890.24732.2.camel@phoenix>
Subject: [PATCH RFT 1/3] regulator: max8925: Convert to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 14 May 2012 10:34:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8925-regulator.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index de30ea2..529ee41 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -78,7 +78,7 @@ static int max8925_set_voltage(struct regulator_dev *rdev,
 	return max8925_set_bits(info->i2c, info->vol_reg, mask, data);
 }
 
-static int max8925_get_voltage(struct regulator_dev *rdev)
+static int max8925_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct max8925_regulator_info *info = rdev_get_drvdata(rdev);
 	unsigned char data, mask;
@@ -90,7 +90,7 @@ static int max8925_get_voltage(struct regulator_dev *rdev)
 	mask = rdev->desc->n_voltages - 1;
 	data = ret & mask;
 
-	return max8925_list_voltage(rdev, data);
+	return data;
 }
 
 static int max8925_enable(struct regulator_dev *rdev)
@@ -162,7 +162,7 @@ static int max8925_set_dvm_disable(struct regulator_dev *rdev)
 static struct regulator_ops max8925_regulator_sdv_ops = {
 	.list_voltage		= max8925_list_voltage,
 	.set_voltage		= max8925_set_voltage,
-	.get_voltage		= max8925_get_voltage,
+	.get_voltage_sel	= max8925_get_voltage_sel,
 	.enable			= max8925_enable,
 	.disable		= max8925_disable,
 	.is_enabled		= max8925_is_enabled,
@@ -174,7 +174,7 @@ static struct regulator_ops max8925_regulator_sdv_ops = {
 static struct regulator_ops max8925_regulator_ldo_ops = {
 	.list_voltage		= max8925_list_voltage,
 	.set_voltage		= max8925_set_voltage,
-	.get_voltage		= max8925_get_voltage,
+	.get_voltage_sel	= max8925_get_voltage_sel,
 	.enable			= max8925_enable,
 	.disable		= max8925_disable,
 	.is_enabled		= max8925_is_enabled,
-- 
1.7.5.4



