Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1L2WFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 17:05:20 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42137 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab1L2WFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 17:05:16 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@opensource.wolfsonmicro.com
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2 2/2] regulator: mc13892: Convert to devm_kzalloc()
Date: Thu, 29 Dec 2011 20:05:00 -0200
Message-Id: <1325196300-3930-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1325174163-27955-2-git-send-email-festevam@gmail .com>
References: <1325174163-27955-2-git-send-email-festevam@gmail .com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert mc13892-regulator driver to use devm_kzalloc().

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v1:
- Rebased against latest linux-next

 drivers/regulator/mc13892-regulator.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 46bfa4a..e8cfc99 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -538,7 +538,7 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
 	if (num_regulators <= 0)
 		return -EINVAL;
 
-	priv = kzalloc(sizeof(*priv) +
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv) +
 		num_regulators * sizeof(priv->regulators[0]),
 		GFP_KERNEL);
 	if (!priv)
@@ -615,7 +615,6 @@ err:
 
 err_free:
 	mc13xxx_unlock(mc13892);
-	kfree(priv);
 
 	return ret;
 }
@@ -630,7 +629,6 @@ static int __devexit mc13892_regulator_remove(struct platform_device *pdev)
 	for (i = 0; i < priv->num_regulators; i++)
 		regulator_unregister(priv->regulators[i]);
 
-	kfree(priv);
 	return 0;
 }
 
-- 
1.7.1

