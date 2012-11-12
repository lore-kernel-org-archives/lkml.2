Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2KLIaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 03:30:15 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21087 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab2KLIaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 03:30:13 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-41-50a0b393a91b
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        SeongHwan Yoon <sunghwan.yun@samsung.com>
Subject: [PATCH] mm: use migrate_prep() instead of migrate_prep_local()
Date: Mon, 12 Nov 2012 09:29:49 +0100
Message-id: <1352708989-25359-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t9jQd3JmxcEGJxq1LW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZGz51MxX0c1SsPrufrYHxAVsXIyeHhICJxI7DM5ghbDGJC/fW
	g8WFBKYzSnR1WHcxcgHZK5gkFn7bzQ6SYBMwlOh62wVWJCIQJvGncRsrSBGzwFUmiSs3H4JN
	EhZwl2g72sUCYrMIqEp82tTHCGLzCnhIPH5xB6iZA2ibgsScSTYTGLkXMDKsYhRNLUguKE5K
	zzXUK07MLS7NS9dLzs/dxAj24DOpHYwrGywOMQpwMCrx8EoGLggQYk0sK67MPcQowcGsJMI7
	TQQoxJuSWFmVWpQfX1Sak1p8iFGag0VJnLfZIyVASCA9sSQ1OzW1ILUIJsvEwSnVwGhfbfn8
	9tlNdZ0n9j54unxdgvS1SYv0RTRYFQ881nh3+2TupgIzC64KiWNGnjUfFWtNpK+2XrfksTv+
	cQLb0o1ZrZnHHb127VmxO2XehKq79/a4nAo8lZ72QO+M5pPExYyVrYt/iTn8Ti34uvq08MrD
	f3NeXBfUqzDm3Pnd1k1hDY/mW2a5j6uUWIozEg21mIuKEwFD8gZJ3AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__alloc_contig_migrate_range() should use all possible ways to get all the
pages migrated from the given memory range, so pruning per-cpu lru lists
for all CPUs is required, regadless the cost of such operation. Otherwise
some pages which got stuck at per-cpu lru list might get missed by
migration procedure causing the contiguous allocation to fail.

Reported-by: SeongHwan Yoon <sunghwan.yun@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1bfe2b0..fcb9719 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5677,7 +5677,7 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 	unsigned int tries = 0;
 	int ret = 0;
 
-	migrate_prep_local();
+	migrate_prep();
 
 	while (pfn < end || !list_empty(&cc->migratepages)) {
 		if (fatal_signal_pending(current)) {
-- 
1.7.9.5

