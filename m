Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2JSWjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:39:46 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46599 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab2JSWjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:39:45 -0400
Date: Sat, 20 Oct 2012 00:39:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (tip/s390 trees related)
Message-ID: <20121019223938.GB12658@gmail.com>
References: <20121018172201.b81dcc8fe40868256f532364@canb.auug.org.au>
 <20121018150209.GB17439@linux-mips.org>
 <1350683562.2768.78.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350683562.2768.78.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Actually, there's two sites - find the updated patch below.

Thanks,

	Ingo

--------------->
>From 7fc4d49214dba401f4b92ed62da60a5b257a653a Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@kernel.org>
Date: Sat, 20 Oct 2012 00:33:01 +0200
Subject: [PATCH] MIPS/thp: Fix update_mmu_cache() cache call

As per recent upstream commit:

  b113da65785d mm: Add and use update_mmu_cache_pmd() in transparent huge page code.

The call in do_huge_pmd_prot_none() needs to call update_mmu_cache_pmd()
as well.

This resolves a MIPS build error triggered on linux-next.

Reported-by: Ralf Baechle <ralf@linux-mips.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20121018145101.GA17439@linux-mips.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/huge_memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8100c01..1068e78 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -770,7 +770,7 @@ fixup:
 	/* change back to regular protection */
 	entry = pmd_modify(entry, vma->vm_page_prot);
 	set_pmd_at(mm, haddr, pmd, entry);
-	update_mmu_cache(vma, address, entry);
+	update_mmu_cache_pmd(vma, address, entry);
 
 unlock:
 	spin_unlock(&mm->page_table_lock);
@@ -846,7 +846,7 @@ migrate:
 	page_add_new_anon_rmap(new_page, vma, haddr);
 
 	set_pmd_at(mm, haddr, pmd, entry);
-	update_mmu_cache(vma, address, entry);
+	update_mmu_cache_pmd(vma, address, entry);
 	page_remove_rmap(page);
 	spin_unlock(&mm->page_table_lock);
 

