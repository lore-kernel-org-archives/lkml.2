Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab2FMCA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 22:00:27 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54642 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab2FMCA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 22:00:26 -0400
Message-ID: <1339552821.26190.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: wm831x-isink: Convert to
 devm_request_threaded_irq
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 13 Jun 2012 10:00:21 +0800
In-Reply-To: <1339552767.26190.1.camel@phoenix>
References: <1339552767.26190.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-isink.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index 0d207c2..1d414d2 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -203,8 +203,9 @@ static __devinit int wm831x_isink_probe(struct platform_device *pdev)
 	}
 
 	irq = wm831x_irq(wm831x, platform_get_irq(pdev, 0));
-	ret = request_threaded_irq(irq, NULL, wm831x_isink_irq,
-				   IRQF_TRIGGER_RISING, isink->name, isink);
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					wm831x_isink_irq, IRQF_TRIGGER_RISING,
+					isink->name, isink);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request ISINK IRQ %d: %d\n",
 			irq, ret);
@@ -226,9 +227,6 @@ static __devexit int wm831x_isink_remove(struct platform_device *pdev)
 	struct wm831x_isink *isink = platform_get_drvdata(pdev);
 
 	platform_set_drvdata(pdev, NULL);
-
-	free_irq(wm831x_irq(isink->wm831x, platform_get_irq(pdev, 0)), isink);
-
 	regulator_unregister(isink->regulator);
 
 	return 0;
-- 
1.7.9.5



