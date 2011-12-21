Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab1LUFSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 00:18:13 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63850 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1LUFSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 00:18:11 -0500
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH] vmalloc: remove #ifdef in function body
Date: Wed, 21 Dec 2011 14:17:59 +0900
Message-Id: <1324444679-9247-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't like function body which include #ifdef.
If we can, define null function to go out compile time.
It's trivial, no functional change.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmalloc.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0aca3ce..e1fa5a6 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -505,6 +505,7 @@ static void unmap_vmap_area(struct vmap_area *va)
 	vunmap_page_range(va->va_start, va->va_end);
 }
 
+#ifdef CONFIG_DEBUG_PAGEALLOC
 static void vmap_debug_free_range(unsigned long start, unsigned long end)
 {
 	/*
@@ -520,11 +521,15 @@ static void vmap_debug_free_range(unsigned long start, unsigned long end)
 	 * debugging doesn't do a broadcast TLB flush so it is a lot
 	 * faster).
 	 */
-#ifdef CONFIG_DEBUG_PAGEALLOC
 	vunmap_page_range(start, end);
 	flush_tlb_kernel_range(start, end);
-#endif
 }
+#else
+static inline void vmap_debug_free_range(unsigned long start,
+					unsigned long end)
+{
+}
+#endif
 
 /*
  * lazy_max_pages is the maximum amount of virtual address space we gather up
-- 
1.7.6.4

