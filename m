Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761647Ab2FEJrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:47:22 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41737 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753536Ab2FEJrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:47:19 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] arch: Remove direct definitions of KERN_<LEVEL> uses
Date: Tue,  5 Jun 2012 02:46:32 -0700
Message-Id: <282f5ce989b713c749966dcefbc4b306f0fa909a.1338889066.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1338889066.git.joe@perches.com>
References: <cover.1338889066.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add #include <linux/kern_levels.h> so that the #define KERN_<LEVEL>
macros don't have to be duplicated.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/lib/io-acorn.S         |    3 ++-
 arch/arm/vfp/vfphw.S            |    7 ++++---
 arch/frv/kernel/kernel_thread.S |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm/lib/io-acorn.S b/arch/arm/lib/io-acorn.S
index 1b197ea..69719ba 100644
--- a/arch/arm/lib/io-acorn.S
+++ b/arch/arm/lib/io-acorn.S
@@ -11,13 +11,14 @@
  *
  */
 #include <linux/linkage.h>
+#include <linux/kern_levels.h>
 #include <asm/assembler.h>
 
 		.text
 		.align
 
 .Liosl_warning:
-		.ascii	"<4>insl/outsl not implemented, called from %08lX\0"
+		.ascii	KERN_WARNING "insl/outsl not implemented, called from %08lX\0"
 		.align
 
 /*
diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
index 2d30c7f..d50f0e4 100644
--- a/arch/arm/vfp/vfphw.S
+++ b/arch/arm/vfp/vfphw.S
@@ -16,6 +16,7 @@
  */
 #include <asm/thread_info.h>
 #include <asm/vfpmacros.h>
+#include <linux/kern_levels.h>
 #include "../kernel/entry-header.S"
 
 	.macro	DBGSTR, str
@@ -24,7 +25,7 @@
 	add	r0, pc, #4
 	bl	printk
 	b	1f
-	.asciz  "<7>VFP: \str\n"
+	.asciz  KERN_DEBUG "VFP: \str\n"
 	.balign 4
 1:	ldmfd	sp!, {r0-r3, ip, lr}
 #endif
@@ -37,7 +38,7 @@
 	add	r0, pc, #4
 	bl	printk
 	b	1f
-	.asciz  "<7>VFP: \str\n"
+	.asciz  KERN_DEBUG "VFP: \str\n"
 	.balign 4
 1:	ldmfd	sp!, {r0-r3, ip, lr}
 #endif
@@ -52,7 +53,7 @@
 	add	r0, pc, #4
 	bl	printk
 	b	1f
-	.asciz  "<7>VFP: \str\n"
+	.asciz  KERN_DEBUG "VFP: \str\n"
 	.balign 4
 1:	ldmfd	sp!, {r0-r3, ip, lr}
 #endif
diff --git a/arch/frv/kernel/kernel_thread.S b/arch/frv/kernel/kernel_thread.S
index 4531c83..f0e5294 100644
--- a/arch/frv/kernel/kernel_thread.S
+++ b/arch/frv/kernel/kernel_thread.S
@@ -10,10 +10,10 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/kern_levels.h>
 #include <asm/unistd.h>
 
 #define CLONE_VM	0x00000100	/* set if VM shared between processes */
-#define	KERN_ERR	"<3>"
 
 	.section .rodata
 kernel_thread_emsg:
-- 
1.7.8.111.gad25c.dirty

