Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab1CCArq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 19:47:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:30804 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487Ab1CCAqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 19:46:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,256,1297065600"; 
   d="scan'208";a="715432802"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/8] Preserve original node for transparent huge page copies
Date: Wed,  2 Mar 2011 16:45:24 -0800
Message-Id: <1299113128-11349-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299113128-11349-1-git-send-email-andi@firstfloor.org>
References: <1299113128-11349-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This makes a difference for LOCAL policy, where the node cannot
be determined from the policy itself, but has to be gotten
from the original page.

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 mm/huge_memory.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c7c2cd9..1802db8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -799,8 +799,8 @@ static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
 	}
 
 	for (i = 0; i < HPAGE_PMD_NR; i++) {
-		pages[i] = alloc_page_vma(GFP_HIGHUSER_MOVABLE,
-					  vma, address);
+		pages[i] = alloc_page_vma_node(GFP_HIGHUSER_MOVABLE,
+					       vma, address, page_to_nid(page));
 		if (unlikely(!pages[i] ||
 			     mem_cgroup_newpage_charge(pages[i], mm,
 						       GFP_KERNEL))) {
-- 
1.7.4

