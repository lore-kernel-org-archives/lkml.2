Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab3AIIRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:17:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:62601 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757373Ab3AIIRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:17:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,436,1355126400"; 
   d="scan'208";a="189184444"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: [resend][PATCH 03/16] dmaengine: introduce is_slave_xfer function
Date: Wed,  9 Jan 2013 10:17:02 +0200
Message-Id: <1357719435-29955-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <20130108155423.GJ19691@intel.com>
 <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
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
index 4ca9cf7..b196ea3 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -621,6 +621,11 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
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

