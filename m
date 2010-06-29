Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0F2KWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:22:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:50758 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250Ab0F2KWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:22:30 -0400
Date: Tue, 29 Jun 2010 10:22:07 GMT
From: tip-bot for Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, hch@lst.de,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       hch@lst.de, tglx@linutronix.de
In-Reply-To: <20100628121614.GB6605@lst.de>
References: <20100628121614.GB6605@lst.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86: Remove CONFIG_4KSTACKS
Message-ID: <tip-dcfa726280116dd31adad37da940f542663567d0@git.kernel.org>
Git-Commit-ID: dcfa726280116dd31adad37da940f542663567d0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 10:22:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dcfa726280116dd31adad37da940f542663567d0
Gitweb:     http://git.kernel.org/tip/dcfa726280116dd31adad37da940f542663567d0
Author:     Christoph Hellwig <hch@lst.de>
AuthorDate: Mon, 28 Jun 2010 14:16:14 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 29 Jun 2010 12:12:59 +0200

x86: Remove CONFIG_4KSTACKS

These days 4 kilobytes of stack just aren't enough for reliably operation,
and people using lots of threads have long switched to 64-bit kernels, so
remove the CONFIG_4KSTACKS option.

Signed-off-by: Christoph Hellwig <hch@lst.de>
LKML-Reference: <20100628121614.GB6605@lst.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/Kconfig.debug               |    9 ---------
 arch/x86/include/asm/module.h        |    7 +------
 arch/x86/include/asm/page_32_types.h |    4 ----
 3 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index badda8e..7f15308 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
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
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
index 3e2ce58..67763c5 100644
--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
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
diff --git a/arch/x86/include/asm/page_32_types.h b/arch/x86/include/asm/page_32_types.h
index 6f1b733..ade619f 100644
--- a/arch/x86/include/asm/page_32_types.h
+++ b/arch/x86/include/asm/page_32_types.h
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
