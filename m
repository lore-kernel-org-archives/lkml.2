Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab0DBQDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 12:03:35 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34999 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab0DBQCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 12:02:49 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 07/14] Move definition for LRU isolation modes to a header
Date: Fri,  2 Apr 2010 17:02:41 +0100
Message-Id: <1270224168-14775-8-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1270224168-14775-1-git-send-email-mel@csn.ul.ie>
References: <1270224168-14775-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, vmscan.c defines the isolation modes for
__isolate_lru_page(). Memory compaction needs access to these modes for
isolating pages for migration.  This patch exports them.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
---
 include/linux/swap.h |    5 +++++
 mm/vmscan.c          |    5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1f59d93..986b12d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -238,6 +238,11 @@ static inline void lru_cache_add_active_file(struct page *page)
 	__lru_cache_add(page, LRU_ACTIVE_FILE);
 }
 
+/* LRU Isolation modes. */
+#define ISOLATE_INACTIVE 0	/* Isolate inactive pages. */
+#define ISOLATE_ACTIVE 1	/* Isolate active pages. */
+#define ISOLATE_BOTH 2		/* Isolate both active and inactive pages. */
+
 /* linux/mm/vmscan.c */
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 79c8098..ef89600 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -839,11 +839,6 @@ keep:
 	return nr_reclaimed;
 }
 
-/* LRU Isolation modes. */
-#define ISOLATE_INACTIVE 0	/* Isolate inactive pages. */
-#define ISOLATE_ACTIVE 1	/* Isolate active pages. */
-#define ISOLATE_BOTH 2		/* Isolate both active and inactive pages. */
-
 /*
  * Attempt to remove the specified page from its LRU.  Only take this page
  * if it is of the appropriate PageActive status.  Pages which are being
-- 
1.6.5

