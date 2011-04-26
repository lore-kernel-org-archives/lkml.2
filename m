Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab1DZQ0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:26:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62674 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab1DZQZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:25:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=i0fBjNjDhimnyEKpj2QcteAwaeKgq5oKNowFhZOBXRuwa10Mdq4ee0JcZRbXilyRzQ
         5KB4cQ7ncQX47IDQdV9QfDYI1gUJUJGylzbHhUKBjtnMYBf3GLtVKmkxtB3Wx1EiNHsT
         P0vQpYaYTmEm19kmN/KxK7bclz7BxMnAlafGg=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFC 4/8] Make clear description of putback_lru_page
Date: Wed, 27 Apr 2011 01:25:21 +0900
Message-Id: <bb2acc3882594cf54689d9e29c61077ff581c533.1303833417.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1303833415.git.minchan.kim@gmail.com>
References: <cover.1303833415.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1303833415.git.minchan.kim@gmail.com>
References: <cover.1303833415.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commonly, putback_lru_page is used with isolated_lru_page.
The isolated_lru_page picks the page in middle of LRU and
putback_lru_page insert the lru in head of LRU.
It means it could make LRU churning so we have to be very careful.
Let's clear description of putback_lru_page.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/migrate.c |    2 +-
 mm/vmscan.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

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
index e8d6190..5196f0c 100644
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
-- 
1.7.1

