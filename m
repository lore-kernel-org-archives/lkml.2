Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935460Ab1ETJNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:13:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:40048 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935448Ab1ETJNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:13:51 -0400
Date: Fri, 20 May 2011 11:13:46 +0200
From: Marcus Meissner <meissner@suse.de>
To: benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: PATCH: powerpc: remove unused variable assignment
Message-ID: <20110520091346.GC29499@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendoerffer, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

gcc 4.6 with -Werror does not like setting but not using variables
anymore.

So remove it, it does not seem necessary.

Signed-off-by: Marcus Meissner <meissner@suse.de>

Ciao, Marcus
---
 arch/powerpc/include/asm/pgtable-ppc64.h |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/pgtable-ppc64.h b/arch/powerpc/include/asm/pgtable-ppc64.h
index 2b09cd5..c3d39de 100644
--- a/arch/powerpc/include/asm/pgtable-ppc64.h
+++ b/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -257,21 +257,17 @@ static inline int __ptep_test_and_clear_young(struct mm_struct *mm,
 static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 				      pte_t *ptep)
 {
-	unsigned long old;
-
        	if ((pte_val(*ptep) & _PAGE_RW) == 0)
        		return;
-	old = pte_update(mm, addr, ptep, _PAGE_RW, 0);
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
+	pte_update(mm, addr, ptep, _PAGE_RW, 1);
 }
 
 /*
-- 
1.7.4.1

