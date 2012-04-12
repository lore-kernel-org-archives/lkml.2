Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638Ab2DLRAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:00:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63445 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755795Ab2DLRAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:00:46 -0400
From: Will Deacon <will.deacon@arm.com>
To: hughd@google.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>
Subject: [PATCH] Revert "proc: clear_refs: do not clear reserved pages"
Date: Thu, 12 Apr 2012 18:00:34 +0100
Message-Id: <1334250034-29866-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 85e72aa5384b1a614563ad63257ded0e91d1a620, which was
a quick fix suitable for -stable until ARM had been moved over to the
gate_vma mechanism:

https://lkml.org/lkml/2012/1/14/55

With commit f9d4861f ("ARM: 7294/1: vectors: use gate_vma for vectors user
mapping"), ARM does now use the gate_vma, so the PageReserved check can
be removed from the proc code.

Cc: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 fs/proc/task_mmu.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 2b9a760..2d60492 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -597,9 +597,6 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		if (!page)
 			continue;
 
-		if (PageReserved(page))
-			continue;
-
 		/* Clear accessed and referenced bits. */
 		ptep_test_and_clear_young(vma, addr, pte);
 		ClearPageReferenced(page);
-- 
1.7.4.1

