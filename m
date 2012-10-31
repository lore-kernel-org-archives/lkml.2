Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab2JaQ7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:59:15 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62937 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2JaQ7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:59:10 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH v2 1/5] mm, highmem: use PKMAP_NR() to calculate an index of pkmap
Date: Thu,  1 Nov 2012 01:56:33 +0900
Message-Id: <1351702597-10795-2-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351702597-10795-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1351702597-10795-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To calculate an index of pkmap, using PKMAP_NR() is more understandable
and maintainable, So change it.

Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>

diff --git a/mm/highmem.c b/mm/highmem.c
index d517cd1..b3b3d68 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -99,7 +99,7 @@ struct page *kmap_to_page(void *vaddr)
 	unsigned long addr = (unsigned long)vaddr;
 
 	if (addr >= PKMAP_ADDR(0) && addr <= PKMAP_ADDR(LAST_PKMAP)) {
-		int i = (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
+		int i = PKMAP_NR(addr);
 		return pte_page(pkmap_page_table[i]);
 	}
 
-- 
1.7.9.5

