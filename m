Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab2J1TPM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:15:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36980 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2J1TPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:15:10 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/5] mm, highmem: use PKMAP_NR() to calculate an index of pkmap
Date: Mon, 29 Oct 2012 04:12:52 +0900
Message-Id: <1351451576-2611-2-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351451576-2611-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1351451576-2611-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To calculate an index of pkmap, using PKMAP_NR() is more understandable
and maintainable, So change it.

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Joonsoo Kim <js1304@gmail.com>

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

