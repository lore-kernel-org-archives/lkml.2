Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2FMB7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 21:59:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41065 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab2FMB7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 21:59:35 -0400
Message-ID: <1339552767.26190.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: wm831x-ldo: Convert to
 devm_request_threaded_irq
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 13 Jun 2012 09:59:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-ldo.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index f23d020e9..ebe5af4 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -322,9 +322,9 @@ static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
 	}
 
 	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
-	ret = request_threaded_irq(irq, NULL, wm831x_ldo_uv_irq,
-				   IRQF_TRIGGER_RISING, ldo->name,
-				   ldo);
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					wm831x_ldo_uv_irq, IRQF_TRIGGER_RISING,
+					ldo->name, ldo);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
@@ -346,9 +346,6 @@ static __devexit int wm831x_gp_ldo_remove(struct platform_device *pdev)
 	struct wm831x_ldo *ldo = platform_get_drvdata(pdev);
 
 	platform_set_drvdata(pdev, NULL);
-
-	free_irq(wm831x_irq(ldo->wm831x,
-			    platform_get_irq_byname(pdev, "UV")), ldo);
 	regulator_unregister(ldo->regulator);
 
 	return 0;
-- 
1.7.9.5



