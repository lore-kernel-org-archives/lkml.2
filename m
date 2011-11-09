Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934625Ab1KJDZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:25:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934611Ab1KJDZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:25:53 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:11 2011
Message-Id: <20111109212711.906004641@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>
Subject: [112/262] iommu/amd: Fix wrong shift direction
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1203,7 +1203,7 @@ static int alloc_new_range(struct dma_op
 		if (!pte || !IOMMU_PTE_PRESENT(*pte))
 			continue;
 
-		dma_ops_reserve_addresses(dma_dom, i << PAGE_SHIFT, 1);
+		dma_ops_reserve_addresses(dma_dom, i >> PAGE_SHIFT, 1);
 	}
 
 	update_domain(&dma_dom->domain);


