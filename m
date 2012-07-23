Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab2GWNk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 09:40:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693Ab2GWNjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 09:39:06 -0400
From: Mel Gorman <mgorman@suse.de>
To: Stable <stable@vger.kernel.org>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 29/34] mm: test PageSwapBacked in lumpy reclaim
Date: Mon, 23 Jul 2012 14:38:42 +0100
Message-Id: <1343050727-3045-30-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1343050727-3045-1-git-send-email-mgorman@suse.de>
References: <1343050727-3045-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit 043bcbe5ec51e0478ef2b44acef17193e01d7f70 upstream.

Stable note: Not tracked in Bugzilla. There were reports of shared
	mapped pages being unfairly reclaimed in comparison to older kernels.
	This is being addressed over time. Even though the subject
	refers to lumpy reclaim, it impacts compaction as well.

Lumpy reclaim does well to stop at a PageAnon when there's no swap, but
better is to stop at any PageSwapBacked, which includes shmem/tmpfs too.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index da195c2..e5382ad 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1199,7 +1199,7 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 			 * anon page which don't already have a swap slot is
 			 * pointless.
 			 */
-			if (nr_swap_pages <= 0 && PageAnon(cursor_page) &&
+			if (nr_swap_pages <= 0 && PageSwapBacked(cursor_page) &&
 			    !PageSwapCache(cursor_page))
 				break;
 
-- 
1.7.9.2

