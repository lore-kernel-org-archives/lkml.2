Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2BPN1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:27:04 -0500
Received: from service87.mimecast.com ([91.220.42.44]:57132 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab2BPN1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:27:03 -0500
From: "Javi Merino" <javi.merino@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-c6x-dev@linux-c6x.org, microblaze-uclinux@itee.uq.edu.au,
        linux@openrisc.net, Javi Merino <javi.merino@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, Michal Simek <monstr@monstr.eu>,
        Jonas Bonn <jonas@southpole.se>, Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] Remove remaining bits of io_remap_page_range()
Date: Thu, 16 Feb 2012 13:26:15 +0000
Message-Id: <1329398775-11061-1-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 16 Feb 2012 13:27:05.0433 (UTC) FILETIME=[ACCAAC90:01CCECAE]
X-MC-Unique: 112021613270001801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q1GDR97p023849

"33bf561: feature removal of io_remap_page_range()" removed
io_remap_page_range(), but it still included in some arch header
files.  It has no in-tree users.

Signed-off-by: Javi Merino <javi.merino@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Randy Dunlap <rdunlap@xenotime.net>
---
 arch/arm/include/asm/pgtable-nommu.h  |    1 -
 arch/c6x/include/asm/pgtable.h        |    3 ---
 arch/microblaze/include/asm/pgtable.h |    2 --
 arch/openrisc/include/asm/pgtable.h   |    1 -
 4 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-nommu.h b/arch/arm/include/asm/pgtable-nommu.h
index ffc0e85..7ec60d6 100644
--- a/arch/arm/include/asm/pgtable-nommu.h
+++ b/arch/arm/include/asm/pgtable-nommu.h
@@ -79,7 +79,6 @@ extern unsigned int kobjsize(const void *objp);
  * No page table caches to initialise.
  */
 #define pgtable_cache_init()	do { } while (0)
-#define io_remap_page_range	remap_page_range
 #define io_remap_pfn_range	remap_pfn_range
 
 
diff --git a/arch/c6x/include/asm/pgtable.h b/arch/c6x/include/asm/pgtable.h
index 68c8af4..38a4312 100644
--- a/arch/c6x/include/asm/pgtable.h
+++ b/arch/c6x/include/asm/pgtable.h
@@ -73,9 +73,6 @@ extern unsigned long empty_zero_page;
 #define pgtable_cache_init()   do { } while (0)
 #define io_remap_pfn_range      remap_pfn_range
 
-#define io_remap_page_range(vma, vaddr, paddr, size, prot)		\
-		remap_pfn_range(vma, vaddr, (paddr) >> PAGE_SHIFT, size, prot)
-
 #include <asm-generic/pgtable.h>
 
 #endif /* _ASM_C6X_PGTABLE_H */
diff --git a/arch/microblaze/include/asm/pgtable.h b/arch/microblaze/include/asm/pgtable.h
index b2af423..44dc67a 100644
--- a/arch/microblaze/include/asm/pgtable.h
+++ b/arch/microblaze/include/asm/pgtable.h
@@ -543,8 +543,6 @@ extern unsigned long iopa(unsigned long addr);
 /* Needs to be defined here and not in linux/mm.h, as it is arch dependent */
 #define kern_addr_valid(addr)	(1)
 
-#define io_remap_page_range remap_page_range
-
 /*
  * No page table caches to initialise
  */
diff --git a/arch/openrisc/include/asm/pgtable.h b/arch/openrisc/include/asm/pgtable.h
index 043505d..14c900c 100644
--- a/arch/openrisc/include/asm/pgtable.h
+++ b/arch/openrisc/include/asm/pgtable.h
@@ -455,7 +455,6 @@ static inline void update_mmu_cache(struct vm_area_struct *vma,
  * No page table caches to initialise
  */
 #define pgtable_cache_init()		do { } while (0)
-#define io_remap_page_range		remap_page_range
 
 typedef pte_t *pte_addr_t;
 
-- 
1.7.0.4


