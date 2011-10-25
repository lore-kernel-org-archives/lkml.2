Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab1JYCvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 22:51:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:11923 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240Ab1JYCvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 22:51:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="66809805"
Subject: [patch 2/5]thp: remove unnecessary tlb flush for mprotect
From: Shaohua Li <shaohua.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: aarcange@redhat.com, Hugh Dickins <hughd@google.com>,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Oct 2011 10:59:25 +0800
Message-ID: <1319511565.22361.138.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change_protection() will do TLB flush later, don't need duplicate tlb flush.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 mm/huge_memory.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/mm/huge_memory.c
===================================================================
--- linux.orig/mm/huge_memory.c	2011-10-24 19:24:31.000000000 +0800
+++ linux/mm/huge_memory.c	2011-10-24 19:25:10.000000000 +0800
@@ -1079,7 +1079,6 @@ int change_huge_pmd(struct vm_area_struc
 			entry = pmd_modify(entry, newprot);
 			set_pmd_at(mm, addr, pmd, entry);
 			spin_unlock(&vma->vm_mm->page_table_lock);
-			flush_tlb_range(vma, addr, addr + HPAGE_PMD_SIZE);
 			ret = 1;
 		}
 	} else


