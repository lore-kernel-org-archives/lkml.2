Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab1L2P4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 10:56:20 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48339 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab1L2P4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 10:56:18 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@opensource.wolfsonmicro.com
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 2/2] regulator: mc13892: Convert to devm_kzalloc()
Date: Thu, 29 Dec 2011 13:56:03 -0200
Message-Id: <1325174163-27955-2-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1325174163-27955-1-git-send-email-festevam@gmail.com>
References: <1325174163-27955-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert mc13892-regulator driver to use devm_kzalloc().

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/mc13892-regulator.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 023d17d..dd389dd 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -531,7 +531,7 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
 	int i, ret;
 	u32 val;
 
-	priv = kzalloc(sizeof(*priv) +
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv) +
 		pdata->num_regulators * sizeof(priv->regulators[0]),
 		GFP_KERNEL);
 	if (!priv)
@@ -592,7 +592,6 @@ err:
 
 err_free:
 	mc13xxx_unlock(mc13892);
-	kfree(priv);
 
 	return ret;
 }
@@ -609,7 +608,6 @@ static int __devexit mc13892_regulator_remove(struct platform_device *pdev)
 	for (i = 0; i < pdata->num_regulators; i++)
 		regulator_unregister(priv->regulators[i]);
 
-	kfree(priv);
 	return 0;
 }
 
-- 
1.7.1

