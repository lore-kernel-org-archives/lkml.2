Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab2EEPH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:07:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:33165 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab2EEPFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:47 -0400
Message-Id: <20120505150142.123383955@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Lennox Wu <lennox.wu@gmail.com>
Subject: [patch 14/18] score: Use common threadinfo allocator
References: <20120505150007.543515803@linutronix.de>
Content-Disposition: inline;
 filename=score-use-common-threadinfo-allocator.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point in using kmalloc for allocating 2 pages.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Lennox Wu <lennox.wu@gmail.com> 
---
 arch/score/include/asm/thread_info.h |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

Index: tip/arch/score/include/asm/thread_info.h
===================================================================
--- tip.orig/arch/score/include/asm/thread_info.h
+++ tip/arch/score/include/asm/thread_info.h
@@ -11,10 +11,9 @@
 #include <linux/const.h>
 
 /* thread information allocation */
-#define THREAD_SIZE_ORDER 	(1)
-#define THREAD_SIZE 		(PAGE_SIZE << THREAD_SIZE_ORDER)
-#define THREAD_MASK 		(THREAD_SIZE - _AC(1,UL))
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+#define THREAD_SIZE_ORDER	(1)
+#define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
+#define THREAD_MASK		(THREAD_SIZE - _AC(1,UL))
 
 #ifndef __ASSEMBLY__
 
@@ -71,9 +70,6 @@ struct thread_info {
 register struct thread_info *__current_thread_info __asm__("r28");
 #define current_thread_info()	__current_thread_info
 
-#define alloc_thread_info_node(tsk, node) kmalloc_node(THREAD_SIZE, GFP_KERNEL, node)
-#define free_thread_info(info) kfree(info)
-
 #endif /* !__ASSEMBLY__ */
 
 #define PREEMPT_ACTIVE		0x10000000


