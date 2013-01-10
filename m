Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab3AJIxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:53:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:8056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab3AJIxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:53:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,443,1355126400"; 
   d="scan'208";a="275270854"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: [PATCHv2 01/11] dmaengine: introduce is_slave_direction function
Date: Thu, 10 Jan 2013 10:52:56 +0200
Message-Id: <1357807986-4026-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357807986-4026-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1357807986-4026-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function helps to distinguish the slave type of transfer by checking the
direction parameter.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/linux/dmaengine.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 4ca9cf7..bfcdecb 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -621,6 +621,11 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
 			(unsigned long)config);
 }
 
+static inline bool is_slave_direction(enum dma_transfer_direction direction)
+{
+	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
+}
+
 static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
 	struct dma_chan *chan, dma_addr_t buf, size_t len,
 	enum dma_transfer_direction dir, unsigned long flags)
-- 
1.7.10.4

