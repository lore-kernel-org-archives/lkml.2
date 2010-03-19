Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0CSPhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:37:00 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:47375 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab0CSPg5 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 19 Mar 2010 11:36:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es
Cc: chrisw@sous-sol.org, jeremy@goop.org, Ian.Campbell@eu.citrix.com,
       dwmw2@infradead.org, alex.williamson@hp.com,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/5] swiotlb: EXPORT_SYMBOL_GPL functions + variables that are defined in the header file.
Date: Fri, 19 Mar 2010 11:04:22 -0400
Message-Id: <1269011062-25915-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1269011062-25915-5-git-send-email-konrad.wilk@oracle.com>
References: <1269011062-25915-1-git-send-email-konrad.wilk@oracle.com>
 <1269011062-25915-2-git-send-email-konrad.wilk@oracle.com>
 <1269011062-25915-3-git-send-email-konrad.wilk@oracle.com>
 <1269011062-25915-4-git-send-email-konrad.wilk@oracle.com>
 <1269011062-25915-5-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BA39998.0069:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the functions and variables that are now declared in the swiotlb.h
header file visible by the linker.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index b3eef1c..c6bfa5d 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -57,19 +57,24 @@ int swiotlb_force;
  * API.
  */
 char *swiotlb_bk_start, *swiotlb_bk_end;
+EXPORT_SYMBOL_GPL(swiotlb_bk_start);
+EXPORT_SYMBOL_GPL(swiotlb_bk_end);
 
 /*
  * The number of IO TLB blocks (in groups of 64) betweeen swiotlb_bk_start and
  * swiotlb_bk_end.  This is command line adjustable via setup_io_tlb_npages.
  */
 unsigned long swiotlb_bk_nslabs;
+EXPORT_SYMBOL_GPL(swiotlb_bk_nslabs);
 
 /*
  * When the IOMMU overflows we return a fallback buffer. This sets the size.
  */
 unsigned long swiotlb_bk_overflow = 32*1024;
+EXPORT_SYMBOL_GPL(swiotlb_bk_overflow);
 
 void *swiotlb_bk_overflow_buffer;
+EXPORT_SYMBOL_GPL(swiotlb_bk_overflow_buffer);
 
 /*
  * This is a free list describing the number of free entries available from
@@ -312,6 +317,7 @@ int is_swiotlb_buffer(phys_addr_t paddr)
 	return paddr >= virt_to_phys(swiotlb_bk_start) &&
 		paddr < virt_to_phys(swiotlb_bk_end);
 }
+EXPORT_SYMBOL_GPL(is_swiotlb_buffer);
 
 /*
  * Bounce: copy the swiotlb buffer back to the original dma location
@@ -353,6 +359,7 @@ void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 			memcpy(phys_to_virt(phys), dma_addr, size);
 	}
 }
+EXPORT_SYMBOL_GPL(swiotlb_bounce);
 
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
@@ -459,6 +466,7 @@ found:
 
 	return dma_addr;
 }
+EXPORT_SYMBOL_GPL(swiotlb_bk_map_single);
 
 /*
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
@@ -504,6 +512,7 @@ swiotlb_bk_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 	}
 	spin_unlock_irqrestore(&swiotlb_bk_lock, flags);
 }
+EXPORT_SYMBOL_GPL(swiotlb_bk_unmap_single);
 
 void
 swiotlb_bk_sync_single(struct device *hwdev, char *dma_addr, size_t size,
@@ -531,6 +540,7 @@ swiotlb_bk_sync_single(struct device *hwdev, char *dma_addr, size_t size,
 		BUG();
 	}
 }
+EXPORT_SYMBOL_GPL(swiotlb_bk_sync_single);
 
 void *
 swiotlb_alloc_coherent(struct device *hwdev, size_t size,
@@ -622,6 +632,7 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
 	if (dir == DMA_TO_DEVICE)
 		panic("DMA: Random memory could be DMA read\n");
 }
+EXPORT_SYMBOL_GPL(swiotlb_full);
 
 /*
  * Map a single buffer of the indicated size for DMA in streaming mode.  The
-- 
1.6.2.5

