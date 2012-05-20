Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab2ETChk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:37:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61797 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab2ETChj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:37:39 -0400
Message-ID: <1337481453.7204.8.camel@phoenix>
Subject: [PATCH RFC/RFT 6/7] regulator: tps6105x: Use
 regulator_list_voltage_table()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Sun, 20 May 2012 10:37:33 +0800
In-Reply-To: <1337481021.7204.1.camel@phoenix>
References: <1337481021.7204.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6105x-regulator.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/tps6105x-regulator.c b/drivers/regulator/tps6105x-regulator.c
index d840d84..1378409 100644
--- a/drivers/regulator/tps6105x-regulator.c
+++ b/drivers/regulator/tps6105x-regulator.c
@@ -20,7 +20,7 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps6105x.h>
 
-static const int tps6105x_voltages[] = {
+static const unsigned int tps6105x_voltages[] = {
 	4500000,
 	5000000,
 	5250000,
@@ -105,22 +105,13 @@ static int tps6105x_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	return 0;
 }
 
-static int tps6105x_regulator_list_voltage(struct regulator_dev *rdev,
-					   unsigned selector)
-{
-	if (selector >= ARRAY_SIZE(tps6105x_voltages))
-		return -EINVAL;
-
-	return tps6105x_voltages[selector];
-}
-
 static struct regulator_ops tps6105x_regulator_ops = {
 	.enable		= tps6105x_regulator_enable,
 	.disable	= tps6105x_regulator_disable,
 	.is_enabled	= tps6105x_regulator_is_enabled,
 	.get_voltage_sel = tps6105x_regulator_get_voltage_sel,
 	.set_voltage_sel = tps6105x_regulator_set_voltage_sel,
-	.list_voltage	= tps6105x_regulator_list_voltage,
+	.list_voltage	= regulator_list_voltage_table,
 };
 
 static const struct regulator_desc tps6105x_regulator_desc = {
@@ -130,6 +121,7 @@ static const struct regulator_desc tps6105x_regulator_desc = {
 	.id		= 0,
 	.owner		= THIS_MODULE,
 	.n_voltages	= ARRAY_SIZE(tps6105x_voltages),
+	.volt_table	= tps6105x_voltages,
 };
 
 /*
-- 
1.7.5.4



