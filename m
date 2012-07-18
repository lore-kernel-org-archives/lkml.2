Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab2GRLei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:34:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:46885 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab2GRLef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:34:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="167900487"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] dmaengine: printk(KERN_ERR ...) -> pr_err
Date: Wed, 18 Jul 2012 14:34:10 +0300
Message-Id: <1342611251-16935-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dmaengine.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 26ac0f8..071bd73 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -262,7 +262,7 @@ enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie)
 	do {
 		status = dma_async_is_tx_complete(chan, cookie, NULL, NULL);
 		if (time_after_eq(jiffies, dma_sync_wait_timeout)) {
-			printk(KERN_ERR "dma_sync_wait_timeout!\n");
+			pr_err("dma_sync_wait_timeout!\n");
 			return DMA_ERROR;
 		}
 	} while (status == DMA_IN_PROGRESS);
-- 
1.7.10.4

