Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab0JZCyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:54:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433Ab0JZCyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:54:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 16/43] MN10300: Provide a MN10300_CACHE_ENABLED config option
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 26 Oct 2010 03:54:27 +0100
Message-ID: <20101026025427.23512.20793.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a MN10300_CACHE_ENABLED config option as inverted logic of
MN10300_CACHE_DISABLED to make things simpler.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/cacheflush.h |    6 +++---
 arch/mn10300/include/asm/gdb-stub.h   |    2 +-
 arch/mn10300/include/asm/processor.h  |    4 ++--
 arch/mn10300/kernel/Makefile          |    2 +-
 arch/mn10300/kernel/head.S            |    6 +++---
 arch/mn10300/mm/Kconfig.cache         |    3 +++
 6 files changed, 13 insertions(+), 10 deletions(-)


diff --git a/arch/mn10300/include/asm/cacheflush.h b/arch/mn10300/include/asm/cacheflush.h
index 29e692f..b85be1d 100644
--- a/arch/mn10300/include/asm/cacheflush.h
+++ b/arch/mn10300/include/asm/cacheflush.h
@@ -34,7 +34,7 @@
 /*
  * physically-indexed cache management
  */
-#ifndef CONFIG_MN10300_CACHE_DISABLED
+#ifdef CONFIG_MN10300_CACHE_ENABLED
 
 extern void flush_icache_range(unsigned long start, unsigned long end);
 extern void flush_icache_page(struct vm_area_struct *vma, struct page *pg);
@@ -61,7 +61,7 @@ extern void flush_icache_page(struct vm_area_struct *vma, struct page *pg);
 /*
  * primitive routines
  */
-#ifndef CONFIG_MN10300_CACHE_DISABLED
+#ifdef CONFIG_MN10300_CACHE_ENABLED
 extern void mn10300_icache_inv(void);
 extern void mn10300_dcache_inv(void);
 extern void mn10300_dcache_inv_page(unsigned start);
@@ -103,7 +103,7 @@ extern void mn10300_dcache_flush_inv_range2(unsigned start, unsigned size);
 #define mn10300_dcache_flush_page(start)		do {} while (0)
 #define mn10300_dcache_flush_range(start, end)		do {} while (0)
 #define mn10300_dcache_flush_range2(start, size)	do {} while (0)
-#endif /* CONFIG_MN10300_CACHE_DISABLED */
+#endif /* CONFIG_MN10300_CACHE_ENABLED */
 
 /*
  * internal debugging function
diff --git a/arch/mn10300/include/asm/gdb-stub.h b/arch/mn10300/include/asm/gdb-stub.h
index 41ed267..f5495ad 100644
--- a/arch/mn10300/include/asm/gdb-stub.h
+++ b/arch/mn10300/include/asm/gdb-stub.h
@@ -110,7 +110,7 @@ extern asmlinkage void gdbstub_exception(struct pt_regs *, enum exception_code);
 extern asmlinkage void __gdbstub_bug_trap(void);
 extern asmlinkage void __gdbstub_pause(void);
 
-#ifndef CONFIG_MN10300_CACHE_DISABLED
+#ifdef CONFIG_MN10300_CACHE_ENABLED
 extern asmlinkage void gdbstub_purge_cache(void);
 #else
 #define gdbstub_purge_cache()	do {} while (0)
diff --git a/arch/mn10300/include/asm/processor.h b/arch/mn10300/include/asm/processor.h
index f7d4b0d..fd96c18 100644
--- a/arch/mn10300/include/asm/processor.h
+++ b/arch/mn10300/include/asm/processor.h
@@ -157,7 +157,7 @@ unsigned long get_wchan(struct task_struct *p);
 
 static inline void prefetch(const void *x)
 {
-#ifndef CONFIG_MN10300_CACHE_DISABLED
+#ifdef CONFIG_MN10300_CACHE_ENABLED
 #ifdef CONFIG_MN10300_PROC_MN103E010
 	asm volatile ("nop; nop; dcpf (%0)" : : "r"(x));
 #else
@@ -168,7 +168,7 @@ static inline void prefetch(const void *x)
 
 static inline void prefetchw(const void *x)
 {
-#ifndef CONFIG_MN10300_CACHE_DISABLED
+#ifdef CONFIG_MN10300_CACHE_ENABLED
 #ifdef CONFIG_MN10300_PROC_MN103E010
 	asm volatile ("nop; nop; dcpf (%0)" : : "r"(x));
 #else
diff --git a/arch/mn10300/kernel/Makefile b/arch/mn10300/kernel/Makefile
index 23f2ab6..c4289e3 100644
--- a/arch/mn10300/kernel/Makefile
+++ b/arch/mn10300/kernel/Makefile
@@ -17,7 +17,7 @@ obj-$(CONFIG_GDBSTUB) += gdb-stub.o gdb-low.o
 obj-$(CONFIG_GDBSTUB_ON_TTYSx) += gdb-io-serial.o gdb-io-serial-low.o
 obj-$(CONFIG_GDBSTUB_ON_TTYSMx) += gdb-io-ttysm.o gdb-io-ttysm-low.o
 
-ifneq ($(CONFIG_MN10300_CACHE_DISABLED),y)
+ifeq ($(CONFIG_MN10300_CACHE_ENABLED),y)
 obj-$(CONFIG_GDBSTUB) += gdb-cache.o
 endif
 
diff --git a/arch/mn10300/kernel/head.S b/arch/mn10300/kernel/head.S
index 14f27f3..a81e34f 100644
--- a/arch/mn10300/kernel/head.S
+++ b/arch/mn10300/kernel/head.S
@@ -61,18 +61,18 @@ _start:
 	btst	CHCTR_ICBUSY|CHCTR_DCBUSY,d0		# wait till not busy
 	lne
 
-#ifndef CONFIG_MN10300_CACHE_DISABLED
+#ifdef CONFIG_MN10300_CACHE_ENABLED
 #ifdef CONFIG_MN10300_CACHE_WBACK
 #ifndef CONFIG_MN10300_CACHE_WBACK_NOWRALLOC
 	mov	CHCTR_ICEN|CHCTR_DCEN|CHCTR_DCWTMD_WRBACK,d0
 #else
 	mov	CHCTR_ICEN|CHCTR_DCEN|CHCTR_DCWTMD_WRBACK|CHCTR_DCALMD,d0
-#endif /* CACHE_DISABLED */
+#endif /* NOWRALLOC */
 #else
 	mov	CHCTR_ICEN|CHCTR_DCEN|CHCTR_DCWTMD_WRTHROUGH,d0
 #endif /* WBACK */
 	movhu	d0,(a0)					# enable
-#endif /* NOWRALLOC */
+#endif /* ENABLED */
 
 	# turn on RTS on the debug serial port if applicable
 #ifdef CONFIG_MN10300_UNIT_ASB2305
diff --git a/arch/mn10300/mm/Kconfig.cache b/arch/mn10300/mm/Kconfig.cache
index f5599f4..56a88dd 100644
--- a/arch/mn10300/mm/Kconfig.cache
+++ b/arch/mn10300/mm/Kconfig.cache
@@ -30,3 +30,6 @@ config MN10300_CACHE_DISABLED
 	bool "Disabled"
 
 endchoice
+
+config MN10300_CACHE_ENABLED
+	def_bool y if !MN10300_CACHE_DISABLED

