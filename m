Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab1AQCwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 21:52:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:19528 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab1AQCwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 21:52:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,332,1291622400"; 
   d="scan'208";a="697468959"
Subject: [PATCH 1/4]x86: cleanup vector usage
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 10:52:02 +0800
Message-ID: <1295232722.1949.707.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the vector usage and make them continuous if possible.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 arch/x86/include/asm/irq_vectors.h |   40 +++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

Index: linux/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux.orig/arch/x86/include/asm/irq_vectors.h	2010-11-02 10:31:51.000000000 +0800
+++ linux/arch/x86/include/asm/irq_vectors.h	2010-11-02 14:41:01.000000000 +0800
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_IRQ_VECTORS_H
 #define _ASM_X86_IRQ_VECTORS_H
 
+#include <linux/threads.h>
 /*
  * Linux IRQ vector layout.
  *
@@ -16,8 +17,8 @@
  *  Vectors   0 ...  31 : system traps and exceptions - hardcoded events
  *  Vectors  32 ... 127 : device interrupts
  *  Vector  128         : legacy int80 syscall interface
- *  Vectors 129 ... 237 : device interrupts
- *  Vectors 238 ... 255 : special interrupts
+ *  Vectors 129 ... 229 : device interrupts
+ *  Vectors 230 ... 255 : special interrupts
  *
  * 64-bit x86 has per CPU IDT tables, 32-bit has one shared IDT table.
  *
@@ -96,37 +97,38 @@
 #define THRESHOLD_APIC_VECTOR		0xf9
 #define REBOOT_VECTOR			0xf8
 
-/* f0-f7 used for spreading out TLB flushes: */
-#define INVALIDATE_TLB_VECTOR_END	0xf7
-#define INVALIDATE_TLB_VECTOR_START	0xf0
-#define NUM_INVALIDATE_TLB_VECTORS	   8
-
-/*
- * Local APIC timer IRQ vector is on a different priority level,
- * to work around the 'lost local interrupt if more than 2 IRQ
- * sources per level' errata.
- */
-#define LOCAL_TIMER_VECTOR		0xef
-
 /*
  * Generic system vector for platform specific use
  */
-#define X86_PLATFORM_IPI_VECTOR		0xed
+#define X86_PLATFORM_IPI_VECTOR		0xf7
 
 /*
  * IRQ work vector:
  */
-#define IRQ_WORK_VECTOR			0xec
+#define IRQ_WORK_VECTOR			0xf6
 
-#define UV_BAU_MESSAGE			0xea
+#define UV_BAU_MESSAGE			0xf5
 
 /*
  * Self IPI vector for machine checks
  */
-#define MCE_SELF_VECTOR			0xeb
+#define MCE_SELF_VECTOR			0xf4
 
 /* Xen vector callback to receive events in a HVM domain */
-#define XEN_HVM_EVTCHN_CALLBACK		0xe9
+#define XEN_HVM_EVTCHN_CALLBACK		0xf3
+
+/*
+ * Local APIC timer IRQ vector is on a different priority level,
+ * to work around the 'lost local interrupt if more than 2 IRQ
+ * sources per level' errata.
+ */
+#define LOCAL_TIMER_VECTOR		0xef
+
+/* f0-f7 used for spreading out TLB flushes: */
+#define NUM_INVALIDATE_TLB_VECTORS	   8
+#define INVALIDATE_TLB_VECTOR_END	0xee
+#define INVALIDATE_TLB_VECTOR_START	\
+	(INVALIDATE_TLB_VECTOR_END - NUM_INVALIDATE_TLB_VECTORS + 1)
 
 #define NR_VECTORS			 256
 


