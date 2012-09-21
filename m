Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab2IUKqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 06:46:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508Ab2IUKq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 06:46:28 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        QEMU-devel <qemu-devel@nongnu.org>, KVM <kvm@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/9] Revert "mm: compaction: check lock contention first before taking lock"
Date: Fri, 21 Sep 2012 11:46:15 +0100
Message-Id: <1348224383-1499-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1348224383-1499-1-git-send-email-mgorman@suse.de>
References: <1348224383-1499-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts
mm-compaction-check-lock-contention-first-before-taking-lock.patch as it
is replaced by a later patch in the series.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 3bb7232..4a77b4b 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -347,9 +347,8 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 
 	/* Time to isolate some pages for migration */
 	cond_resched();
-	locked = compact_trylock_irqsave(&zone->lru_lock, &flags, cc);
-	if (!locked)
-		return 0;
+	spin_lock_irqsave(&zone->lru_lock, flags);
+	locked = true;
 	for (; low_pfn < end_pfn; low_pfn++) {
 		struct page *page;
 
-- 
1.7.9.2

