Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1DPN1A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 09:27:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61797 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab1DPN01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 09:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=PtDhGhTTiqwSP79zyMjPoptCkvcdXA9H+7Rg/IFr000lUL48v8hmw4hRjf6qIhl/Hp
         +xOOKTPzSbGJhAvmCDR/5j9XdEm3/HFl7rOQWqkHWvGpfkNUr6qtoPurpXK2f+QP/3Ge
         DVg7t18VAYzTPwiguWKDWi5arMcDMGNtG4Y5g=
From: Alessio Igor Bogani <abogani@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH 2/4] module: Sort exported symbols
Date: Sat, 16 Apr 2011 15:26:11 +0200
Message-Id: <1302960373-5309-3-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302960373-5309-1-git-send-email-abogani@kernel.org>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch places every exported symbol in its own section
(i.e. "___ksymtab__printk").  Thus the linker will use its SORT() directive
to sort and finally merge all symbol in the right and final section
(i.e. "__ksymtab").

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
---
 include/asm-generic/vmlinux.lds.h |   20 ++++++++++----------
 include/linux/module.h            |    4 ++--
 scripts/module-common.lds         |   11 +++++++++++
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bd297a2..349e356 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -274,70 +274,70 @@
 	/* Kernel symbol table: Normal symbols */			\
 	__ksymtab         : AT(ADDR(__ksymtab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___ksymtab) = .;			\
-		*(__ksymtab)						\
+		*(SORT(___ksymtab__*))					\
 		VMLINUX_SYMBOL(__stop___ksymtab) = .;			\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
 	__ksymtab_gpl     : AT(ADDR(__ksymtab_gpl) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___ksymtab_gpl) = .;		\
-		*(__ksymtab_gpl)					\
+		*(SORT(___ksymtab_gpl__*))				\
 		VMLINUX_SYMBOL(__stop___ksymtab_gpl) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
 	__ksymtab_unused  : AT(ADDR(__ksymtab_unused) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___ksymtab_unused) = .;		\
-		*(__ksymtab_unused)					\
+		*(SORT(___ksymtab_unused__*))				\
 		VMLINUX_SYMBOL(__stop___ksymtab_unused) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
 	__ksymtab_unused_gpl : AT(ADDR(__ksymtab_unused_gpl) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___ksymtab_unused_gpl) = .;	\
-		*(__ksymtab_unused_gpl)					\
+		*(SORT(___ksymtab_unused_gpl__*))			\
 		VMLINUX_SYMBOL(__stop___ksymtab_unused_gpl) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
 	__ksymtab_gpl_future : AT(ADDR(__ksymtab_gpl_future) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___ksymtab_gpl_future) = .;	\
-		*(__ksymtab_gpl_future)					\
+		*(SORT(___ksymtab_gpl_future__*))			\
 		VMLINUX_SYMBOL(__stop___ksymtab_gpl_future) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: Normal symbols */			\
 	__kcrctab         : AT(ADDR(__kcrctab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___kcrctab) = .;			\
-		*(__kcrctab)						\
+		*(SORT(___kcrctab__*))					\
 		VMLINUX_SYMBOL(__stop___kcrctab) = .;			\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
 	__kcrctab_gpl     : AT(ADDR(__kcrctab_gpl) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___kcrctab_gpl) = .;		\
-		*(__kcrctab_gpl)					\
+		*(SORT(___kcrctab_gpl__*))				\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
 	__kcrctab_unused  : AT(ADDR(__kcrctab_unused) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___kcrctab_unused) = .;		\
-		*(__kcrctab_unused)					\
+		*(SORT(___kcrctab_unused__*))				\
 		VMLINUX_SYMBOL(__stop___kcrctab_unused) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
 	__kcrctab_unused_gpl : AT(ADDR(__kcrctab_unused_gpl) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___kcrctab_unused_gpl) = .;	\
-		*(__kcrctab_unused_gpl)					\
+		*(SORT(___kcrctab_unused_gpl__*))			\
 		VMLINUX_SYMBOL(__stop___kcrctab_unused_gpl) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
 	__kcrctab_gpl_future : AT(ADDR(__kcrctab_gpl_future) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___kcrctab_gpl_future) = .;	\
-		*(__kcrctab_gpl_future)					\
+		*(SORT(___kcrctab_gpl_future__*))			\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
 	}								\
 									\
diff --git a/include/linux/module.h b/include/linux/module.h
index 5de4204..cfb9563 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -223,7 +223,7 @@ struct module_use {
 	extern void *__crc_##sym __attribute__((weak));		\
 	static const unsigned long __kcrctab_##sym		\
 	__used							\
-	__attribute__((section("__kcrctab" sec), unused))	\
+	__attribute__((section("___kcrctab" sec "__"#sym), unused))	\
 	= (unsigned long) &__crc_##sym;
 #else
 #define __CRC_SYMBOL(sym, sec)
@@ -238,7 +238,7 @@ struct module_use {
 	= MODULE_SYMBOL_PREFIX #sym;                    	\
 	static const struct kernel_symbol __ksymtab_##sym	\
 	__used							\
-	__attribute__((section("__ksymtab" sec), unused))	\
+	__attribute__((section("___ksymtab" sec "__"#sym), unused))	\
 	= { (unsigned long)&sym, __kstrtab_##sym }
 
 #define EXPORT_SYMBOL(sym)					\
diff --git a/scripts/module-common.lds b/scripts/module-common.lds
index 47a1f9a..055a8d5 100644
--- a/scripts/module-common.lds
+++ b/scripts/module-common.lds
@@ -5,4 +5,15 @@
  */
 SECTIONS {
 	/DISCARD/ : { *(.discard) }
+
+	__ksymtab				: { *(SORT(___ksymtab__*)) }
+	__ksymtab_gpl			: { *(SORT(___ksymtab_gpl__*)) }
+	__ksymtab_unused		: { *(SORT(___ksymtab_unused__*)) }
+	__ksymtab_unused_gpl	: { *(SORT(___ksymtab_unused_gpl__*)) }
+	__ksymtab_gpl_future	: { *(SORT(___ksymtab_gpl_future__*)) }
+	__kcrctab				: { *(SORT(___kcrctab__*)) }
+	__kcrctab_gpl			: { *(SORT(___kcrctab_gpl__*)) }
+	__kcrctab_unused		: { *(SORT(___kcrctab_unused__*)) }
+	__kcrctab_unused_gpl	: { *(SORT(___kcrctab_unused_gpl__*)) }
+	__kcrctab_gpl_future	: { *(SORT(___kcrctab_gpl_future__*)) }
 }
-- 
1.7.4.1

