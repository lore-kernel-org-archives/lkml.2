Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707Ab1E0Bc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:32:29 -0400
Received: from relay3.sgi.com ([192.48.152.1]:37783 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758613Ab1E0BcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:32:25 -0400
Message-Id: <20110527013221.827396251@gulag1.americas.sgi.com>
References: <20110527013221.231071058@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 26 May 2011 20:32:25 -0500
From: Mike Travis <travis@sgi.com>
To: David Woodhouse <dwmw2@infradead.org>, Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Mike Habeck <habeck@sgi.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        stable@kernel.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] Intel pci: Use coherent DMA mask when requested
Content-Disposition: inline; filename=use-coherent-dma-mask.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    The __intel_map_single function is not honoring the passed in
    DMA mask.  This results in not using the coherent DMA mask when
    called from intel_alloc_coherent().

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Reviewed-by: Mike Habeck <habeck@sgi.com>
---
 drivers/pci/intel-iommu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux.orig/drivers/pci/intel-iommu.c
+++ linux/drivers/pci/intel-iommu.c
@@ -2603,8 +2603,7 @@ static dma_addr_t __intel_map_single(str
 	iommu = domain_get_iommu(domain);
 	size = aligned_nrpages(paddr, size);
 
-	iova = intel_alloc_iova(hwdev, domain, dma_to_mm_pfn(size),
-				pdev->dma_mask);
+	iova = intel_alloc_iova(hwdev, domain, dma_to_mm_pfn(size), dma_mask);
 	if (!iova)
 		goto error;
 

-- 
