Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab1KCCDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:03:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933877Ab1KCBiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:38:02 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:57 2011
Message-Id: <20111102221457.347873343@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>
Subject: [079/107] iommu/amd: Fix wrong shift direction
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit fcd0861db1cf4e6ed99f60a815b7b72c2ed36ea4 upstream.

The shift direction was wrong because the function takes a
page number and i is the address is the loop.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -842,7 +842,7 @@ static int alloc_new_range(struct amd_io
 		if (!pte || !IOMMU_PTE_PRESENT(*pte))
 			continue;
 
-		dma_ops_reserve_addresses(dma_dom, i << PAGE_SHIFT, 1);
+		dma_ops_reserve_addresses(dma_dom, i >> PAGE_SHIFT, 1);
 	}
 
 	update_domain(&dma_dom->domain);


