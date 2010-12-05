Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab0LER3x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:29:53 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60513 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328Ab0LER3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:29:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rR4SVRfdJxebrgCLEa3dS45OFIkXyEfzamTlXVj8HFp8Bcn2eeuUjtkn8XI87BeY/5
         1XgcTVRFG5iwOD23LZHTXqacIymPWggL28YU8DVzCFsJv/7N6Hg04WbxVCGPXgKiNrt+
         JQRK1wFi+u3szmgsxVg3Ag4gJ8QXD7Kl6Jnb4=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v4 1/7] Fix checkpatch's report in swap.c
Date: Mon,  6 Dec 2010 02:29:09 +0900
Message-Id: <f4bc70172f1e6c7357480af503b7a01cd96ccadd.1291568905.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1291568905.git.minchan.kim@gmail.com>
References: <cover.1291568905.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1291568905.git.minchan.kim@gmail.com>
References: <cover.1291568905.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch reports following problems.
It's a very annoying. This patch fixes it.

barrios@barrios-desktop:~/linux-2.6$ ./scripts/checkpatch.pl -f mm/swap.c
WARNING: line over 80 characters
+		if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
+EXPORT_SYMBOL(mark_page_accessed);

ERROR: code indent should use tabs where possible
+  ^I^I}$

WARNING: please, no space before tabs
+  ^I^I}$

WARNING: please, no spaces at the start of a line
+  ^I^I}$

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
+EXPORT_SYMBOL(__pagevec_release);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
+EXPORT_SYMBOL(____pagevec_lru_add);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
+EXPORT_SYMBOL(pagevec_lookup);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
+EXPORT_SYMBOL(pagevec_lookup_tag);

total: 1 errors, 8 warnings, 517 lines checked

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/swap.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 3f48542..d5822b0 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -118,7 +118,8 @@ static void pagevec_move_tail(struct pagevec *pvec)
 			zone = pagezone;
 			spin_lock(&zone->lru_lock);
 		}
-		if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
+		if (PageLRU(page) && !PageActive(page) &&
+					!PageUnevictable(page)) {
 			int lru = page_lru_base_type(page);
 			list_move_tail(&page->lru, &zone->lru[lru].list);
 			pgmoved++;
@@ -212,7 +213,6 @@ void mark_page_accessed(struct page *page)
 		SetPageReferenced(page);
 	}
 }
-
 EXPORT_SYMBOL(mark_page_accessed);
 
 void __lru_cache_add(struct page *page, enum lru_list lru)
@@ -371,7 +371,7 @@ void release_pages(struct page **pages, int nr, int cold)
 			}
 			__pagevec_free(&pages_to_free);
 			pagevec_reinit(&pages_to_free);
-  		}
+		}
 	}
 	if (zone)
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
@@ -396,7 +396,6 @@ void __pagevec_release(struct pagevec *pvec)
 	release_pages(pvec->pages, pagevec_count(pvec), pvec->cold);
 	pagevec_reinit(pvec);
 }
-
 EXPORT_SYMBOL(__pagevec_release);
 
 /*
@@ -438,7 +437,6 @@ void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru)
 	release_pages(pvec->pages, pvec->nr, pvec->cold);
 	pagevec_reinit(pvec);
 }
-
 EXPORT_SYMBOL(____pagevec_lru_add);
 
 /*
@@ -481,7 +479,6 @@ unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 	pvec->nr = find_get_pages(mapping, start, nr_pages, pvec->pages);
 	return pagevec_count(pvec);
 }
-
 EXPORT_SYMBOL(pagevec_lookup);
 
 unsigned pagevec_lookup_tag(struct pagevec *pvec, struct address_space *mapping,
@@ -491,7 +488,6 @@ unsigned pagevec_lookup_tag(struct pagevec *pvec, struct address_space *mapping,
 					nr_pages, pvec->pages);
 	return pagevec_count(pvec);
 }
-
 EXPORT_SYMBOL(pagevec_lookup_tag);
 
 /*
-- 
1.7.0.4

