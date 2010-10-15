Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab0JOULs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:11:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57187 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878Ab0JOUKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:10:39 -0400
X-Authority-Analysis: v=1.1 cv=QISHQ+x4xS+apxgDHgAvNvlUjyrXCzYsHvuXcbPYiKg= c=1 sm=0 a=2gwe-jq3GEwA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=9lXzf_fSpN2H3NrLt84A:9 a=f2a2h6y01m7E4OOeK8f9_JpdybsA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101015201037.169223331@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 15 Oct 2010 16:09:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 6/9] jump label: Move jump table to r/w section
References: <20101015200949.134732894@goodmis.org>
Content-Disposition: inline; filename=0006-jump-label-Move-jump-table-to-r-w-section.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Since we are writing the jump table it should be be in R/W kernel
section. Move it to DATA_DATA

Signed-off-by: Jason Baron <jbaron@redhat.com>
LKML-Reference: <e37e4c270ba893644ef3c2f0365e2448b8b3981b.1285965957.git.jbaron@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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


