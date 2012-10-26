Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab2JZMxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:53:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:19649 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694Ab2JZMxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:53:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,654,1344236400"; 
   d="scan'208";a="209663444"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: linux-mm@kvack.org
Cc: Will Deacon <will.deacon@arm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] numa, mm: drop redundant check in do_huge_pmd_numa_page()
Date: Fri, 26 Oct 2012 15:54:34 +0300
Message-Id: <1351256077-1594-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

We check if the pmd entry is the same as on pmd_trans_huge() in
handle_mm_fault(). That's enough.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/huge_memory.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3c14a96..9bb2c23 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -758,12 +758,6 @@ void do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (unlikely(!pmd_same(*pmd, entry)))
 		goto unlock;
 
-	if (unlikely(pmd_trans_splitting(entry))) {
-		spin_unlock(&mm->page_table_lock);
-		wait_split_huge_page(vma->anon_vma, pmd);
-		return;
-	}
-
 	page = pmd_page(entry);
 	if (page) {
 		VM_BUG_ON(!PageCompound(page) || !PageHead(page));
-- 
1.7.10.4

