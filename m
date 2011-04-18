Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab1DRQsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:48:52 -0400
Received: from diomedes.noc.ntua.gr ([147.102.222.220]:49498 "EHLO
	diomedes.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab1DRQsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:48:39 -0400
From: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org,
        Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
Subject: [PATCH 1/1] ppc64: fix build error when compiling with gcc-4.6.0
Date: Mon, 18 Apr 2011 19:38:59 +0300
Message-Id: <1303144739-4407-2-git-send-email-psomas@cslab.ece.ntua.gr>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303144739-4407-1-git-send-email-psomas@cslab.ece.ntua.gr>
References: <1303144739-4407-1-git-send-email-psomas@cslab.ece.ntua.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (diomedes.noc.ntua.gr [147.102.222.220]); Mon, 18 Apr 2011 19:39:14 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

variable 'old' is set but not used, which results to a warning
(-Werror=unused-but-set-variable) when compiling with gcc-4.6.0, and subsequent
build failure.
Remove the variable 'old', since it's not used anyway.

---
 arch/powerpc/include/asm/pgtable-ppc64.h |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/pgtable-ppc64.h b/arch/powerpc/include/asm/pgtable-ppc64.h
index 2b09cd5..a49d592 100644
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
+  		return;
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
1.7.4.1

