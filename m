Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab0IBKWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 06:22:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab0IBKWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 06:22:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/3] M68K: Use CONFIG_MMU not __uClinux__ to select m68knommu
	contributions
To: gerg@snapgear.com
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 02 Sep 2010 11:21:58 +0100
Message-ID: <20100902102158.19806.14133.stgit@warthog.procyon.org.uk>
In-Reply-To: <19747.1283422807@redhat.com>
References: <19747.1283422807@redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use CONFIG_MMU not __uClinux__ to select m68knommu contributions as nothing in
the arch defines __uClinux__ for the build.

This patch was achieved by running the following three commands:

perl -pi -e 's/ifdef __uClinux__/ifndef CONFIG_MMU/' `find arch/m68k -name "*.[ch]"`
perl -pi -e 's/ifndef __uClinux__/ifdef CONFIG_MMU/' `find arch/m68k -name "*.[ch]"`
perl -pi -e 's!endif /[*] __uClinux__ [*]/!endif /* CONFIG_MMU */!' `find arch/m68k -name "*.[ch]"

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/m68k/include/asm/atomic.h      |    2 +-
 arch/m68k/include/asm/bitops.h      |    2 +-
 arch/m68k/include/asm/cacheflush.h  |    2 +-
 arch/m68k/include/asm/delay.h       |    2 +-
 arch/m68k/include/asm/entry.h       |    2 +-
 arch/m68k/include/asm/hardirq.h     |    2 +-
 arch/m68k/include/asm/io.h          |    2 +-
 arch/m68k/include/asm/machdep.h     |    2 +-
 arch/m68k/include/asm/page.h        |    2 +-
 arch/m68k/include/asm/param.h       |    2 +-
 arch/m68k/include/asm/pgtable.h     |    2 +-
 arch/m68k/include/asm/sigcontext.h  |    4 ++--
 arch/m68k/include/asm/signal.h      |    4 ++--
 arch/m68k/include/asm/string.h      |    2 +-
 arch/m68k/include/asm/system.h      |    2 +-
 arch/m68k/include/asm/thread_info.h |    2 +-
 arch/m68k/include/asm/traps.h       |    2 +-
 arch/m68k/include/asm/uaccess.h     |    2 +-
 18 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/m68k/include/asm/atomic.h b/arch/m68k/include/asm/atomic.h
index eab36dc..eec8b50 100644
--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -1,4 +1,4 @@
-#ifdef __uClinux__
+#ifndef CONFIG_MMU
 #include "atomic_no.h"
 #else
 #include "atomic_mm.h"
diff --git a/arch/m68k/include/asm/bitops.h b/arch/m68k/include/asm/bitops.h
index ce163ab..0fba82a 100644
--- a/arch/m68k/include/asm/bitops.h
+++ b/arch/m68k/include/asm/bitops.h
@@ -1,4 +1,4 @@
-#ifdef __uClinux__
+#ifndef CONFIG_MMU
 #include "bitops_no.h"
 #else
 #include "bitops_mm.h"
diff --git a/arch/m68k/include/asm/cacheflush.h b/arch/m68k/include/asm/cacheflush.h
index a70d731..9fa2f19 100644
--- a/arch/m68k/include/asm/cacheflush.h
+++ b/arch/m68k/include/asm/cacheflush.h
@@ -1,4 +1,4 @@
-#ifdef __uClinux__
+#ifndef CONFIG_MMU
 #include "cacheflush_no.h"
 #else
 #include "cacheflush_mm.h"
diff --git a/arch/m68k/include/asm/delay.h b/arch/m68k/include/asm/delay.h
index d2598e3..959248e 100644
--- a/arch/m68k/include/asm/delay.h
+++ b/arch/m68k/include/asm/delay.h
@@ -1,4 +1,4 @@
-#ifdef __uClinux__
+#ifndef CONFIG_MMU
 #include "delay_no.h"
 #else
 #include "delay_mm.h"
diff --git a/arch/m68k/include/asm/entry.h b/arch/m68k/include/asm/entry.h
index 876eec6..47f935c 100644
--- a/arch/m68k/include/asm/entry.h
+++ b/arch/m68k/include/asm/entry.h
@@ -1,4 +1,4 @@
-#ifdef __uClinux__
+#ifndef CONFIG_MMU
 #include "entry_no.h"
 #else
 #include "entry_mm.h"
diff --git a/arch/m68k/include/asm/hardirq.h b/arch/m68k/include/asm/hardirq.h
index 56d0d5d..561e4af 100644
--- a/arch/m68k/include/asm/hardirq.h
+++ b/arch/m68k/include/asm/hardirq.h
@@ -1,4 +1,4 @@
-#ifdef __uClinux__
+#ifndef CONFIG_MMU
 #include "hardirq_no.h"
 #else
 #include "hardirq_mm.h"
diff --git a/arch/m68k/include/asm/io.h b/arch/m68k/include/asm/io.h
index c7210ba..7165052 100644
--- a/arch/m68k/include/asm/io.h
+++ b/arch/m68k/include/asm/io.h
@@ -1,4 +1,4 @@
-#ifdef __uClinux__
+#ifndef CONFIG_MMU
 #include "io_no.h"
 #else
 #include "io_mm.h"
diff --git a/arch/m68k/include/asm/machdep.h b/arch/m68k/include/asm/machdep.h
index fc24b6f..0a3f00d 100644
--- a/arch/m68k/include/asm/machdep.h
+++ b/arch/m68k/include/asm/machdep.h
@@ -1,4 +1,4 @@
-#ifdef __uClinux__
+#ifndef CONFIG_MMU
 #include "machdep_no.h"
 #else
 #include "machdep_mm.h"
diff --git a/arch/m68k/include/asm/page.h b/arch/m68k/include/asm/page.h
index f2b4480..89fdd5c 100644
--- a/arch/m68k/include/asm/page.h
+++ b/arch/m68k/include/asm/page.h
@@ -1,4 +1,4 @@
-#ifdef __uClinux__
+#ifndef CONFIG_MMU
 #include "page_no.h"
 #else
 #include "page_mm.h"
diff --git a/arch/m68k/include/asm/param.h b/arch/m68k/include/asm/param.h
index 36265cc..c7c4c30 100644
--- a/arch/m68k/include/asm/param.h
+++ b/arch/m68k/include/asm/param.h
@@ -1,7 +1,7 @@
 #ifndef _M68K_PARAM_H
 #define _M68K_PARAM_H
 
-#ifdef __uClinux__
+#ifndef CONFIG_MMU
 #define EXEC_PAGESIZE	4096
 #else
 #define EXEC_PAGESIZE	8192
diff --git a/arch/m68k/include/asm/pgtable.h b/arch/m68k/include/asm/pgtable.h
index ee6759e..296e69f 100644
--- a/arch/m68k/include/asm/pgtable.h
+++ b/arch/m68k/include/asm/pgtable.h
@@ -1,4 +1,4 @@
-#ifdef __uClinux__
+#ifndef CONFIG_MMU
 #include "pgtable_no.h"
 #else
 #include "pgtable_mm.h"
diff --git a/arch/m68k/include/asm/sigcontext.h b/arch/m68k/include/asm/sigcontext.h
index a29dd74..e0042a5 100644
--- a/arch/m68k/include/asm/sigcontext.h
+++ b/arch/m68k/include/asm/sigcontext.h
@@ -8,13 +8,13 @@ struct sigcontext {
 	unsigned long  sc_d1;
 	unsigned long  sc_a0;
 	unsigned long  sc_a1;
-#ifdef __uClinux__
+#ifndef CONFIG_MMU
 	unsigned long  sc_a5;
 #endif
 	unsigned short sc_sr;
 	unsigned long  sc_pc;
 	unsigned short sc_formatvec;
-#ifndef __uClinux__
+#ifdef CONFIG_MMU
 # ifdef __mcoldfire__
 	unsigned long  sc_fpregs[2][2];	/* room for two fp registers */
 # else
diff --git a/arch/m68k/include/asm/signal.h b/arch/m68k/include/asm/signal.h
index 5bc09c7..7cc660c 100644
--- a/arch/m68k/include/asm/signal.h
+++ b/arch/m68k/include/asm/signal.h
@@ -150,7 +150,7 @@ typedef struct sigaltstack {
 #ifdef __KERNEL__
 #include <asm/sigcontext.h>
 
-#ifndef __uClinux__
+#ifdef CONFIG_MMU
 #define __HAVE_ARCH_SIG_BITOPS
 
 static inline void sigaddset(sigset_t *set, int _sig)
@@ -207,7 +207,7 @@ extern void ptrace_signal_deliver(struct pt_regs *regs, void *cookie);
 #undef __HAVE_ARCH_SIG_BITOPS
 #define ptrace_signal_deliver(regs, cookie) do { } while (0)
 
-#endif /* __uClinux__ */
+#endif /* CONFIG_MMU */
 #endif /* __KERNEL__ */
 
 #endif /* _M68K_SIGNAL_H */
diff --git a/arch/m68k/include/asm/string.h b/arch/m68k/include/asm/string.h
index 2c356f9..c40b76c 100644
--- a/arch/m68k/include/asm/string.h
+++ b/arch/m68k/include/asm/string.h
@@ -1,4 +1,4 @@
-#ifdef __uClinux__
+#ifndef CONFIG_MMU
 #include "string_no.h"
 #else
 #include "string_mm.h"
diff --git a/arch/m68k/include/asm/system.h b/arch/m68k/include/asm/system.h
index ccea925..00f978a 100644
--- a/arch/m68k/include/asm/system.h
+++ b/arch/m68k/include/asm/system.h
@@ -1,4 +1,4 @@
-#ifdef __uClinux__
+#ifndef CONFIG_MMU
 #include "system_no.h"
 #else
 #include "system_mm.h"
diff --git a/arch/m68k/include/asm/thread_info.h b/arch/m68k/include/asm/thread_info.h
index f31a3f4..12239a6 100644
--- a/arch/m68k/include/asm/thread_info.h
+++ b/arch/m68k/include/asm/thread_info.h
@@ -1,4 +1,4 @@
-#ifdef __uClinux__
+#ifndef CONFIG_MMU
 #include "thread_info_no.h"
 #else
 #include "thread_info_mm.h"
diff --git a/arch/m68k/include/asm/traps.h b/arch/m68k/include/asm/traps.h
index 3011ec0..910d681 100644
--- a/arch/m68k/include/asm/traps.h
+++ b/arch/m68k/include/asm/traps.h
@@ -1,4 +1,4 @@
-#ifdef __uClinux__
+#ifndef CONFIG_MMU
 #include "traps_no.h"
 #else
 #include "traps_mm.h"
diff --git a/arch/m68k/include/asm/uaccess.h b/arch/m68k/include/asm/uaccess.h
index 38f92db..70308e5 100644
--- a/arch/m68k/include/asm/uaccess.h
+++ b/arch/m68k/include/asm/uaccess.h
@@ -1,4 +1,4 @@
-#ifdef __uClinux__
+#ifndef CONFIG_MMU
 #include "uaccess_no.h"
 #else
 #include "uaccess_mm.h"

