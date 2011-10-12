Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab1JLOji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:39:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42751 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1JLOjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:39:37 -0400
MIME-Version: 1.0
Date: Wed, 12 Oct 2011 22:39:36 +0800
Message-ID: <CAJd=RBBuwmcV8srUyPGnKUp=RPKvsSd+4BbLrh--aHFGC5s7+g@mail.gmail.com>
Subject: [PATCH] mm/huge_memory: Clean up typo when copying user highpage
From: Hillf Danton <dhillf@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea

When copying user highpage, the PAGE_SHIFT in the third parameter is a typo,
I think, and is replaced with PAGE_SIZE.

When configuring transparent hugepage, it depends on x86 and MMU.
Would you please tippoint why other archs with MMU, say MIPS, are masked out?

Thanks

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/huge_memory.c	Sat Aug 13 11:45:14 2011
+++ b/mm/huge_memory.c	Wed Oct 12 22:26:15 2011
@@ -829,7 +829,7 @@ static int do_huge_pmd_wp_page_fallback(

 	for (i = 0; i < HPAGE_PMD_NR; i++) {
 		copy_user_highpage(pages[i], page + i,
-				   haddr + PAGE_SHIFT*i, vma);
+				   haddr + PAGE_SIZE * i, vma);
 		__SetPageUptodate(pages[i]);
 		cond_resched();
 	}
