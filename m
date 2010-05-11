Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0EKPkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:40:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57221 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab0EKPkR (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 11 May 2010 11:40:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Cc: albert_herranz@yahoo.es, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       jeremy@goop.org, dwmw2@infradead.org,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 6/6] swiotlb: EXPORT_SYMBOL_GPL functions + variables that are defined in the header file.
Date: Tue, 11 May 2010 11:39:13 -0400
Message-Id: <1273592353-23224-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273592353-23224-6-git-send-email-konrad.wilk@oracle.com>
References: <1273592353-23224-1-git-send-email-konrad.wilk@oracle.com>
 <1273592353-23224-2-git-send-email-konrad.wilk@oracle.com>
 <1273592353-23224-3-git-send-email-konrad.wilk@oracle.com>
 <1273592353-23224-4-git-send-email-konrad.wilk@oracle.com>
 <1273592353-23224-5-git-send-email-konrad.wilk@oracle.com>
 <1273592353-23224-6-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4BE97A54.000F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the functions and variables that are now declared in the
swiotlb.h header file visible by the linker.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index dc1776c..986742c 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -364,6 +364,7 @@ void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 			memcpy(phys_to_virt(phys), dma_addr, size);
 	}
 }
+EXPORT_SYMBOL_GPL(swiotlb_bounce);
 
 void *swiotlb_tbl_map_single(struct device *hwdev, u64 tbl_dma_addr,
 			     phys_addr_t phys, size_t size,
@@ -468,6 +469,7 @@ found:
 
 	return dma_addr;
 }
+EXPORT_SYMBOL_GPL(swiotlb_tbl_map_single);
 
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
@@ -525,6 +527,7 @@ swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 	}
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
 }
+EXPORT_SYMBOL_GPL(swiotlb_tbl_unmap_single);
 
 void
 swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
@@ -553,6 +556,7 @@ swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
 		BUG();
 	}
 }
+EXPORT_SYMBOL_GPL(swiotlb_tbl_sync_single);
 
 void *
 swiotlb_alloc_coherent(struct device *hwdev, size_t size,
-- 
1.6.2.5

