Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab1C2Xgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 19:36:45 -0400
Received: from relay2.sgi.com ([192.48.179.30]:44447 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754111Ab1C2XgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:36:06 -0400
Message-Id: <20110329233602.935998468@gulag1.americas.sgi.com>
References: <20110329233602.272459647@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Mar 2011 18:36:06 -0500
From: Mike Travis <travis@sgi.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Mike Habeck <habeck@sgi.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Intel pci: Use coherent DMA mask when requested
Content-Disposition: inline; filename=use-coherent-dma-mask
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    The __intel_map_single function is not honoring the passed in
    DMA mask.  This results in not using the coherent DMA mask when
    called from intel_alloc_coherent().

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Mike Habeck <habeck@sgi.com>
---
 drivers/pci/intel-iommu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux.orig/drivers/pci/intel-iommu.c
+++ linux/drivers/pci/intel-iommu.c
@@ -2582,8 +2582,7 @@ static dma_addr_t __intel_map_single(str
 	iommu = domain_get_iommu(domain);
 	size = aligned_nrpages(paddr, size);
 
-	iova = intel_alloc_iova(hwdev, domain, dma_to_mm_pfn(size),
-				pdev->dma_mask);
+	iova = intel_alloc_iova(hwdev, domain, dma_to_mm_pfn(size), dma_mask);
 	if (!iova)
 		goto error;
 

-- 
