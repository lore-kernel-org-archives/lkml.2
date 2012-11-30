Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab2K3PCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:02:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:57687 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917Ab2K3PCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:02:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="255573138"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Bob Liu <lliubbo@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 1/2] thp: fix anononymous page accounting in fallback path for COW of HZP
Date: Fri, 30 Nov 2012 17:03:40 +0200
Message-Id: <1354287821-5925-2-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354287821-5925-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <50B52E17.8020205@suse.cz>
 <1354287821-5925-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Don't forget to account newly allocated page in fallback path for
copy-on-write of huge zero page.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/huge_memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 57f0024..9d6f521 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1164,6 +1164,7 @@ static int do_huge_pmd_wp_zero_page_fallback(struct mm_struct *mm,
 	pmd_populate(mm, pmd, pgtable);
 	spin_unlock(&mm->page_table_lock);
 	put_huge_zero_page();
+	inc_mm_counter(mm, MM_ANONPAGES);
 
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
-- 
1.7.11.7

