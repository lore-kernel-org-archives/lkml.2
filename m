Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab2IGGo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:44:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50017 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab2IGGox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:44:53 -0400
From: Inderpal Singh <inderpal.singh@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, vinod.koul@intel.com, patches@linaro.org,
        boojin.kim@samsung.com, jassisinghbrar@gmail.com,
        Inderpal Singh <inderpal.singh@linaro.org>
Subject: [PATCH 1/2] DMA: PL330: Remove controller clock enable/disable
Date: Fri,  7 Sep 2012 12:14:47 +0530
Message-Id: <1347000288-20441-2-git-send-email-inderpal.singh@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347000288-20441-1-git-send-email-inderpal.singh@linaro.org>
References: <1347000288-20441-1-git-send-email-inderpal.singh@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The controller clock is being enabled/disabled in AMBA bus
infrastructre in probe/remove functions. Hence, its not required
at driver level probe/remove.

Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
---
 drivers/dma/pl330.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index e4feba6..f70e783 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2896,11 +2896,6 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 
 	amba_set_drvdata(adev, pdmac);
 
-#ifndef CONFIG_PM_RUNTIME
-	/* enable dma clk */
-	clk_enable(pdmac->clk);
-#endif
-
 	irq = adev->irq[0];
 	ret = request_irq(irq, pl330_irq_handler, 0,
 			dev_name(&adev->dev), pi);
@@ -2987,9 +2982,6 @@ probe_err5:
 probe_err4:
 	free_irq(irq, pi);
 probe_err3:
-#ifndef CONFIG_PM_RUNTIME
-	clk_disable(pdmac->clk);
-#endif
 	clk_put(pdmac->clk);
 probe_err2:
 	iounmap(pi->base);
@@ -3037,10 +3029,6 @@ static int __devexit pl330_remove(struct amba_device *adev)
 	res = &adev->res;
 	release_mem_region(res->start, resource_size(res));
 
-#ifndef CONFIG_PM_RUNTIME
-	clk_disable(pdmac->clk);
-#endif
-
 	kfree(pdmac);
 
 	return 0;
-- 
1.7.9.5

