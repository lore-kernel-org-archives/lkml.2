Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab2EEPFn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:05:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:33116 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab2EEPFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:41 -0400
Message-Id: <20120505150141.306358267@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 01/18] fork: Remove the weak insanity
References: <20120505150007.543515803@linutronix.de>
Content-Disposition: inline; filename=fork-remove-the-weak-insanity.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We error out when compiling with gcc4.1.[01] as it miscompiles
__weak. The workaround with magic defines is not longer
necessary. Make it __weak again.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/sh/include/asm/thread_info.h  |    1 -
 arch/x86/include/asm/thread_info.h |    1 -
 kernel/fork.c                      |    8 +-------
 3 files changed, 1 insertion(+), 9 deletions(-)

Index: tip/arch/sh/include/asm/thread_info.h
===================================================================
--- tip.orig/arch/sh/include/asm/thread_info.h
+++ tip/arch/sh/include/asm/thread_info.h
@@ -98,7 +98,6 @@ static inline struct thread_info *curren
 extern struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node);
 extern void free_thread_info(struct thread_info *ti);
 extern void arch_task_cache_init(void);
-#define arch_task_cache_init arch_task_cache_init
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
 extern void init_thread_xstate(void);
 
Index: tip/arch/x86/include/asm/thread_info.h
===================================================================
--- tip.orig/arch/x86/include/asm/thread_info.h
+++ tip/arch/x86/include/asm/thread_info.h
@@ -284,6 +284,5 @@ static inline bool is_ia32_task(void)
 extern void arch_task_cache_init(void);
 extern void free_thread_info(struct thread_info *ti);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
-#define arch_task_cache_init arch_task_cache_init
 #endif
 #endif /* _ASM_X86_THREAD_INFO_H */
Index: tip/kernel/fork.c
===================================================================
--- tip.orig/kernel/fork.c
+++ tip/kernel/fork.c
@@ -203,13 +203,7 @@ void __put_task_struct(struct task_struc
 }
 EXPORT_SYMBOL_GPL(__put_task_struct);
 
-/*
- * macro override instead of weak attribute alias, to workaround
- * gcc 4.1.0 and 4.1.1 bugs with weak attribute and empty functions.
- */
-#ifndef arch_task_cache_init
-#define arch_task_cache_init()
-#endif
+void __init __weak arch_task_cache_init(void) { }
 
 void __init fork_init(unsigned long mempages)
 {


