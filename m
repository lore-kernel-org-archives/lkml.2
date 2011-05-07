Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1EGOLp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 10:11:45 -0400
Received: from diomedes.noc.ntua.gr ([147.102.222.220]:49362 "EHLO
	diomedes.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab1EGOLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 10:11:44 -0400
From: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ppc64: Fix compiler warning in pgtable-ppc64.h [-Wunused-but-set-variable]
Date: Sat,  7 May 2011 17:11:31 +0300
Message-Id: <1304777491-7947-3-git-send-email-psomas@cslab.ece.ntua.gr>
X-Mailer: git-send-email 1.7.5.rc3
In-Reply-To: <1304777491-7947-1-git-send-email-psomas@cslab.ece.ntua.gr>
References: <1304777491-7947-1-git-send-email-psomas@cslab.ece.ntua.gr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (diomedes.noc.ntua.gr [147.102.222.220]); Sat, 07 May 2011 17:11:36 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable 'old' is set but not used in the wrprotect functions in
arch/powerpc/include/asm/pgtable-ppc64.h, which can trigger a compiler warning.

Remove the variable, since it's not used anyway.

Signed-off-by: Stratos Psomadakis <psomas@ece.ntua.gr>
---
 arch/powerpc/include/asm/pgtable-ppc64.h |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/pgtable-ppc64.h b/arch/powerpc/include/asm/pgtable-ppc64.h
index 2b09cd5..0b27dba 100644
--- a/arch/powerpc/include/asm/pgtable-ppc64.h
+++ b/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -257,21 +257,20 @@ static inline int __ptep_test_and_clear_young(struct mm_struct *mm,
 static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 				      pte_t *ptep)
 {
-	unsigned long old;
 
-       	if ((pte_val(*ptep) & _PAGE_RW) == 0)
-       		return;
-	old = pte_update(mm, addr, ptep, _PAGE_RW, 0);
+	if ((pte_val(*ptep) & _PAGE_RW) == 0)
+		return;
+
+	pte_update(mm, addr, ptep, _PAGE_RW, 0);
 }
 
 static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
 					   unsigned long addr, pte_t *ptep)
 {
-	unsigned long old;
-
 	if ((pte_val(*ptep) & _PAGE_RW) == 0)
 		return;
-	old = pte_update(mm, addr, ptep, _PAGE_RW, 1);
+
+	pte_update(mm, addr, ptep, _PAGE_RW, 1);
 }
 
 /*
-- 
1.5.6.5

