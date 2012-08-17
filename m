Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab2HQOPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:15:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757002Ab2HQOOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:14:40 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Jim Schutt <jaschut@sandia.gov>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 5/7] mm: compaction: Update comment in try_to_compact_pages
Date: Fri, 17 Aug 2012 15:14:31 +0100
Message-Id: <1345212873-22447-6-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1345212873-22447-1-git-send-email-mgorman@suse.de>
References: <1345212873-22447-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment about order applied when the check was
order > PAGE_ALLOC_COSTLY_ORDER which has not been the case since
[c5a73c3d: thp: use compaction for all allocation orders]. Fixing
the comment while I'm in the general area.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
---
 mm/compaction.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 6bf7f86..1c51395 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -871,11 +871,7 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
 	struct zone *zone;
 	int rc = COMPACT_SKIPPED;
 
-	/*
-	 * Check whether it is worth even starting compaction. The order check is
-	 * made because an assumption is made that the page allocator can satisfy
-	 * the "cheaper" orders without taking special steps
-	 */
+	/* Check if the GFP flags allow compaction */
 	if (!order || !may_enter_fs || !may_perform_io)
 		return rc;
 
-- 
1.7.9.2

