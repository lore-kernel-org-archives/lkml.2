Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099Ab2EJPdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:33:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61300 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2EJPds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:33:48 -0400
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] cma: fix migration mode
Date: Fri, 11 May 2012 00:33:23 +0900
Message-Id: <1336664003-5031-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__alloc_contig_migrate_range calls migrate_pages with wrong argument
for migrate_mode. Fix it.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4d926f1..9febc62 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5689,7 +5689,7 @@ static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
 
 		ret = migrate_pages(&cc.migratepages,
 				    __alloc_contig_migrate_alloc,
-				    0, false, true);
+				    0, false, MIGRATE_SYNC);
 	}
 
 	putback_lru_pages(&cc.migratepages);
-- 
1.7.9.5

