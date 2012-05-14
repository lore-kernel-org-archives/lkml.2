Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab2ENDGv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 23:06:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53080 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab2ENDGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 23:06:50 -0400
Message-ID: <1336964804.24732.10.camel@phoenix>
Subject: [PATCH] regulator: anatop: Convert to
 regulator_list_voltage_linear()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Nancy Chen <Nancy.Chen@freescale.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 14 May 2012 11:06:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/anatop-regulator.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 49b2112..e433b36 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -96,21 +96,10 @@ static int anatop_get_voltage_sel(struct regulator_dev *reg)
 	return val - anatop_reg->min_bit_val;
 }
 
-static int anatop_list_voltage(struct regulator_dev *reg, unsigned selector)
-{
-	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
-	int uv;
-
-	uv = anatop_reg->min_voltage + selector * 25000;
-	dev_dbg(&reg->dev, "vddio = %d, selector = %u\n", uv, selector);
-
-	return uv;
-}
-
 static struct regulator_ops anatop_rops = {
 	.set_voltage     = anatop_set_voltage,
 	.get_voltage_sel = anatop_get_voltage_sel,
-	.list_voltage    = anatop_list_voltage,
+	.list_voltage    = regulator_list_voltage_linear,
 };
 
 static int __devinit anatop_regulator_probe(struct platform_device *pdev)
@@ -178,6 +167,8 @@ static int __devinit anatop_regulator_probe(struct platform_device *pdev)
 
 	rdesc->n_voltages = (sreg->max_voltage - sreg->min_voltage)
 		/ 25000 + 1;
+	rdesc->min_uV = sreg->min_voltage;
+	rdesc->uV_step = 25000;
 
 	config.dev = &pdev->dev;
 	config.init_data = initdata;
-- 
1.7.5.4



