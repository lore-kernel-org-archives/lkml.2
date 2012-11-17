Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab2KQFIh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 00:08:37 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50761 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab2KQFIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 00:08:36 -0500
MIME-Version: 1.0
Date: Sat, 17 Nov 2012 13:08:35 +0800
Message-ID: <CAJd=RBDOAxWeEbjoLvHAt3=P-w1St84oHhfQ5gGox+GoEBF_6A@mail.gmail.com>
Subject: [PATCH 1/5] balancenuma: fix typo in handling pmd numa fault
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/ptep/pmdp/

Also a cleanup packed: use haddr directly.

Btw, will spin if you no longer need the debug trap.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/huge_memory.c	Sat Nov 17 11:37:36 2012
+++ b/mm/huge_memory.c	Sat Nov 17 11:54:18 2012
@@ -1055,9 +1055,9 @@ clear_pmdnuma:
 		goto out_unlock;

 	pmd = pmd_mknonnuma(pmd);
-	set_pmd_at(mm, addr & HPAGE_PMD_MASK, pmdp, pmd);
+	set_pmd_at(mm, haddr, pmdp, pmd);
 	VM_BUG_ON(pmd_numa(*pmdp));
-	update_mmu_cache_pmd(vma, addr, ptep);
+	update_mmu_cache_pmd(vma, addr, pmdp);

 out_unlock:
 	spin_unlock(&mm->page_table_lock);
--
