Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2EEPIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:08:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:33153 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab2EEPFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:46 -0400
Message-Id: <20120505150141.875430830@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Subject: [patch 10/18] m32r: Use common threadinfo allocator
References: <20120505150007.543515803@linutronix.de>
Content-Disposition: inline;
 filename=m32r-use-common-threadinfo-allocator.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No reason why m32r needs to use kmalloc to allocate 2 pages instead of
using the core allocator.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/include/asm/thread_info.h |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

Index: tip/arch/m32r/include/asm/thread_info.h
===================================================================
--- tip.orig/arch/m32r/include/asm/thread_info.h
+++ tip/arch/m32r/include/asm/thread_info.h
@@ -55,8 +55,8 @@ struct thread_info {
 
 #define PREEMPT_ACTIVE		0x10000000
 
-#define THREAD_SIZE (PAGE_SIZE << 1)
-
+#define THREAD_SIZE		(PAGE_SIZE << 1)
+#define THREAD_SIZE_ORDER	1
 /*
  * macros/functions for gaining access to the thread information structure
  */
@@ -92,19 +92,6 @@ static inline struct thread_info *curren
 	return ti;
 }
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
-/* thread information allocation */
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info_node(tsk, node)			\
-		kzalloc_node(THREAD_SIZE, GFP_KERNEL, node)
-#else
-#define alloc_thread_info_node(tsk, node)			\
-		kmalloc_node(THREAD_SIZE, GFP_KERNEL, node)
-#endif
-
-#define free_thread_info(info) kfree(info)
-
 #define TI_FLAG_FAULT_CODE_SHIFT	28
 
 static inline void set_thread_fault_code(unsigned int val)


