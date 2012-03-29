Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515Ab2C2Ik3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 04:40:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758054Ab2C2IkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 04:40:21 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: [PATCH] pagemap: remove remaining unneeded spin_lock()
Date: Thu, 29 Mar 2012 04:39:39 -0400
Message-Id: <1333010379-31126-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit: 025c5b2451e4 "thp: optimize away unnecessary page table locking"
moves spin_lock() into pmd_trans_huge_lock() in order to avoid locking
unless pmd is for thp. So this spin_lock() is a bug.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: stable@vger.kernel.org
---
 fs/proc/task_mmu.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git linux-3.3.0-6658a6991ce.orig/fs/proc/task_mmu.c linux-3.3.0-6658a6991ce/fs/proc/task_mmu.c
index 9694cc2..06d2b70 100644
--- linux-3.3.0-6658a6991ce.orig/fs/proc/task_mmu.c
+++ linux-3.3.0-6658a6991ce/fs/proc/task_mmu.c
@@ -786,7 +786,6 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
-	spin_lock(&walk->mm->page_table_lock);
 	if (pmd_trans_huge_lock(pmd, vma) == 1) {
 		for (; addr != end; addr += PAGE_SIZE) {
 			unsigned long offset;
-- 
1.7.7.6

