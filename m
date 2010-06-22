Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab0FVTrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:47:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51966 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab0FVTrK (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:47:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 15/19] swiotlb-xen: Put 'swiotlb-xen.c' function declarations in the header.
Date: Tue, 22 Jun 2010 15:42:48 -0400
Message-Id: <1277235772-26757-16-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4C2112D3.01CB:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We also remove the temporary scaffolding required to compile
swiotlb-xen.c file.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/swiotlb-xen.h |   65 +++++++++++++++++++++++++++++++++++++++++++
 lib/swiotlb-xen.c           |    7 +----
 2 files changed, 66 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/swiotlb-xen.h

diff --git a/include/linux/swiotlb-xen.h b/include/linux/swiotlb-xen.h
new file mode 100644
index 0000000..21083f2
--- /dev/null
+++ b/include/linux/swiotlb-xen.h
@@ -0,0 +1,65 @@
+#ifndef __LINUX_SWIOTLB_XEN_H
+#define __LINUX_SWIOTLB_XEN_H
+
+#include <linux/swiotlb.h>
+
+extern void xen_swiotlb_init(int verbose);
+
+extern void
+*xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
+			    dma_addr_t *dma_handle, gfp_t flags);
+
+extern void
+xen_swiotlb_free_coherent(struct device *hwdev, size_t size,
+			  void *vaddr, dma_addr_t dma_handle);
+
+extern dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
+				       unsigned long offset, size_t size,
+				       enum dma_data_direction dir,
+				       struct dma_attrs *attrs);
+
+extern void xen_swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
+				   size_t size, enum dma_data_direction dir,
+				   struct dma_attrs *attrs);
+
+extern int
+xen_swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg, int nents,
+		   enum dma_data_direction dir);
+
+extern void
+xen_swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
+		     enum dma_data_direction dir);
+
+extern int
+xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
+			 int nelems, enum dma_data_direction dir,
+			 struct dma_attrs *attrs);
+
+extern void
+xen_swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
+			   int nelems, enum dma_data_direction dir,
+			   struct dma_attrs *attrs);
+
+extern void
+xen_swiotlb_sync_single_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
+				size_t size, enum dma_data_direction dir);
+
+extern void
+xen_swiotlb_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
+			    int nelems, enum dma_data_direction dir);
+
+extern void
+xen_swiotlb_sync_single_for_device(struct device *hwdev, dma_addr_t dev_addr,
+				   size_t size, enum dma_data_direction dir);
+
+extern void
+xen_swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
+			       int nelems, enum dma_data_direction dir);
+
+extern int
+xen_swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
+
+extern int
+xen_swiotlb_dma_supported(struct device *hwdev, u64 mask);
+
+#endif /* __LINUX_SWIOTLB_XEN_H */
diff --git a/lib/swiotlb-xen.c b/lib/swiotlb-xen.c
index 3c5bfde..6bba1a5 100644
--- a/lib/swiotlb-xen.c
+++ b/lib/swiotlb-xen.c
@@ -35,6 +35,7 @@
 
 #include <linux/bootmem.h>
 #include <linux/dma-mapping.h>
+#include <linux/swiotlb-xen.h>
 #include <xen/page.h>
 #include <xen/xen-ops.h>
 /*
@@ -46,12 +47,6 @@
 static char *xen_io_tlb_start, *xen_io_tlb_end;
 static unsigned long xen_io_tlb_nslabs;
 
-/* Temporary scaffolding. Will be removed later. */
-void
-xen_swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
-			   int nelems, enum dma_data_direction dir,
-			   struct dma_attrs *attrs);
-
 static dma_addr_t xen_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 {
 	return phys_to_machine(XPADDR(paddr)).maddr;;
-- 
1.7.0.1

