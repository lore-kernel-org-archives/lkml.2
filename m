Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab1DGTwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 15:52:08 -0400
Received: from relay3.sgi.com ([192.48.152.1]:57084 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756565Ab1DGTwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 15:52:05 -0400
Message-ID: <4D9E15E0.5060000@sgi.com>
Date: Thu, 07 Apr 2011 12:52:00 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Mike Habeck <habeck@sgi.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 4/4] Intel pci: Use coherent DMA mask when requested
References: <20110329233602.272459647@gulag1.americas.sgi.com>
In-Reply-To: <20110329233602.272459647@gulag1.americas.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    The __intel_map_single function is not honoring the passed in
    DMA mask.  This results in not using the coherent DMA mask when
    called from intel_alloc_coherent().

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Mike Habeck <habeck@sgi.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
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
