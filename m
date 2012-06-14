Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab2FNQFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:05:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11431 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab2FNQFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:05:09 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-94-4fda0bb329d1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm: compaction: add /proc/vmstat entry for rescued
 MIGRATE_UNMOVABLE pageblocks
Date: Thu, 14 Jun 2012 18:02:49 +0200
User-Agent: KMail/1.13.2 (Linux/3.2.6; KDE/4.4.5; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Dave Jones <davej@redhat.com>, Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201206141802.50075.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jAd0t3Lf8DbbzWVzeNYfNgdHj8ya5
	AMYoLpuU1JzMstQifbsErozrB+cwFXwVqdh86hZTA+NXwS5GTg4JAROJt5OvsUDYYhIX7q1n
	62Lk4hASWMQocfvrLSYIZzWTxJ3lX1lBqtgErCQmtq9iBLFFgLp3N88Fs4UF0iSu7n3MDGKz
	CKhK7F/eBFYvKmAtcfTCPUaQQcwCK5klbj9axg6S4BUQlPgx+R7YamYBLYnmN5sYIWx5ic1r
	3jJD1FhKLD9zmXECI98sJC2zkLTMQtKygJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw
	SD2T2sG4ssHiEKMAB6MSD68i4y1/IdbEsuLK3EOMEhzMSiK8AT9u+gvxpiRWVqUW5ccXleak
	Fh9ilOZgURLnbbK+4C8kkJ5YkpqdmlqQWgSTZeLglGpg5Pl4TnJj+DLl5XNed/Mm1Zj92t+3
	LmT5u1JZztKfOsJLyuO1/jyav98w7oaeTe0Uzx15v/Z6vPr+ZC3fxruRW8K/3zeNXO1rf+nt
	tg7GNzZea8+q7OwqfHLOTt/BnPv8lOO6Vtf/cSRv26O8/VTgofdOCZVPg3+buBjP2nvh/sHr
	sRWLc3venVJiKc5INNRiLipOBAB2eysHJQIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] mm: compaction: add /proc/vmstat entry for rescued MIGRATE_UNMOVABLE pageblocks

compact_rescued_unmovable_blocks shows the number of MIGRATE_UNMOVABLE
pageblocks converted back to MIGRATE_MOVABLE type by the memory compaction
code.  Non-zero values indicate that large kernel-originated allocations
of MIGRATE_UNMOVABLE type happen in the system and need special handling 
from the memory compaction code.

This new vmstat entry is optional but useful for development and understanding
the system.

Cc: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

 include/linux/vm_event_item.h |    1 +
 mm/compaction.c               |    2 ++
 mm/vmstat.c                   |    1 +
 3 files changed, 4 insertions(+)

Index: b/include/linux/vm_event_item.h
===================================================================
--- a/include/linux/vm_event_item.h	2012-06-14 11:28:48.812775316 +0200
+++ b/include/linux/vm_event_item.h	2012-06-14 11:31:17.132775300 +0200
@@ -39,6 +39,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #ifdef CONFIG_COMPACTION
 		COMPACTBLOCKS, COMPACTPAGES, COMPACTPAGEFAILED,
 		COMPACTSTALL, COMPACTFAIL, COMPACTSUCCESS,
+		COMPACT_RESCUED_UNMOVABLE_BLOCKS,
 #endif
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
Index: b/mm/compaction.c
===================================================================
--- a/mm/compaction.c	2012-06-14 11:31:24.800775299 +0200
+++ b/mm/compaction.c	2012-06-14 11:31:31.612775298 +0200
@@ -387,6 +387,8 @@ static void rescue_unmovable_pageblock(s
 {
 	set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 	move_freepages_block(page_zone(page), page, MIGRATE_MOVABLE);
+
+	count_vm_event(COMPACT_RESCUED_UNMOVABLE_BLOCKS);
 }
 
 /*
Index: b/mm/vmstat.c
===================================================================
--- a/mm/vmstat.c	2012-06-14 11:28:48.824775319 +0200
+++ b/mm/vmstat.c	2012-06-14 11:31:17.132775300 +0200
@@ -767,6 +767,7 @@ const char * const vmstat_text[] = {
 	"compact_stall",
 	"compact_fail",
 	"compact_success",
+	"compact_rescued_unmovable_blocks",
 #endif
 
 #ifdef CONFIG_HUGETLB_PAGE
