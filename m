Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab0G2P3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:29:17 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40078 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757842Ab0G2P3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:29:14 -0400
Date: Thu, 29 Jul 2010 17:29:12 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 3/3] Removing dead copy&paste code
Message-ID: <b9395c2aeb22a47833787494090774f38aa04f58.1280417117.git.siccegge@cs.fau.de>
References: <cover.1280417117.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1280417117.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch/um there's a lot of code that is copied from their original
arch (but out of sync) and contains code blocks that are either dead
because these options disappearedd or because the arch/x86 Kconfig
stuff doesn't reach arch/um.

X86_OOSTORE is a bit tricky because it's in itself seemingly available
on arch/um but depends on MTRR which isn't in arch/um.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/um/sys-i386/asm/archparam.h          |    4 ----
 arch/um/sys-i386/shared/sysdep/system.h   |   11 +----------
 arch/um/sys-ppc/misc.S                    |    6 ------
 arch/um/sys-x86_64/shared/sysdep/system.h |   10 +---------
 4 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/arch/um/sys-i386/asm/archparam.h b/arch/um/sys-i386/asm/archparam.h
index 2a18a88..b2072c9 100644
--- a/arch/um/sys-i386/asm/archparam.h
+++ b/arch/um/sys-i386/asm/archparam.h
@@ -6,11 +6,7 @@
 #ifndef __UM_ARCHPARAM_I386_H
 #define __UM_ARCHPARAM_I386_H
 
-#ifdef CONFIG_X86_PAE
-#define LAST_PKMAP 512
-#else
 #define LAST_PKMAP 1024
-#endif
 
 #endif
 
diff --git a/arch/um/sys-i386/shared/sysdep/system.h b/arch/um/sys-i386/shared/sysdep/system.h
index d1b93c4..be25c95 100644
--- a/arch/um/sys-i386/shared/sysdep/system.h
+++ b/arch/um/sys-i386/shared/sysdep/system.h
@@ -10,12 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/irqflags.h>
 
-/* entries in ARCH_DLINFO: */
-#ifdef CONFIG_IA32_EMULATION
-# define AT_VECTOR_SIZE_ARCH 2
-#else
-# define AT_VECTOR_SIZE_ARCH 1
-#endif
+#define AT_VECTOR_SIZE_ARCH 1
 
 extern unsigned long arch_align_stack(unsigned long sp);
 
@@ -101,11 +96,7 @@ void default_idle(void);
 #else
 # define smp_rmb()	barrier()
 #endif
-#ifdef CONFIG_X86_OOSTORE
-# define smp_wmb() 	wmb()
-#else
 # define smp_wmb()	barrier()
-#endif
 #define smp_read_barrier_depends()	read_barrier_depends()
 #define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
 #else
diff --git a/arch/um/sys-ppc/misc.S b/arch/um/sys-ppc/misc.S
index 1364b7d..962e4af 100644
--- a/arch/um/sys-ppc/misc.S
+++ b/arch/um/sys-ppc/misc.S
@@ -18,15 +18,9 @@
 #include <asm/processor.h>
 #include "ppc_asm.h"
 
-#if defined(CONFIG_4xx) || defined(CONFIG_8xx)
-#define CACHE_LINE_SIZE		16
-#define LG_CACHE_LINE_SIZE	4
-#define MAX_COPY_PREFETCH	1
-#else
 #define CACHE_LINE_SIZE		32
 #define LG_CACHE_LINE_SIZE	5
 #define MAX_COPY_PREFETCH	4
-#endif /* CONFIG_4xx || CONFIG_8xx */
 
 	.text
 
diff --git a/arch/um/sys-x86_64/shared/sysdep/system.h b/arch/um/sys-x86_64/shared/sysdep/system.h
index d1b93c4..511241f 100644
--- a/arch/um/sys-x86_64/shared/sysdep/system.h
+++ b/arch/um/sys-x86_64/shared/sysdep/system.h
@@ -11,11 +11,7 @@
 #include <linux/irqflags.h>
 
 /* entries in ARCH_DLINFO: */
-#ifdef CONFIG_IA32_EMULATION
-# define AT_VECTOR_SIZE_ARCH 2
-#else
-# define AT_VECTOR_SIZE_ARCH 1
-#endif
+#define AT_VECTOR_SIZE_ARCH 1
 
 extern unsigned long arch_align_stack(unsigned long sp);
 
@@ -101,11 +97,7 @@ void default_idle(void);
 #else
 # define smp_rmb()	barrier()
 #endif
-#ifdef CONFIG_X86_OOSTORE
-# define smp_wmb() 	wmb()
-#else
 # define smp_wmb()	barrier()
-#endif
 #define smp_read_barrier_depends()	read_barrier_depends()
 #define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
 #else
-- 
1.7.0.4

