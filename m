Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab2IYI6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:58:20 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53882 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab2IYI56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:57:58 -0400
From: Inderpal Singh <inderpal.singh@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jassisinghbrar@gmail.com, boojin.kim@samsung.com, vinod.koul@intel.com,
        patches@linaro.org, kgene.kim@samsung.com
Subject: [PATCH 3/3] DMA: PL330: Balance module remove function with probe
Date: Tue, 25 Sep 2012 14:27:36 +0530
Message-Id: <1348563456-30569-4-git-send-email-inderpal.singh@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348563456-30569-1-git-send-email-inderpal.singh@linaro.org>
References: <1348563456-30569-1-git-send-email-inderpal.singh@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since peripheral channel resources are not being allocated at probe,
no need to flush the channels and free the resources in remove function.

Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
---
 drivers/dma/pl330.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 04d83e6..6f06080 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -3012,16 +3012,10 @@ static int __devexit pl330_remove(struct amba_device *adev)
 
 	/* Idle the DMAC */
 	list_for_each_entry_safe(pch, _p, &pdmac->ddma.channels,
-			chan.device_node) {
-
+			chan.device_node)
 		/* Remove the channel */
 		list_del(&pch->chan.device_node);
 
-		/* Flush the channel */
-		pl330_control(&pch->chan, DMA_TERMINATE_ALL, 0);
-		pl330_free_chan_resources(&pch->chan);
-	}
-
 	while (!list_empty(&pdmac->desc_pool)) {
 		desc = list_entry(pdmac->desc_pool.next,
 				struct dma_pl330_desc, node);
-- 
1.7.9.5

