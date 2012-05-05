Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2EEPFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:05:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:33176 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab2EEPFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:49 -0400
Message-Id: <20120505150142.252861878@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Subject: [patch 16/18] sparc: Use common threadinfo allocator
References: <20120505150007.543515803@linutronix.de>
Content-Disposition: inline;
 filename=sparc-use-common-threadinfo-allocator.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exaclty the same as the core code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
---
 arch/sparc/include/asm/thread_info_64.h |   25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

Index: tip/arch/sparc/include/asm/thread_info_64.h
===================================================================
--- tip.orig/arch/sparc/include/asm/thread_info_64.h
+++ tip/arch/sparc/include/asm/thread_info_64.h
@@ -138,32 +138,11 @@ register struct thread_info *current_thr
 
 /* thread information allocation */
 #if PAGE_SHIFT == 13
-#define __THREAD_INFO_ORDER	1
+#define THREAD_SIZE_ORDER	1
 #else /* PAGE_SHIFT == 13 */
-#define __THREAD_INFO_ORDER	0
+#define THREAD_SIZE_ORDER	0
 #endif /* PAGE_SHIFT == 13 */
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define THREAD_FLAGS (GFP_KERNEL | __GFP_ZERO)
-#else
-#define THREAD_FLAGS (GFP_KERNEL)
-#endif
-
-#define alloc_thread_info_node(tsk, node)				\
-({									\
-	struct page *page = alloc_pages_node(node, THREAD_FLAGS,	\
-					     __THREAD_INFO_ORDER);	\
-	struct thread_info *ret;					\
-									\
-	ret = page ? page_address(page) : NULL;				\
-	ret;								\
-})
-
-#define free_thread_info(ti) \
-	free_pages((unsigned long)(ti),__THREAD_INFO_ORDER)
-
 #define __thread_flag_byte_ptr(ti)	\
 	((unsigned char *)(&((ti)->flags)))
 #define __cur_thread_flag_byte_ptr	__thread_flag_byte_ptr(current_thread_info())


