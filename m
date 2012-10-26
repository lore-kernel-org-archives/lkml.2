Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab2JZOfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:35:40 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:59604 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294Ab2JZOfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:35:38 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: [PATCH] dmaengine: use for_each_set_bit
Date: Fri, 26 Oct 2012 23:35:15 +0900
Message-Id: <1351262115-2737-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_set_bit() to implement for_each_dma_cap_mask() and
remove unused first_dma_cap() and next_dma_cap().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
---
 include/linux/dmaengine.h | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index d3201e4..6402b18 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -849,20 +849,6 @@ static inline bool async_tx_test_ack(struct dma_async_tx_descriptor *tx)
 	return (tx->flags & DMA_CTRL_ACK) == DMA_CTRL_ACK;
 }
 
-#define first_dma_cap(mask) __first_dma_cap(&(mask))
-static inline int __first_dma_cap(const dma_cap_mask_t *srcp)
-{
-	return min_t(int, DMA_TX_TYPE_END,
-		find_first_bit(srcp->bits, DMA_TX_TYPE_END));
-}
-
-#define next_dma_cap(n, mask) __next_dma_cap((n), &(mask))
-static inline int __next_dma_cap(int n, const dma_cap_mask_t *srcp)
-{
-	return min_t(int, DMA_TX_TYPE_END,
-		find_next_bit(srcp->bits, DMA_TX_TYPE_END, n+1));
-}
-
 #define dma_cap_set(tx, mask) __dma_cap_set((tx), &(mask))
 static inline void
 __dma_cap_set(enum dma_transaction_type tx_type, dma_cap_mask_t *dstp)
@@ -891,9 +877,7 @@ __dma_has_cap(enum dma_transaction_type tx_type, dma_cap_mask_t *srcp)
 }
 
 #define for_each_dma_cap_mask(cap, mask) \
-	for ((cap) = first_dma_cap(mask);	\
-		(cap) < DMA_TX_TYPE_END;	\
-		(cap) = next_dma_cap((cap), (mask)))
+	for_each_set_bit(cap, mask.bits, DMA_TX_TYPE_END)
 
 /**
  * dma_async_issue_pending - flush pending transactions to HW
-- 
1.7.11.7

