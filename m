Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab2KVU1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:27:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756832Ab2KVT0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:26:19 -0500
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 14/40] mm: numa: split_huge_page: transfer the NUMA type from the pmd to the pte
Date: Thu, 22 Nov 2012 19:25:27 +0000
Message-Id: <1353612353-1576-15-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1353612353-1576-1-git-send-email-mgorman@suse.de>
References: <1353612353-1576-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

When we split a transparent hugepage, transfer the NUMA type from the
pmd to the pte if needed.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40f17c3..3aaf242 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1363,6 +1363,8 @@ static int __split_huge_page_map(struct page *page,
 				BUG_ON(page_mapcount(page) != 1);
 			if (!pmd_young(*pmd))
 				entry = pte_mkold(entry);
+			if (pmd_numa(*pmd))
+				entry = pte_mknuma(entry);
 			pte = pte_offset_map(&_pmd, haddr);
 			BUG_ON(!pte_none(*pte));
 			set_pte_at(mm, haddr, pte, entry);
-- 
1.7.9.2

