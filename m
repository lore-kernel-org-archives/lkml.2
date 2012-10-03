Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab2JCC7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 22:59:45 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51850 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab2JCC7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 22:59:44 -0400
Message-ID: <506BAA1B.4090803@linux.vnet.ibm.com>
Date: Tue, 02 Oct 2012 21:59:39 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: devicetree-discuss@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 5/5] Remove the pSeries_reconfig.h file
References: <506B2E63.5090900@linux.vnet.ibm.com>
In-Reply-To: <506B2E63.5090900@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12100302-8974-0000-0000-00000EDD39FF
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00179335; UDB=6.00040614; UTC=2012-10-03
 02:59:42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the pSeries_reconfig.h header file. At this point there is only one
definition in the file, pSeries_coalesce_init(), which can be
moved to rtas.h.

Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/pSeries_reconfig.h |   15 ---------------
 arch/powerpc/include/asm/rtas.h             |    5 +++++
 arch/powerpc/kernel/rtas.c                  |    1 -
 arch/powerpc/platforms/pseries/smp.c        |    1 -
 4 files changed, 5 insertions(+), 17 deletions(-)

Index: dt-next/arch/powerpc/include/asm/pSeries_reconfig.h
===================================================================
--- dt-next.orig/arch/powerpc/include/asm/pSeries_reconfig.h	2012-10-02 09:14:01.000000000 -0500
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,15 +0,0 @@
-#ifndef _PPC64_PSERIES_RECONFIG_H
-#define _PPC64_PSERIES_RECONFIG_H
-#ifdef __KERNEL__
-
-#ifdef CONFIG_PPC_PSERIES
-/* Not the best place to put this, will be fixed when we move some
- * of the rtas suspend-me stuff to pseries */
-extern void pSeries_coalesce_init(void);
-#else /* !CONFIG_PPC_PSERIES */
-static inline void pSeries_coalesce_init(void) { }
-#endif /* CONFIG_PPC_PSERIES */
-
-
-#endif /* __KERNEL__ */
-#endif /* _PPC64_PSERIES_RECONFIG_H */
Index: dt-next/arch/powerpc/include/asm/rtas.h
===================================================================
--- dt-next.orig/arch/powerpc/include/asm/rtas.h	2012-10-02 09:14:01.000000000 -0500
+++ dt-next/arch/powerpc/include/asm/rtas.h	2012-10-02 09:14:40.000000000 -0500
@@ -353,8 +353,13 @@
 		return 1;
 	return 0;
 }
+
+/* Not the best place to put pSeries_coalesce_init, will be fixed when we
+ * move some of the rtas suspend-me stuff to pseries */
+extern void pSeries_coalesce_init(void);
 #else
 static inline int page_is_rtas_user_buf(unsigned long pfn) { return 0;}
+static inline void pSeries_coalesce_init(void) { }
 #endif
 
 extern int call_rtas(const char *, int, int, unsigned long *, ...);
Index: dt-next/arch/powerpc/kernel/rtas.c
===================================================================
--- dt-next.orig/arch/powerpc/kernel/rtas.c	2012-10-02 09:14:01.000000000 -0500
+++ dt-next/arch/powerpc/kernel/rtas.c	2012-10-02 09:14:40.000000000 -0500
@@ -42,7 +42,6 @@
 #include <asm/time.h>
 #include <asm/mmu.h>
 #include <asm/topology.h>
-#include <asm/pSeries_reconfig.h>
 
 struct rtas_t rtas = {
 	.lock = __ARCH_SPIN_LOCK_UNLOCKED
Index: dt-next/arch/powerpc/platforms/pseries/smp.c
===================================================================
--- dt-next.orig/arch/powerpc/platforms/pseries/smp.c	2012-10-02 09:14:01.000000000 -0500
+++ dt-next/arch/powerpc/platforms/pseries/smp.c	2012-10-02 09:14:40.000000000 -0500
@@ -38,7 +38,6 @@
 #include <asm/cputable.h>
 #include <asm/firmware.h>
 #include <asm/rtas.h>
-#include <asm/pSeries_reconfig.h>
 #include <asm/mpic.h>
 #include <asm/vdso_datapage.h>
 #include <asm/cputhreads.h>

