Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab2KPPwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:52:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:59998 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab2KPPwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:52:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,265,1352102400"; 
   d="scan'208";a="248288471"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCHv2 6/6] dma: ste_dma40: reuse is_slave_xfer helper
Date: Fri, 16 Nov 2012 17:52:05 +0200
Message-Id: <1353081126-17995-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353081126-17995-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1353081126-17995-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The is_slave_xfer helps to check if the transfer type is slave.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
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

