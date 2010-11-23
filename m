Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab0KWV2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 16:28:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab0KWV2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 16:28:10 -0500
Date: Tue, 23 Nov 2010 16:27:32 -0500
From: Jason Baron <jbaron@redhat.com>
To: rostedt@goodmis.org, mingo@elte.hu
Cc: peterz@infradead.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Message-Id: <bbc34a86a4cf4addcde1b85d7fa7faecc0966c03.1290546539.git.jbaron@redhat.com>
In-Reply-To: <cover.1290546539.git.jbaron@redhat.com>
References: <cover.1290546539.git.jbaron@redhat.com>
Subject: [PATCH 2/3] jump label: move jump table to r/w section
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we writing the jump table it should be be in R/W kernel
section. Move it to DATA_DATA

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/asm-generic/vmlinux.lds.h |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bd69d79..9ca894d 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -161,6 +161,10 @@
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
@@ -221,8 +225,6 @@
 									\
 	BUG_TABLE							\
 									\
-	JUMP_TABLE							\
-									\
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start_pci_fixups_early) = .;		\
@@ -566,14 +568,6 @@
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

