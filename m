Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab2KPOBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:01:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:36657 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab2KPN7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 08:59:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,264,1352102400"; 
   d="scan'208";a="243282690"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6/6] dma: ste_dma40: reuse is_slave_xfer helper
Date: Fri, 16 Nov 2012 15:59:19 +0200
Message-Id: <1353074360-1903-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/ste_dma40.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 23c5573..9f4fdf4 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2337,7 +2337,7 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 							 unsigned long dma_flags,
 							 void *context)
 {
-	if (direction != DMA_DEV_TO_MEM && direction != DMA_MEM_TO_DEV)
+	if (!is_slave_xfer(direction))
 		return NULL;
 
 	return d40_prep_sg(chan, sgl, sgl, sg_len, direction, dma_flags);
-- 
1.7.10.4

