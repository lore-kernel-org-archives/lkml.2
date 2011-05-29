Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab1E2SOL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 14:14:11 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:54550 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab1E2SOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 14:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YUhZLpiBgR0ustF3jtsDZeqJwfQHGH1QfW0S0/V6agBRjRdGdPdRn9DViXYZ0iORSF
         ETWclSykjR5IIFONb9tkBNmoW/xSwD+aEHKiOL3VprIukIZIKueRJ87sdkU73qqSCAvk
         Lgmzyyqd5YMSJirZY6z+J5inCnOU9xxOUIOfY=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v2 01/10] Make clear description of isolate/putback functions
Date: Mon, 30 May 2011 03:13:40 +0900
Message-Id: <5f9f6c96ccb344c4ca0dd9c1f06bd21db93fda51.1306689214.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1306689214.git.minchan.kim@gmail.com>
References: <cover.1306689214.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1306689214.git.minchan.kim@gmail.com>
References: <cover.1306689214.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commonly, putback_lru_page is used with isolated_lru_page.
The isolated_lru_page picks the page in middle of LRU and
putback_lru_page insert the lru in head of LRU.
It means it could make LRU churning so we have to be very careful.
Let's clear description of isolate/putback functions.

Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/migrate.c |    2 +-
 mm/vmscan.c  |    8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 34132f8..819d233 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -68,7 +68,7 @@ int migrate_prep_local(void)
 }
 
 /*
- * Add isolated pages on the list back to the LRU under page lock
+ * Add isolated pages on the list back to the LRU's head under page lock
  * to avoid leaking evictable pages back onto unevictable list.
  */
 void putback_lru_pages(struct list_head *l)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8bfd450..a658dde 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -551,10 +551,10 @@ int remove_mapping(struct address_space *mapping, struct page *page)
 }
 
 /**
- * putback_lru_page - put previously isolated page onto appropriate LRU list
+ * putback_lru_page - put previously isolated page onto appropriate LRU list's head
  * @page: page to be put back to appropriate lru list
  *
- * Add previously isolated @page to appropriate LRU list.
+ * Add previously isolated @page to appropriate LRU list's head
  * Page may still be unevictable for other reasons.
  *
  * lru_lock must not be held, interrupts must be enabled.
@@ -1196,6 +1196,10 @@ static unsigned long clear_active_flags(struct list_head *page_list,
  *     without a stable reference).
  * (2) the lru_lock must not be held.
  * (3) interrupts must be enabled.
+ *
+ * NOTE : This function removes the page from LRU list and putback_lru_page
+ * insert the page to LRU list's head. It means it makes LRU churing so you
+ * have to use the function carefully.
  */
 int isolate_lru_page(struct page *page)
 {
-- 
1.7.0.4

