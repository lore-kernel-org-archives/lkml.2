Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab0D0M0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:26:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:37051 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab0D0M0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:26:13 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 5/6] swiotlb: remove unnecessary swiotlb_sync_single_range_*
Date: Tue, 27 Apr 2010 21:25:39 +0900
Message-Id: <1272371140-6085-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1272371140-6085-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1272371140-6085-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 27 Apr 2010 21:26:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swiotlb_sync_single_range_for_cpu and
swiotlb_sync_single_range_for_device are unnecessary because
swiotlb_sync_single_for_cpu and swiotlb_sync_single_for_device can be
used instead.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/swiotlb.h |   10 ----------
 lib/swiotlb.c           |   31 -------------------------------
 2 files changed, 0 insertions(+), 41 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index febedcf..81a4e21 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -73,16 +73,6 @@ extern void
 swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
 			   int nelems, enum dma_data_direction dir);
 
-extern void
-swiotlb_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
-				  unsigned long offset, size_t size,
-				  enum dma_data_direction dir);
-
-extern void
-swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
-				     unsigned long offset, size_t size,
-				     enum dma_data_direction dir);
-
 extern int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
 
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 5fddf72..a009055 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -757,37 +757,6 @@ swiotlb_sync_single_for_device(struct device *hwdev, dma_addr_t dev_addr,
 EXPORT_SYMBOL(swiotlb_sync_single_for_device);
 
 /*
- * Same as above, but for a sub-range of the mapping.
- */
-static void
-swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
-			  unsigned long offset, size_t size,
-			  int dir, int target)
-{
-	swiotlb_sync_single(hwdev, dev_addr + offset, size, dir, target);
-}
-
-void
-swiotlb_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
-				  unsigned long offset, size_t size,
-				  enum dma_data_direction dir)
-{
-	swiotlb_sync_single_range(hwdev, dev_addr, offset, size, dir,
-				  SYNC_FOR_CPU);
-}
-EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_cpu);
-
-void
-swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
-				     unsigned long offset, size_t size,
-				     enum dma_data_direction dir)
-{
-	swiotlb_sync_single_range(hwdev, dev_addr, offset, size, dir,
-				  SYNC_FOR_DEVICE);
-}
-EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_device);
-
-/*
  * Map a set of buffers described by scatterlist in streaming mode for DMA.
  * This is the scatter-gather version of the above swiotlb_map_page
  * interface.  Here the scatter gather list elements are each tagged with the
-- 
1.6.5

