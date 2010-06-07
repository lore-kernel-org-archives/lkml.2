Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab0FGLUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 07:20:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:41273 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab0FGLUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 07:20:34 -0400
Message-Id: <20100607111408.408542372@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 07 Jun 2010 13:07:16 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 22/28] sparc64: Add support for _PAGE_SPECIAL
References: <20100607110654.606530953@chello.nl>
Content-Disposition: inline; filename=davem-sparc64-Add_support_for__PAGE_SPECIA.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

Luckily there are still a few software PTE bits remaining
and they even match up in both the sun4u and sun4v pte
layouts.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100408.180010.76058269.davem@davemloft.net>
---
 arch/sparc/include/asm/pgtable_64.h |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/sparc/include/asm/pgtable_64.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/pgtable_64.h
+++ linux-2.6/arch/sparc/include/asm/pgtable_64.h
@@ -95,6 +95,10 @@
 /* PTE bits which are the same in SUN4U and SUN4V format.  */
 #define _PAGE_VALID	  _AC(0x8000000000000000,UL) /* Valid TTE            */
 #define _PAGE_R	  	  _AC(0x8000000000000000,UL) /* Keep ref bit uptodate*/
+#define _PAGE_SPECIAL     _AC(0x0200000000000000,UL) /* Special page         */
+
+/* Advertise support for _PAGE_SPECIAL */
+#define __HAVE_ARCH_PTE_SPECIAL
 
 /* SUN4U pte bits... */
 #define _PAGE_SZ4MB_4U	  _AC(0x6000000000000000,UL) /* 4MB Page             */
@@ -104,6 +108,7 @@
 #define _PAGE_NFO_4U	  _AC(0x1000000000000000,UL) /* No Fault Only        */
 #define _PAGE_IE_4U	  _AC(0x0800000000000000,UL) /* Invert Endianness    */
 #define _PAGE_SOFT2_4U	  _AC(0x07FC000000000000,UL) /* Software bits, set 2 */
+#define _PAGE_SPECIAL_4U  _AC(0x0200000000000000,UL) /* Special page         */
 #define _PAGE_RES1_4U	  _AC(0x0002000000000000,UL) /* Reserved             */
 #define _PAGE_SZ32MB_4U	  _AC(0x0001000000000000,UL) /* (Panther) 32MB page  */
 #define _PAGE_SZ256MB_4U  _AC(0x2001000000000000,UL) /* (Panther) 256MB page */
@@ -133,6 +138,7 @@
 #define _PAGE_ACCESSED_4V _AC(0x1000000000000000,UL) /* Accessed (ref'd)     */
 #define _PAGE_READ_4V	  _AC(0x0800000000000000,UL) /* Readable SW Bit      */
 #define _PAGE_WRITE_4V	  _AC(0x0400000000000000,UL) /* Writable SW Bit      */
+#define _PAGE_SPECIAL_4V  _AC(0x0200000000000000,UL) /* Special page         */
 #define _PAGE_PADDR_4V	  _AC(0x00FFFFFFFFFFE000,UL) /* paddr[55:13]         */
 #define _PAGE_IE_4V	  _AC(0x0000000000001000,UL) /* Invert Endianness    */
 #define _PAGE_E_4V	  _AC(0x0000000000000800,UL) /* side-Effect          */
@@ -302,10 +308,10 @@ static inline pte_t pte_modify(pte_t pte
 	: "=r" (mask), "=r" (tmp)
 	: "i" (_PAGE_PADDR_4U | _PAGE_MODIFIED_4U | _PAGE_ACCESSED_4U |
 	       _PAGE_CP_4U | _PAGE_CV_4U | _PAGE_E_4U | _PAGE_PRESENT_4U |
-	       _PAGE_SZBITS_4U),
+	       _PAGE_SZBITS_4U | _PAGE_SPECIAL),
 	  "i" (_PAGE_PADDR_4V | _PAGE_MODIFIED_4V | _PAGE_ACCESSED_4V |
 	       _PAGE_CP_4V | _PAGE_CV_4V | _PAGE_E_4V | _PAGE_PRESENT_4V |
-	       _PAGE_SZBITS_4V));
+	       _PAGE_SZBITS_4V | _PAGE_SPECIAL));
 
 	return __pte((pte_val(pte) & mask) | (pgprot_val(prot) & ~mask));
 }
@@ -502,6 +508,7 @@ static inline pte_t pte_mkyoung(pte_t pt
 
 static inline pte_t pte_mkspecial(pte_t pte)
 {
+	pte_val(pte) |= _PAGE_SPECIAL;
 	return pte;
 }
 
@@ -607,9 +614,9 @@ static inline unsigned long pte_present(
 	return val;
 }
 
-static inline int pte_special(pte_t pte)
+static inline unsigned long pte_special(pte_t pte)
 {
-	return 0;
+	return pte_val(pte) & _PAGE_SPECIAL;
 }
 
 #define pmd_set(pmdp, ptep)	\


