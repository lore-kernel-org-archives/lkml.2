Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0DGUcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 16:32:36 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:20775 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab0DGUcd (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 7 Apr 2010 16:32:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       albert_herranz@yahoo.es
Cc: linux@eikelenboom.it, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       jeremy@goop.org, dwmw2@infradead.org, alex.williamson@hp.com,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 6/6] swiotlb: EXPORT_SYMBOL_GPL functions + variables that are defined in the header file.
Date: Wed,  7 Apr 2010 16:29:30 -0400
Message-Id: <1270672170-31833-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1270672170-31833-6-git-send-email-konrad.wilk@oracle.com>
References: <1270672170-31833-1-git-send-email-konrad.wilk@oracle.com>
 <1270672170-31833-2-git-send-email-konrad.wilk@oracle.com>
 <1270672170-31833-3-git-send-email-konrad.wilk@oracle.com>
 <1270672170-31833-4-git-send-email-konrad.wilk@oracle.com>
 <1270672170-31833-5-git-send-email-konrad.wilk@oracle.com>
 <1270672170-31833-6-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BBCEB73.019A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the functions and variables that are now declared in the swiotlb.h
header file visible by the linker.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 5443ad5..48f1e94 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -58,12 +58,14 @@ int swiotlb_force;
  */
 char *swiotlb_tbl_start;
 static char *io_tlb_end;
+EXPORT_SYMBOL_GPL(swiotlb_tbl_start);
 
 /*
  * The number of IO TLB blocks (in groups of 64) betweeen swiotlb_tbl_start and
  * io_tlb_end.  This is command line adjustable via setup_io_tlb_npages.
  */
 unsigned long swiotlb_tbl_nslabs;
+EXPORT_SYMBOL_GPL(swiotlb_tbl_nslabs);
 
 /*
  * When the IOMMU overflows we return a fallback buffer. This sets the size.
@@ -313,6 +315,7 @@ int is_swiotlb_buffer(phys_addr_t paddr)
 	return paddr >= virt_to_phys(swiotlb_tbl_start) &&
 		paddr < virt_to_phys(io_tlb_end);
 }
+EXPORT_SYMBOL_GPL(is_swiotlb_buffer);
 
 /*
  * Bounce: copy the swiotlb buffer back to the original dma location
@@ -354,6 +357,7 @@ void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 			memcpy(phys_to_virt(phys), dma_addr, size);
 	}
 }
+EXPORT_SYMBOL_GPL(swiotlb_bounce);
 
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
@@ -461,6 +465,7 @@ found:
 
 	return dma_addr;
 }
+EXPORT_SYMBOL_GPL(swiotlb_tbl_map_single);
 
 /*
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
@@ -506,6 +511,7 @@ swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 	}
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
 }
+EXPORT_SYMBOL_GPL(swiotlb_tbl_unmap_single);
 
 void
 swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
@@ -534,6 +540,7 @@ swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
 		BUG();
 	}
 }
+EXPORT_SYMBOL_GPL(swiotlb_tbl_sync_single);
 
 void *
 swiotlb_alloc_coherent(struct device *hwdev, size_t size,
@@ -626,6 +633,7 @@ swiotlb_full(struct device *dev, size_t size, enum dma_data_direction dir,
 	if (dir == DMA_TO_DEVICE)
 		panic("DMA: Random memory could be DMA read\n");
 }
+EXPORT_SYMBOL_GPL(swiotlb_full);
 
 /*
  * Map a single buffer of the indicated size for DMA in streaming mode.  The
-- 
1.6.2.5

