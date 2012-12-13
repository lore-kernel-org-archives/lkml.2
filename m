Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab2LMIhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 03:37:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60705 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab2LMIhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 03:37:33 -0500
Date: Thu, 13 Dec 2012 00:36:54 -0800
From: tip-bot for Stephen Rothwell <sfr@canb.auug.org.au>
Message-ID: <tip-8df383108f7b7eafcf89f26be5460b404c70ff29@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, peterz@infradead.org, sfr@canb.auug.org.au,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, peterz@infradead.org, tglx@linutronix.de,
        sfr@canb.auug.org.au
In-Reply-To: <20121210195402.1042a8ea5bfb57bb758007ac@canb.auug.org.au>
References: <20121210195402.1042a8ea5bfb57bb758007ac@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] mm/migrate: Fix update_mmu_cache_pmd() use
Git-Commit-ID: 8df383108f7b7eafcf89f26be5460b404c70ff29
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 13 Dec 2012 00:36:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8df383108f7b7eafcf89f26be5460b404c70ff29
Gitweb:     http://git.kernel.org/tip/8df383108f7b7eafcf89f26be5460b404c70ff29
Author:     Stephen Rothwell <sfr@canb.auug.org.au>
AuthorDate: Mon, 10 Dec 2012 19:54:02 +1100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 10 Dec 2012 13:37:30 +0100

mm/migrate: Fix update_mmu_cache_pmd() use

Stephen Rothwell reported this linux-next build failure:

  mm/migrate.c: In function 'migrate_misplaced_transhuge_page_put':
  mm/migrate.c:1666:2: error: incompatible type for argument 3 of 'update_mmu_cache_pmd'

Caused by commit 7f7f03ce3820 ("mm, numa: Implement
migrate-on-fault lazy NUMA strategy for regular and THP pages")
from the tip tree and exposed by commit "x86: convert
update_mmu_cache() and update_mmu_cache_pmd() to functions" from
the akpm tree.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20121210195402.1042a8ea5bfb57bb758007ac@canb.auug.org.au
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 9562fa8..d599657 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1625,7 +1625,7 @@ int migrate_misplaced_transhuge_page_put(struct mm_struct *mm,
 	page_add_new_anon_rmap(new_page, vma, haddr);
 
 	set_pmd_at(mm, haddr, pmd, entry);
-	update_mmu_cache_pmd(vma, address, entry);
+	update_mmu_cache_pmd(vma, address, &entry);
 	page_remove_rmap(page);
 	/*
 	 * Finish the charge transaction under the page table lock to
