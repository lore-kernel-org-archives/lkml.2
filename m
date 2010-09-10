Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab0IJE0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 00:26:32 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:40139 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab0IJE0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 00:26:30 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Hugh Dickins <hughd@google.com>,
        Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>
Subject: [PATCH 4/4] hugetlb, rmap: add BUG_ON(!PageLocked) in hugetlb_add_anon_rmap()
Date: Fri, 10 Sep 2010 13:23:06 +0900
Message-Id: <1284092586-1179-5-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1284092586-1179-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1284092586-1179-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Confirming page lock is held in hugetlb_add_anon_rmap() may be useful
to detect possible future problems.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/rmap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git v2.6.36-rc3/mm/rmap.c v2.6.36-rc3/mm/rmap.c
index 2854857..9d2ba01 100644
--- v2.6.36-rc3/mm/rmap.c
+++ v2.6.36-rc3/mm/rmap.c
@@ -1582,6 +1582,8 @@ void hugepage_add_anon_rmap(struct page *page,
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	int first;
+
+	BUG_ON(!PageLocked(page));
 	BUG_ON(!anon_vma);
 	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	first = atomic_inc_and_test(&page->_mapcount);
-- 
1.7.2.2

