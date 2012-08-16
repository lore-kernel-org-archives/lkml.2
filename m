Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab2HPQWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:22:39 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:49938 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab2HPQWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:22:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/6] xen/swiotlb: Remove functions not needed anymore.
Date: Thu, 16 Aug 2012 12:12:33 -0400
Message-Id: <1345133558-23341-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345133558-23341-1-git-send-email-konrad.wilk@oracle.com>
References: <1345133558-23341-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse warns us off:
drivers/xen/swiotlb-xen.c:506:1: warning: symbol 'xen_swiotlb_map_sg' was not declared. Should it be static?
drivers/xen/swiotlb-xen.c:534:1: warning: symbol 'xen_swiotlb_unmap_sg' was not declared. Should it be static?

and it looks like we do not need this function at all.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/swiotlb-xen.c |   16 ----------------
 include/xen/swiotlb-xen.h |    9 ---------
 2 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 1942a3e..09e25a6 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -502,14 +502,6 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 }
 EXPORT_SYMBOL_GPL(xen_swiotlb_map_sg_attrs);
 
-int
-xen_swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		   enum dma_data_direction dir)
-{
-	return xen_swiotlb_map_sg_attrs(hwdev, sgl, nelems, dir, NULL);
-}
-EXPORT_SYMBOL_GPL(xen_swiotlb_map_sg);
-
 /*
  * Unmap a set of streaming mode DMA translations.  Again, cpu read rules
  * concerning calls here are the same as for swiotlb_unmap_page() above.
@@ -530,14 +522,6 @@ xen_swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 }
 EXPORT_SYMBOL_GPL(xen_swiotlb_unmap_sg_attrs);
 
-void
-xen_swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		     enum dma_data_direction dir)
-{
-	return xen_swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, NULL);
-}
-EXPORT_SYMBOL_GPL(xen_swiotlb_unmap_sg);
-
 /*
  * Make physical memory consistent for a set of streaming mode DMA translations
  * after a transfer.
diff --git a/include/xen/swiotlb-xen.h b/include/xen/swiotlb-xen.h
index d38d984..d8cba6f 100644
--- a/include/xen/swiotlb-xen.h
+++ b/include/xen/swiotlb-xen.h
@@ -24,15 +24,6 @@ extern dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 extern void xen_swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
 				   size_t size, enum dma_data_direction dir,
 				   struct dma_attrs *attrs);
-/*
-extern int
-xen_swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg, int nents,
-		   enum dma_data_direction dir);
-
-extern void
-xen_swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
-		     enum dma_data_direction dir);
-*/
 extern int
 xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 			 int nelems, enum dma_data_direction dir,
-- 
1.7.7.6

