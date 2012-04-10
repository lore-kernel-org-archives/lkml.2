Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940Ab2DJOpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:45:12 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:45316 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758913Ab2DJOpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:45:10 -0400
Message-ID: <1334069101.18312.1.camel@phoenix>
Subject: [PATCH] regulator: Convert anatop to use a struct to pass in
 regulator runtime configuration
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Nancy Chen <Nancy.Chen@freescale.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 10 Apr 2012 22:45:01 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/anatop-regulator.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 81fd606..49b2112 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -122,6 +122,7 @@ static int __devinit anatop_regulator_probe(struct platform_device *pdev)
 	struct anatop_regulator *sreg;
 	struct regulator_init_data *initdata;
 	struct anatop *anatopmfd = dev_get_drvdata(pdev->dev.parent);
+	struct regulator_config config = { };
 	int ret = 0;
 
 	initdata = of_get_regulator_init_data(dev, np);
@@ -178,9 +179,13 @@ static int __devinit anatop_regulator_probe(struct platform_device *pdev)
 	rdesc->n_voltages = (sreg->max_voltage - sreg->min_voltage)
 		/ 25000 + 1;
 
+	config.dev = &pdev->dev;
+	config.init_data = initdata;
+	config.driver_data = sreg;
+	config.of_node = pdev->dev.of_node;
+
 	/* register regulator */
-	rdev = regulator_register(rdesc, dev,
-				  initdata, sreg, pdev->dev.of_node);
+	rdev = regulator_register(rdesc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(dev, "failed to register %s\n",
 			rdesc->name);
-- 
1.7.5.4



