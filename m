Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263Ab2LGK2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 05:28:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933055Ab2LGKZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 05:25:01 -0500
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Hillf Danton <dhillf@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 37/49] mm: numa: split_huge_page: Transfer last_nid on tail page
Date: Fri,  7 Dec 2012 10:23:40 +0000
Message-Id: <1354875832-9700-38-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1354875832-9700-1-git-send-email-mgorman@suse.de>
References: <1354875832-9700-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hillf Danton <dhillf@gmail.com>

Pass last_nid from head page to tail page.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 66e73cc..4c6efa8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1361,6 +1361,7 @@ static void __split_huge_page_refcount(struct page *page)
 		page_tail->mapping = page->mapping;
 
 		page_tail->index = page->index + i;
+		page_xchg_last_nid(page_tail, page_last_nid(page));
 
 		BUG_ON(!PageAnon(page_tail));
 		BUG_ON(!PageUptodate(page_tail));
-- 
1.7.9.2

