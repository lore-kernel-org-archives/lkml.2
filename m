Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab3AJIxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:53:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:3284 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab3AJIxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:53:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,443,1355126400"; 
   d="scan'208";a="270391927"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: [PATCHv2 06/11] dma: ste_dma40: reuse is_slave_direction helper
Date: Thu, 10 Jan 2013 10:53:01 +0200
Message-Id: <1357807986-4026-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357807986-4026-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1357807986-4026-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The is_slave_direction helps to check if the transfer type is slave.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/ste_dma40.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 23c5573..e5e60bb 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2337,7 +2337,7 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 							 unsigned long dma_flags,
 							 void *context)
 {
-	if (direction != DMA_DEV_TO_MEM && direction != DMA_MEM_TO_DEV)
+	if (!is_slave_direction(direction))
 		return NULL;
 
 	return d40_prep_sg(chan, sgl, sgl, sg_len, direction, dma_flags);
-- 
1.7.10.4

