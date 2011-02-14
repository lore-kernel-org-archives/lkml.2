Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1BNSH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:07:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:45616 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab1BNSHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:07:24 -0500
Date: Mon, 14 Feb 2011 13:53:06 GMT
From: tip-bot for Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        eric.dumazet@gmail.com, andi@firstfloor.org, shaohua.li@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, eric.dumazet@gmail.com, tglx@linutronix.de,
        shaohua.li@intel.com, mingo@elte.hu
In-Reply-To: <1295232725.1949.708.camel@sli10-conroe>
References: <1295232725.1949.708.camel@sli10-conroe>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Allocate 32 tlb_invalidate_interrupt handler stubs
Message-ID: <tip-3a09fb4570a1cce11472b8e5da3f6ee409f529d5@git.kernel.org>
Git-Commit-ID: 3a09fb4570a1cce11472b8e5da3f6ee409f529d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Feb 2011 18:06:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a09fb4570a1cce11472b8e5da3f6ee409f529d5
Gitweb:     http://git.kernel.org/tip/3a09fb4570a1cce11472b8e5da3f6ee409f529d5
Author:     Shaohua Li <shaohua.li@intel.com>
AuthorDate: Mon, 17 Jan 2011 10:52:05 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Feb 2011 13:03:08 +0100

x86: Allocate 32 tlb_invalidate_interrupt handler stubs

Add up to 32 invalidate_interrupt handlers. How many handlers are
added depends on NUM_INVALIDATE_TLB_VECTORS. So if
NUM_INVALIDATE_TLB_VECTORS is smaller than 32, we reduce code
size.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
LKML-Reference: <1295232725.1949.708.camel@sli10-conroe>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/entry_arch.h |    5 ++-
 arch/x86/include/asm/hw_irq.h     |   24 +++++++++++
 arch/x86/kernel/entry_64.S        |    5 ++-
 arch/x86/kernel/irqinit.c         |   79 +++++++++++++++++++++++++++++++++----
 4 files changed, 103 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index 57650ab..1cd6d26 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -16,10 +16,13 @@ BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
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
 
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 0274ec5..bb9efe8 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
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
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index aed1ffb..891268c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -975,9 +975,12 @@ apicinterrupt X86_PLATFORM_IPI_VECTOR \
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
 
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index c752e97..7aad10a 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
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
