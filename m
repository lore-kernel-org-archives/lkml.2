Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab1L2P4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 10:56:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50666 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab1L2P4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 10:56:15 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@opensource.wolfsonmicro.com
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/2] regulator: mc13783: Convert to devm_kzalloc()
Date: Thu, 29 Dec 2011 13:56:02 -0200
Message-Id: <1325174163-27955-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert mc13783-regulator driver to use devm_kzalloc().

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/mc13783-regulator.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 8479082..04e1915 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -344,7 +344,7 @@ static int __devinit mc13783_regulator_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "%s id %d\n", __func__, pdev->id);
 
-	priv = kzalloc(sizeof(*priv) +
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv) +
 			pdata->num_regulators * sizeof(priv->regulators[0]),
 			GFP_KERNEL);
 	if (!priv)
@@ -374,8 +374,6 @@ err:
 	while (--i >= 0)
 		regulator_unregister(priv->regulators[i]);
 
-	kfree(priv);
-
 	return ret;
 }
 
@@ -391,7 +389,6 @@ static int __devexit mc13783_regulator_remove(struct platform_device *pdev)
 	for (i = 0; i < pdata->num_regulators; i++)
 		regulator_unregister(priv->regulators[i]);
 
-	kfree(priv);
 	return 0;
 }
 
-- 
1.7.1

