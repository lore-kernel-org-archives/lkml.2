Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab1HRTFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:05:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44340 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab1HRTFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:05:40 -0400
Date: Thu, 18 Aug 2011 20:05:39 +0100
To: richard@nod.at
Subject: Subject: [PATCH 40/91] um: sysdep/barrier.h is not used for
 anything
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7uN-0007jc-JI@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/os-Linux/signal.c                  |    1 -
 arch/um/sys-x86/shared/sysdep/barrier.h    |    5 -----
 arch/um/sys-x86/shared/sysdep/barrier_32.h |    9 ---------
 arch/um/sys-x86/shared/sysdep/barrier_64.h |    7 -------
 4 files changed, 0 insertions(+), 22 deletions(-)
 delete mode 100644 arch/um/sys-x86/shared/sysdep/barrier.h
 delete mode 100644 arch/um/sys-x86/shared/sysdep/barrier_32.h
 delete mode 100644 arch/um/sys-x86/shared/sysdep/barrier_64.h

diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index 4d31688..2d22f1f 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -12,7 +12,6 @@
 #include "as-layout.h"
 #include "kern_util.h"
 #include "os.h"
-#include "sysdep/barrier.h"
 #include "sysdep/mcontext.h"
 
 void (*sig_info[NSIG])(int, struct uml_pt_regs *) = {
diff --git a/arch/um/sys-x86/shared/sysdep/barrier.h b/arch/um/sys-x86/shared/sysdep/barrier.h
deleted file mode 100644
index 89ee23b..0000000
--- a/arch/um/sys-x86/shared/sysdep/barrier.h
+++ /dev/null
@@ -1,5 +0,0 @@
-#ifdef __i386__
-#include "barrier_32.h"
-#else
-#include "barrier_64.h"
-#endif
diff --git a/arch/um/sys-x86/shared/sysdep/barrier_32.h b/arch/um/sys-x86/shared/sysdep/barrier_32.h
deleted file mode 100644
index b58d52c..0000000
--- a/arch/um/sys-x86/shared/sysdep/barrier_32.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef __SYSDEP_I386_BARRIER_H
-#define __SYSDEP_I386_BARRIER_H
-
-/* Copied from include/asm-i386 for use by userspace.  i386 has the option
- * of using mfence, but I'm just using this, which works everywhere, for now.
- */
-#define mb() asm volatile("lock; addl $0,0(%esp)")
-
-#endif
diff --git a/arch/um/sys-x86/shared/sysdep/barrier_64.h b/arch/um/sys-x86/shared/sysdep/barrier_64.h
deleted file mode 100644
index 7b610be..0000000
--- a/arch/um/sys-x86/shared/sysdep/barrier_64.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef __SYSDEP_X86_64_BARRIER_H
-#define __SYSDEP_X86_64_BARRIER_H
-
-/* Copied from include/asm-x86_64 for use by userspace. */
-#define mb() 	asm volatile("mfence":::"memory")
-
-#endif
-- 
1.7.2.5


