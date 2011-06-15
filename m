Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab1FPHmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:42:06 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35534 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754844Ab1FPHAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:11 -0400
X-Sasl-enc: hvQHJBgSAqHaqt8BsuL607KoIlP1TEEZC/oncAfg8NpC 1308207610
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:29 2011
Message-Id: <20110616000229.671748201@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Travis <travis@sgi.com>, Chris Wright <chrisw@sous-sol.org>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [07/89] intel-iommu: Use coherent DMA mask when requested
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Travis <travis@sgi.com>

commit c681d0ba1252954208220ad32248a3e8e2fc98e4 upstream.

The __intel_map_single function is not honoring the passed in DMA mask.
This results in not using the coherent DMA mask when called from
intel_alloc_coherent().

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Reviewed-by: Mike Habeck <habeck@sgi.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2606,8 +2606,7 @@ static dma_addr_t __intel_map_single(str
 	iommu = domain_get_iommu(domain);
 	size = aligned_nrpages(paddr, size);
 
-	iova = intel_alloc_iova(hwdev, domain, dma_to_mm_pfn(size),
-				pdev->dma_mask);
+	iova = intel_alloc_iova(hwdev, domain, dma_to_mm_pfn(size), dma_mask);
 	if (!iova)
 		goto error;
 


