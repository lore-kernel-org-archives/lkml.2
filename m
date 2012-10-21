Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab2JUPV0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 11:21:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49703 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab2JUPVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 11:21:25 -0400
Date: Sun, 21 Oct 2012 08:21:13 -0700
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-9e1696b792d97b7fea2d650d4d7a42a92e85c4b0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] numa, mm:
  Remove paranoia checks from do_huge_pmd_numa_page()
Git-Commit-ID: 9e1696b792d97b7fea2d650d4d7a42a92e85c4b0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 21 Oct 2012 08:21:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e1696b792d97b7fea2d650d4d7a42a92e85c4b0
Gitweb:     http://git.kernel.org/tip/9e1696b792d97b7fea2d650d4d7a42a92e85c4b0
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Sun, 21 Oct 2012 16:32:33 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 21 Oct 2012 16:32:33 +0200

numa, mm: Remove paranoia checks from do_huge_pmd_numa_page()

Remove a couple of debugging checks from do_huge_pmd_numa_page().

Cc: Rik van Riel <riel@redhat.com>
Cc: aarcange@redhat.com
Cc: a.p.zijlstra@chello.nl
Link: http://lkml.kernel.org/n/tip-nhyrhlt42RlghgatXyughvyi@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/huge_memory.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a8f6531..5aa935a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -782,10 +782,6 @@ unlock:
 	return;
 
 migrate:
-	WARN_ON(!(((unsigned long)page->mapping & PAGE_MAPPING_ANON)));
-	WARN_ON((((unsigned long)page->mapping & PAGE_MAPPING_KSM)));
-	BUG_ON(PageSwapCache(page));
-
 	spin_unlock(&mm->page_table_lock);
 
 	lock_page(page);
@@ -802,8 +798,6 @@ migrate:
 	    (GFP_TRANSHUGE | GFP_THISNODE) & ~__GFP_WAIT,
 	    HPAGE_PMD_ORDER);
 
-	WARN_ON(PageLRU(new_page));
-
 	if (!new_page)
 		goto alloc_fail;
 
