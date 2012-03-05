Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab2CEGkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 01:40:31 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57918 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab2CEGka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 01:40:30 -0500
Date: Mon, 5 Mar 2012 06:40:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] flush_tlb_range() needs ->page_table_lock when
 ->mmap_sem is not held
Message-ID: <20120305064029.GK23916@ZenIV.linux.org.uk>
References: <20120305063707.GH23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305063707.GH23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 mm/hugetlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5f34bd8..a876871 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2277,8 +2277,8 @@ void __unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 			set_page_dirty(page);
 		list_add(&page->lru, &page_list);
 	}
-	spin_unlock(&mm->page_table_lock);
 	flush_tlb_range(vma, start, end);
+	spin_unlock(&mm->page_table_lock);
 	mmu_notifier_invalidate_range_end(mm, start, end);
 	list_for_each_entry_safe(page, tmp, &page_list, lru) {
 		page_remove_rmap(page);
-- 
1.7.2.5

