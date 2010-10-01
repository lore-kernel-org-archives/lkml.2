Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab0JAVYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 17:24:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840Ab0JAVYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 17:24:24 -0400
Date: Fri, 1 Oct 2010 17:23:58 -0400
From: Jason Baron <jbaron@redhat.com>
To: rostedt@goodmis.org, mingo@elte.hu
Cc: mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, ddaney@caviumnetworks.com,
        linux-kernel@vger.kernel.org
Message-Id: <e37e4c270ba893644ef3c2f0365e2448b8b3981b.1285965957.git.jbaron@redhat.com>
In-Reply-To: <cover.1285965957.git.jbaron@redhat.com>
References: <cover.1285965957.git.jbaron@redhat.com>
Subject: [PATCH 4/5] jump label: move jump table to r/w section
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we are writing the jump table it should be be in R/W kernel
section. Move it to DATA_DATA

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/asm-generic/vmlinux.lds.h |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index ef2af99..24e2daf 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -160,6 +160,10 @@
 	VMLINUX_SYMBOL(__start___tracepoints) = .;			\
 	*(__tracepoints)						\
 	VMLINUX_SYMBOL(__stop___tracepoints) = .;			\
+	. = ALIGN(8);							\
+	VMLINUX_SYMBOL(__start___jump_table) = .;			\
+	*(__jump_table)							\
+	VMLINUX_SYMBOL(__stop___jump_table) = .;			\
 	/* implement dynamic printk debug */				\
 	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___verbose) = .;                          \
@@ -220,8 +224,6 @@
 									\
 	BUG_TABLE							\
 									\
-	JUMP_TABLE							\
-									\
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start_pci_fixups_early) = .;		\
@@ -565,14 +567,6 @@
 #define BUG_TABLE
 #endif
 
-#define JUMP_TABLE							\
-	. = ALIGN(8);							\
-	__jump_table : AT(ADDR(__jump_table) - LOAD_OFFSET) {		\
-		VMLINUX_SYMBOL(__start___jump_table) = .;		\
-		*(__jump_table)						\
-		VMLINUX_SYMBOL(__stop___jump_table) = .;		\
-	}
-
 #ifdef CONFIG_PM_TRACE
 #define TRACEDATA							\
 	. = ALIGN(4);							\
-- 
1.7.1

