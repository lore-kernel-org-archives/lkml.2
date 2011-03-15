Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab1COWyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:54:12 -0400
Received: from shutemov.name ([188.40.19.243]:49811 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727Ab1COWx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:53:29 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: [PATCH 11/13] mm: use list_move() instead of list_del()/list_add() combination
Date: Wed, 16 Mar 2011 00:53:23 +0200
Message-Id: <1300229605-14499-11-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
References: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org
---
 mm/page_alloc.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cdef1d4..55fa2ae 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -863,9 +863,8 @@ static int move_freepages(struct zone *zone,
 		}
 
 		order = page_order(page);
-		list_del(&page->lru);
-		list_add(&page->lru,
-			&zone->free_area[order].free_list[migratetype]);
+		list_move(&page->lru,
+			  &zone->free_area[order].free_list[migratetype]);
 		page += 1 << order;
 		pages_moved += 1 << order;
 	}
-- 
1.7.4.1

