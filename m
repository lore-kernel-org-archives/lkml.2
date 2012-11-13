Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab2KMRQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:16:15 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37723 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2KMRPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:15:50 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Paul Turner <pjt@google.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 31/31] mm: Allow the migration of shared pages
Date: Tue, 13 Nov 2012 18:13:54 +0100
Message-Id: <1352826834-11774-32-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352826834-11774-1-git-send-email-mingo@kernel.org>
References: <1352826834-11774-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no good reason to disallow the migration of pages shared
by multiple processes - the migration code itself is already
properly walking the rmap chain.

So allow it. We've tested this with various workloads and
no ill effect appears to have come from this.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/migrate.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 72d1056..b89062d 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1427,12 +1427,6 @@ int migrate_misplaced_page(struct page *page, int node)
 	gfp_t gfp = GFP_HIGHUSER_MOVABLE;
 
 	/*
-	 * Don't migrate pages that are mapped in multiple processes.
-	 */
-	if (page_mapcount(page) != 1)
-		goto out;
-
-	/*
 	 * Never wait for allocations just to migrate on fault, but don't dip
 	 * into reserves. And, only accept pages from the specified node. No
 	 * sense migrating to a different "misplaced" page!
-- 
1.7.11.7

