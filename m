Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab0EKBNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 21:13:31 -0400
Received: from sh.osrg.net ([192.16.179.4]:44983 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab0EKBN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 21:13:28 -0400
Date: Tue, 11 May 2010 10:13:23 +0900
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mm] remove deprecated dma_sync_single and dma_sync_sg API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100511101308R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 11 May 2010 10:13:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.5, it had been commented, 'for backwards compatibility,
removed in 2.7.x'. Since 2.6.31, it have been marked as __deprecated.

I think that we can remove the API safely now.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/dma-mapping.h |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 2ea1494..89b7e1a 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -95,21 +95,6 @@ static inline int is_device_dma_capable(struct device *dev)
 #include <asm-generic/dma-mapping-broken.h>
 #endif
 
-/* for backwards compatibility, removed soon */
-static inline void __deprecated dma_sync_single(struct device *dev,
-						dma_addr_t addr, size_t size,
-						enum dma_data_direction dir)
-{
-	dma_sync_single_for_cpu(dev, addr, size, dir);
-}
-
-static inline void __deprecated dma_sync_sg(struct device *dev,
-					    struct scatterlist *sg, int nelems,
-					    enum dma_data_direction dir)
-{
-	dma_sync_sg_for_cpu(dev, sg, nelems, dir);
-}
-
 static inline u64 dma_get_mask(struct device *dev)
 {
 	if (dev && dev->dma_mask && *dev->dma_mask)
-- 
1.6.5

