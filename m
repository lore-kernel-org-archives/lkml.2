Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab2KPN7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 08:59:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:20674 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab2KPN7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 08:59:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,264,1352102400"; 
   d="scan'208";a="169191719"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/6] dmaengine: introduce is_slave_xfer function
Date: Fri, 16 Nov 2012 15:59:14 +0200
Message-Id: <1353074360-1903-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function helps to distinguish the slave type of transfer by checking the
direction parameter.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 include/linux/dmaengine.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 6402b18..3e1a9026 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -618,6 +618,11 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
 			(unsigned long)config);
 }
 
+static inline bool is_slave_xfer(enum dma_transfer_direction direction)
+{
+	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
+}
+
 static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
 	struct dma_chan *chan, dma_addr_t buf, size_t len,
 	enum dma_transfer_direction dir, unsigned long flags)
-- 
1.7.10.4

