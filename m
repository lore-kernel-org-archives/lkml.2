Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2EEPFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:05:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:33138 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab2EEPFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:44 -0400
Message-Id: <20120505150141.751600045@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 08/18] frv: Use common threadinfo allocator
References: <20120505150007.543515803@linutronix.de>
Content-Disposition: inline; filename=frv-use-common-threadinfo-allocator.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core now has a threadinfo allocator which uses a kmemcache when
THREAD_SIZE < PAGE_SIZE.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/include/asm/thread_info.h |   13 -------------
 1 file changed, 13 deletions(-)

Index: tip/arch/frv/include/asm/thread_info.h
===================================================================
--- tip.orig/arch/frv/include/asm/thread_info.h
+++ tip/arch/frv/include/asm/thread_info.h
@@ -80,19 +80,6 @@ register struct thread_info *__current_t
 
 #define current_thread_info() ({ __current_thread_info; })
 
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
-#define free_thread_info(info)	kfree(info)
-
 #endif /* __ASSEMBLY__ */
 
 /*


