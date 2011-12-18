Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1LRXvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 18:51:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38736 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1LRXvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 18:51:42 -0500
Date: Sun, 18 Dec 2011 15:50:45 -0800
From: tip-bot for Jesper Juhl <jj@chaosbits.net>
Message-ID: <tip-2ac13462b6d242684996e88a07fbed6dec6af622@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        eric.dumazet@gmail.com, mel@csn.ul.ie, hannes@cmpxchg.org,
        hughd@google.com, riel@redhat.com, jj@chaosbits.net,
        aarcange@redhat.com, tglx@linutronix.de,
        kamezawa.hiroyu@jp.fujitsu.com, walken@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, mel@csn.ul.ie, hannes@cmpxchg.org,
        hughd@google.com, riel@redhat.com, aarcange@redhat.com,
        jj@chaosbits.net, tglx@linutronix.de, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu
In-Reply-To: <alpine.LNX.2.00.1112180128070.21784@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1112180128070.21784@swampdragon.chaosbits.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Use "do { } while(0)"
  for empty flush_tlb_fix_spurious_fault() macro
Git-Commit-ID: 2ac13462b6d242684996e88a07fbed6dec6af622
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 18 Dec 2011 15:50:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ac13462b6d242684996e88a07fbed6dec6af622
Gitweb:     http://git.kernel.org/tip/2ac13462b6d242684996e88a07fbed6dec6af622
Author:     Jesper Juhl <jj@chaosbits.net>
AuthorDate: Sun, 18 Dec 2011 01:32:09 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 18 Dec 2011 09:14:18 +0100

x86: Use "do { } while(0)" for empty flush_tlb_fix_spurious_fault() macro

If one builds the kernel with -Wempty-body one gets this
warning:

  mm/memory.c:3432:46: warning: suggest braces around empty body in an ¡if¢ statement [-Wempty-body]

due to the fact that 'flush_tlb_fix_spurious_fault' is a macro
that can sometimes be defined to nothing.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-mm@kvack.org
Cc: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1112180128070.21784@swampdragon.chaosbits.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/pgtable.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 18601c8..49afb3f 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -703,7 +703,7 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm,
 	pte_update(mm, addr, ptep);
 }
 
-#define flush_tlb_fix_spurious_fault(vma, address)
+#define flush_tlb_fix_spurious_fault(vma, address) do { } while (0)
 
 #define mk_pmd(page, pgprot)   pfn_pmd(page_to_pfn(page), (pgprot))
 
