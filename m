Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0FPJQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 05:16:31 -0400
Received: from verein.lst.de ([213.95.11.210]:51290 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab0FPJQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 05:16:30 -0400
Date: Wed, 16 Jun 2010 11:16:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86-32: remove CONFIG_4KSTACKS
Message-ID: <20100616091621.GA4486@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These days 4 kilobytes of stack just aren't enough for reliably operation,
and people using lots of threads have long switched to x86-64, so remove the
CONFIG_4KSTACKS option.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/x86/Kconfig.debug
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig.debug	2010-06-16 10:24:06.902272433 +0200
+++ linux-2.6/arch/x86/Kconfig.debug	2010-06-16 10:24:11.837068354 +0200
@@ -121,15 +121,6 @@ config DEBUG_NX_TEST
 	  and the software setup of this feature.
 	  If in doubt, say "N"
 
-config 4KSTACKS
-	bool "Use 4Kb for kernel stacks instead of 8Kb"
-	depends on X86_32
-	---help---
-	  If you say Y here the kernel will use a 4Kb stacksize for the
-	  kernel stack attached to each process/thread. This facilitates
-	  running more threads on a system and also reduces the pressure
-	  on the VM subsystem for higher order allocations.
-
 config DOUBLEFAULT
 	default y
 	bool "Enable doublefault exception handler" if EMBEDDED
Index: linux-2.6/arch/x86/include/asm/module.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/module.h	2010-06-16 10:24:06.922004449 +0200
+++ linux-2.6/arch/x86/include/asm/module.h	2010-06-16 10:24:23.255291640 +0200
@@ -60,12 +60,7 @@
 #endif
 
 #ifdef CONFIG_X86_32
-# ifdef CONFIG_4KSTACKS
-#  define MODULE_STACKSIZE "4KSTACKS "
-# else
-#  define MODULE_STACKSIZE ""
-# endif
-# define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY MODULE_STACKSIZE
+# define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY
 #endif
 
 #endif /* _ASM_X86_MODULE_H */
Index: linux-2.6/arch/x86/include/asm/page_32_types.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/page_32_types.h	2010-06-16 10:24:06.933273132 +0200
+++ linux-2.6/arch/x86/include/asm/page_32_types.h	2010-06-16 10:24:30.251005496 +0200
@@ -15,11 +15,7 @@
  */
 #define __PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
 
-#ifdef CONFIG_4KSTACKS
-#define THREAD_ORDER	0
-#else
 #define THREAD_ORDER	1
-#endif
 #define THREAD_SIZE 	(PAGE_SIZE << THREAD_ORDER)
 
 #define STACKFAULT_STACK 0
