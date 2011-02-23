Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab1BWBwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:52:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:5443 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab1BWBwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:52:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,209,1297065600"; 
   d="scan'208";a="660493455"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>, aarcange@redhat.com
Subject: [PATCH 4/8] Preserve original node for transparent huge page copies
Date: Tue, 22 Feb 2011 17:51:58 -0800
Message-Id: <1298425922-23630-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298425922-23630-1-git-send-email-andi@firstfloor.org>
References: <1298425922-23630-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This makes a difference for LOCAL policy, where the node cannot
be determined from the policy itself, but has to be gotten
from the original page.

Cc: aarcange@redhat.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 mm/huge_memory.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 73ecca5..00a5c39 100644
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

