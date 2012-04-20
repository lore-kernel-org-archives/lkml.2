Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2DTKeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 06:34:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63379 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab2DTKeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 06:34:01 -0400
Message-ID: <1334918032.11252.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: tps6507x: Convert to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 20 Apr 2012 18:33:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6507x-regulator.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 8e432004b..ef885ac 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -283,7 +283,7 @@ static int tps6507x_pmic_disable(struct regulator_dev *dev)
 					1 << shift);
 }
 
-static int tps6507x_pmic_get_voltage(struct regulator_dev *dev)
+static int tps6507x_pmic_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
 	int data, rid = rdev_get_id(dev);
@@ -325,7 +325,7 @@ static int tps6507x_pmic_get_voltage(struct regulator_dev *dev)
 		return data;
 
 	data &= mask;
-	return tps->info[rid]->table[data] * 1000;
+	return data;
 }
 
 static int tps6507x_pmic_set_voltage_sel(struct regulator_dev *dev,
@@ -395,7 +395,7 @@ static struct regulator_ops tps6507x_pmic_ops = {
 	.is_enabled = tps6507x_pmic_is_enabled,
 	.enable = tps6507x_pmic_enable,
 	.disable = tps6507x_pmic_disable,
-	.get_voltage = tps6507x_pmic_get_voltage,
+	.get_voltage_sel = tps6507x_pmic_get_voltage_sel,
 	.set_voltage_sel = tps6507x_pmic_set_voltage_sel,
 	.list_voltage = tps6507x_pmic_list_voltage,
 };
-- 
1.7.5.4



