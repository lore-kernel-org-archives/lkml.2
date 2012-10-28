Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab2J1TP5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:15:57 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:41783 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab2J1TPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:15:19 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 5/5] mm, highmem: get virtual address of the page using PKMAP_ADDR()
Date: Mon, 29 Oct 2012 04:12:56 +0900
Message-Id: <1351451576-2611-6-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351451576-2611-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1351451576-2611-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In flush_all_zero_pkmaps(), we have an index of the pkmap associated the page.
Using this index, we can simply get virtual address of the page.
So change it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/highmem.c b/mm/highmem.c
index 65beb9a..1417f4f 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -137,8 +137,7 @@ static int flush_all_zero_pkmaps(void)
 		 * So no dangers, even with speculative execution.
 		 */
 		page = pte_page(pkmap_page_table[i]);
-		pte_clear(&init_mm, (unsigned long)page_address(page),
-			  &pkmap_page_table[i]);
+		pte_clear(&init_mm, PKMAP_ADDR(i), &pkmap_page_table[i]);
 
 		set_page_address(page, NULL);
 		index = i;
-- 
1.7.9.5

