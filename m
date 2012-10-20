Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab2JTBIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 21:08:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36350 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933240Ab2JTBIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 21:08:37 -0400
Date: Fri, 19 Oct 2012 18:08:16 -0700
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-7fc4d49214dba401f4b92ed62da60a5b257a653a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ralf@linux-mips.org, peterz@infradead.org, sfr@canb.auug.org.au,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, peterz@infradead.org, tglx@linutronix.de,
        sfr@canb.auug.org.au
In-Reply-To: <20121018145101.GA17439@linux-mips.org>
References: <20121018145101.GA17439@linux-mips.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] MIPS/thp: Fix update_mmu_cache() cache call
Git-Commit-ID: 7fc4d49214dba401f4b92ed62da60a5b257a653a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 19 Oct 2012 18:08:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7fc4d49214dba401f4b92ed62da60a5b257a653a
Gitweb:     http://git.kernel.org/tip/7fc4d49214dba401f4b92ed62da60a5b257a653a
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Sat, 20 Oct 2012 00:33:01 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 20 Oct 2012 00:39:02 +0200

MIPS/thp: Fix update_mmu_cache() cache call

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
 mm/huge_memory.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
 
