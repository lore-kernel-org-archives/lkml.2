Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab2HOUR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:17:26 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62965 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747Ab2HOTvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 091/165] iommu/amd: Fix wrong shift direction
Date: Wed, 15 Aug 2012 15:47:15 -0400
Message-ID: <1345060109-9187-92-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit fcd0861db1cf4e6ed99f60a815b7b72c2ed36ea4 upstream.

The shift direction was wrong because the function takes a
page number and i is the address is the loop.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
[PG: drivers/iommu/ was arch/x86/kernel/ in 2.6.34 context]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/amd_iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 1aae617..74ce61d 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1046,7 +1046,7 @@ static int alloc_new_range(struct dma_ops_domain *dma_dom,
 		if (!pte || !IOMMU_PTE_PRESENT(*pte))
 			continue;
 
-		dma_ops_reserve_addresses(dma_dom, i << PAGE_SHIFT, 1);
+		dma_ops_reserve_addresses(dma_dom, i >> PAGE_SHIFT, 1);
 	}
 
 	update_domain(&dma_dom->domain);
-- 
1.7.12.rc2

