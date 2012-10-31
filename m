Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab2JaQ7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:59:25 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39663 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2JaQ7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:59:22 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH v2 5/5] mm, highmem: get virtual address of the page using PKMAP_ADDR()
Date: Thu,  1 Nov 2012 01:56:37 +0900
Message-Id: <1351702597-10795-6-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351702597-10795-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1351702597-10795-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In flush_all_zero_pkmaps(), we have an index of the pkmap associated the page.
Using this index, we can simply get virtual address of the page.
So change it.

Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>

diff --git a/mm/highmem.c b/mm/highmem.c
index b365f7b..675ec97 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -137,8 +137,7 @@ static unsigned int flush_all_zero_pkmaps(void)
 		 * So no dangers, even with speculative execution.
 		 */
 		page = pte_page(pkmap_page_table[i]);
-		pte_clear(&init_mm, (unsigned long)page_address(page),
-			  &pkmap_page_table[i]);
+		pte_clear(&init_mm, PKMAP_ADDR(i), &pkmap_page_table[i]);
 
 		set_page_address(page, NULL);
 		if (index == PKMAP_INVALID_INDEX)
-- 
1.7.9.5

