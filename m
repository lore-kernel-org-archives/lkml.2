Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab2CJR4s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 12:56:48 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59829 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab2CJR4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 12:56:46 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: kernel-janitors@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] drivers/ata/pata_mpc52xx.c: add missing kfree
Date: Sat, 10 Mar 2012 18:56:39 +0100
Message-Id: <1331402199-8000-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

There is no need to call the devm cleanup functions on failure of a probe
or remove function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/ata/pata_mpc52xx.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 00748ae..1f02008 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -806,17 +806,12 @@ mpc52xx_ata_probe(struct platform_device *op)
 	return 0;
 
  err:
-	devm_release_mem_region(&op->dev, res_mem.start, sizeof(*ata_regs));
 	if (ata_irq)
 		irq_dispose_mapping(ata_irq);
 	if (task_irq)
 		irq_dispose_mapping(task_irq);
 	if (dmatsk)
 		bcom_ata_release(dmatsk);
-	if (ata_regs)
-		devm_iounmap(&op->dev, ata_regs);
-	if (priv)
-		devm_kfree(&op->dev, priv);
 	return rv;
 }
 
@@ -835,12 +830,6 @@ mpc52xx_ata_remove(struct platform_device *op)
 	bcom_ata_release(priv->dmatsk);
 	irq_dispose_mapping(priv->ata_irq);
 
-	/* Clear up IO allocations */
-	devm_iounmap(&op->dev, priv->ata_regs);
-	devm_release_mem_region(&op->dev, priv->ata_regs_pa,
-				sizeof(*priv->ata_regs));
-	devm_kfree(&op->dev, priv);
-
 	return 0;
 }
 

