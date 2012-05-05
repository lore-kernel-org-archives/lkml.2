Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2EEPFs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:05:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:33135 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab2EEPFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:44 -0400
Message-Id: <20120505150141.621728944@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mark Salter <msalter@redhat.com>
Subject: [patch 06/18] c6x: Use common threadinfo allocator
References: <20120505150007.543515803@linutronix.de>
Content-Disposition: inline; filename=c6x-use-common-threadinfo-allocator.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no functional difference. __get_free_pages() ends up calling
alloc_pages_node().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/thread_info.h |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

Index: tip/arch/c6x/include/asm/thread_info.h
===================================================================
--- tip.orig/arch/c6x/include/asm/thread_info.h
+++ tip/arch/c6x/include/asm/thread_info.h
@@ -20,11 +20,11 @@
 #ifdef CONFIG_4KSTACKS
 #define THREAD_SIZE		4096
 #define THREAD_SHIFT		12
-#define THREAD_ORDER		0
+#define THREAD_SIZE_ORDER	0
 #else
 #define THREAD_SIZE		8192
 #define THREAD_SHIFT		13
-#define THREAD_ORDER		1
+#define THREAD_SIZE_ORDER	1
 #endif
 
 #define THREAD_START_SP		(THREAD_SIZE - 8)
@@ -80,19 +80,6 @@ struct thread_info *current_thread_info(
 	return ti;
 }
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
-/* thread information allocation */
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define THREAD_FLAGS (GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
-#else
-#define THREAD_FLAGS (GFP_KERNEL | __GFP_NOTRACK)
-#endif
-
-#define alloc_thread_info_node(tsk, node)	\
-	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
-
-#define free_thread_info(ti)	free_pages((unsigned long) (ti), THREAD_ORDER)
 #define get_thread_info(ti)	get_task_struct((ti)->task)
 #define put_thread_info(ti)	put_task_struct((ti)->task)
 #endif /* __ASSEMBLY__ */


