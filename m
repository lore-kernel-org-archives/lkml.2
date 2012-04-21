Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2DUDDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 23:03:46 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:54976 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab2DUDDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 23:03:44 -0400
Message-ID: <1334977414.3764.1.camel@phoenix>
Subject: [PATCH] regulator: tps65912: Convert to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sat, 21 Apr 2012 11:03:34 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65912-regulator.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index af335dd..ab8d413 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -406,7 +406,7 @@ static int tps65912_list_voltage(struct regulator_dev *dev, unsigned selector)
 	return voltage;
 }
 
-static int tps65912_get_voltage(struct regulator_dev *dev)
+static int tps65912_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
 	struct tps65912 *mfd = pmic->mfd;
@@ -420,7 +420,7 @@ static int tps65912_get_voltage(struct regulator_dev *dev)
 	vsel = tps65912_reg_read(mfd, reg);
 	vsel &= 0x3F;
 
-	return tps65912_list_voltage(dev, vsel);
+	return vsel;
 }
 
 static int tps65912_set_voltage_sel(struct regulator_dev *dev,
@@ -445,7 +445,7 @@ static struct regulator_ops tps65912_ops_dcdc = {
 	.disable = tps65912_reg_disable,
 	.set_mode = tps65912_set_mode,
 	.get_mode = tps65912_get_mode,
-	.get_voltage = tps65912_get_voltage,
+	.get_voltage_sel = tps65912_get_voltage_sel,
 	.set_voltage_sel = tps65912_set_voltage_sel,
 	.list_voltage = tps65912_list_voltage,
 };
@@ -455,7 +455,7 @@ static struct regulator_ops tps65912_ops_ldo = {
 	.is_enabled = tps65912_reg_is_enabled,
 	.enable = tps65912_reg_enable,
 	.disable = tps65912_reg_disable,
-	.get_voltage = tps65912_get_voltage,
+	.get_voltage_sel = tps65912_get_voltage_sel,
 	.set_voltage_sel = tps65912_set_voltage_sel,
 	.list_voltage = tps65912_list_voltage,
 };
-- 
1.7.5.4



