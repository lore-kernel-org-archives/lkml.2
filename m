Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab0KCGob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 02:44:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:10375 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab0KCGo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 02:44:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,287,1286175600"; 
   d="scan'208";a="623027062"
Subject: [RFC 2/4]x86: allocate 32 tlb_invalidate_interrupt handlers
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 14:44:21 +0800
Message-ID: <1288766661.23014.115.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add up to 32 invalidate_interrupt handler. How many handlers are
added depends on NUM_INVALIDATE_TLB_VECTORS. So if NUM_INVALIDATE_TLB_VECTORS
is smaller than 32, we don't waste icache.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 arch/x86/include/asm/entry_arch.h |    5 +-
 arch/x86/include/asm/hw_irq.h     |   24 +++++++++++
 arch/x86/kernel/entry_64.S        |    5 +-
 arch/x86/kernel/irqinit.c         |   79 ++++++++++++++++++++++++++++++++++----
 4 files changed, 103 insertions(+), 10 deletions(-)

Index: linux/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux.orig/arch/x86/include/asm/hw_irq.h	2010-11-02 10:31:51.000000000 +0800
+++ linux/arch/x86/include/asm/hw_irq.h	2010-11-02 14:43:38.000000000 +0800
@@ -45,6 +45,30 @@ extern void invalidate_interrupt4(void);
 extern void invalidate_interrupt5(void);
 extern void invalidate_interrupt6(void);
 extern void invalidate_interrupt7(void);
+extern void invalidate_interrupt8(void);
+extern void invalidate_interrupt9(void);
+extern void invalidate_interrupt10(void);
+extern void invalidate_interrupt11(void);
+extern void invalidate_interrupt12(void);
+extern void invalidate_interrupt13(void);
+extern void invalidate_interrupt14(void);
+extern void invalidate_interrupt15(void);
+extern void invalidate_interrupt16(void);
+extern void invalidate_interrupt17(void);
+extern void invalidate_interrupt18(void);
+extern void invalidate_interrupt19(void);
+extern void invalidate_interrupt20(void);
+extern void invalidate_interrupt21(void);
+extern void invalidate_interrupt22(void);
+extern void invalidate_interrupt23(void);
+extern void invalidate_interrupt24(void);
+extern void invalidate_interrupt25(void);
+extern void invalidate_interrupt26(void);
+extern void invalidate_interrupt27(void);
+extern void invalidate_interrupt28(void);
+extern void invalidate_interrupt29(void);
+extern void invalidate_interrupt30(void);
+extern void invalidate_interrupt31(void);
 
 extern void irq_move_cleanup_interrupt(void);
 extern void reboot_interrupt(void);
Index: linux/arch/x86/kernel/irqinit.c
===================================================================
--- linux.orig/arch/x86/kernel/irqinit.c	2010-11-02 10:31:51.000000000 +0800
+++ linux/arch/x86/kernel/irqinit.c	2010-11-02 14:43:38.000000000 +0800
@@ -164,14 +164,77 @@ static void __init smp_intr_init(void)
 	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
 
 	/* IPIs for invalidation */
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+0, invalidate_interrupt0);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+1, invalidate_interrupt1);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+2, invalidate_interrupt2);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+3, invalidate_interrupt3);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+4, invalidate_interrupt4);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+5, invalidate_interrupt5);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+6, invalidate_interrupt6);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+7, invalidate_interrupt7);
+#define ALLOC_INVTLB_VEC(NR) \
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+NR, \
+		invalidate_interrupt##NR)
+
+	switch (NUM_INVALIDATE_TLB_VECTORS) {
+	default:
+		ALLOC_INVTLB_VEC(31);
+	case 31:
+		ALLOC_INVTLB_VEC(30);
+	case 30:
+		ALLOC_INVTLB_VEC(29);
+	case 29:
+		ALLOC_INVTLB_VEC(28);
+	case 28:
+		ALLOC_INVTLB_VEC(27);
+	case 27:
+		ALLOC_INVTLB_VEC(26);
+	case 26:
+		ALLOC_INVTLB_VEC(25);
+	case 25:
+		ALLOC_INVTLB_VEC(24);
+	case 24:
+		ALLOC_INVTLB_VEC(23);
+	case 23:
+		ALLOC_INVTLB_VEC(22);
+	case 22:
+		ALLOC_INVTLB_VEC(21);
+	case 21:
+		ALLOC_INVTLB_VEC(20);
+	case 20:
+		ALLOC_INVTLB_VEC(19);
+	case 19:
+		ALLOC_INVTLB_VEC(18);
+	case 18:
+		ALLOC_INVTLB_VEC(17);
+	case 17:
+		ALLOC_INVTLB_VEC(16);
+	case 16:
+		ALLOC_INVTLB_VEC(15);
+	case 15:
+		ALLOC_INVTLB_VEC(14);
+	case 14:
+		ALLOC_INVTLB_VEC(13);
+	case 13:
+		ALLOC_INVTLB_VEC(12);
+	case 12:
+		ALLOC_INVTLB_VEC(11);
+	case 11:
+		ALLOC_INVTLB_VEC(10);
+	case 10:
+		ALLOC_INVTLB_VEC(9);
+	case 9:
+		ALLOC_INVTLB_VEC(8);
+	case 8:
+		ALLOC_INVTLB_VEC(7);
+	case 7:
+		ALLOC_INVTLB_VEC(6);
+	case 6:
+		ALLOC_INVTLB_VEC(5);
+	case 5:
+		ALLOC_INVTLB_VEC(4);
+	case 4:
+		ALLOC_INVTLB_VEC(3);
+	case 3:
+		ALLOC_INVTLB_VEC(2);
+	case 2:
+		ALLOC_INVTLB_VEC(1);
+	case 1:
+		ALLOC_INVTLB_VEC(0);
+		break;
+	}
 
 	/* IPI for generic function call */
 	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
Index: linux/arch/x86/include/asm/entry_arch.h
===================================================================
--- linux.orig/arch/x86/include/asm/entry_arch.h	2010-11-02 10:31:51.000000000 +0800
+++ linux/arch/x86/include/asm/entry_arch.h	2010-11-02 14:43:38.000000000 +0800
@@ -16,10 +16,13 @@ BUILD_INTERRUPT(call_function_single_int
 BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
 BUILD_INTERRUPT(reboot_interrupt,REBOOT_VECTOR)
 
-.irpc idx, "01234567"
+.irp idx,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
+	16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+.if NUM_INVALIDATE_TLB_VECTORS > \idx
 BUILD_INTERRUPT3(invalidate_interrupt\idx,
 		 (INVALIDATE_TLB_VECTOR_START)+\idx,
 		 smp_invalidate_interrupt)
+.endif
 .endr
 #endif
 
Index: linux/arch/x86/kernel/entry_64.S
===================================================================
--- linux.orig/arch/x86/kernel/entry_64.S	2010-11-02 10:31:51.000000000 +0800
+++ linux/arch/x86/kernel/entry_64.S	2010-11-02 14:43:38.000000000 +0800
@@ -963,9 +963,12 @@ apicinterrupt X86_PLATFORM_IPI_VECTOR \
 	x86_platform_ipi smp_x86_platform_ipi
 
 #ifdef CONFIG_SMP
-.irpc idx, "01234567"
+.irp idx,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
+	16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+.if NUM_INVALIDATE_TLB_VECTORS > \idx
 apicinterrupt (INVALIDATE_TLB_VECTOR_START)+\idx \
 	invalidate_interrupt\idx smp_invalidate_interrupt
+.endif
 .endr
 #endif
 


