Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246Ab2LGK2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 05:28:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933062Ab2LGKZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 05:25:02 -0500
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
Subject: [PATCH 38/49] mm: numa: migrate: Set last_nid on newly allocated page
Date: Fri,  7 Dec 2012 10:23:41 +0000
Message-Id: <1354875832-9700-39-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1354875832-9700-1-git-send-email-mgorman@suse.de>
References: <1354875832-9700-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hillf Danton <dhillf@gmail.com>

Pass last_nid from misplaced page to newly allocated migration target page.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/migrate.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index 2c8310c..6bc9745 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1457,6 +1457,9 @@ static struct page *alloc_misplaced_dst_page(struct page *page,
 					  __GFP_NOMEMALLOC | __GFP_NORETRY |
 					  __GFP_NOWARN) &
 					 ~GFP_IOFS, 0);
+	if (newpage)
+		page_xchg_last_nid(newpage, page_last_nid(page));
+
 	return newpage;
 }
 
-- 
1.7.9.2

