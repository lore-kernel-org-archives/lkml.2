Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1B0VVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 16:21:50 -0500
Received: from diomedes.noc.ntua.gr ([147.102.222.220]:64555 "EHLO
	diomedes.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1B0VVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 16:21:48 -0500
From: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
To: linux-kernel@vger.kernel.org
Cc: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
Subject: [PATCH 1/2] Remove KERNEL_IMAGE_SIZE for x86_32 code(no longer used)
Date: Sun, 27 Feb 2011 23:21:37 +0200
Message-Id: <1298841698-31823-2-git-send-email-psomas@cslab.ece.ntua.gr>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298841698-31823-1-git-send-email-psomas@cslab.ece.ntua.gr>
References: <1298841698-31823-1-git-send-email-psomas@cslab.ece.ntua.gr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (diomedes.noc.ntua.gr [147.102.222.220]); Sun, 27 Feb 2011 23:21:46 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KERNEL_IMAGE_SIZE is no longer used by head_32.S for the kernel mapping, and thus
it is no longer needed. 

Remove its definition from page_32_types.h, and the assert from the vmlinux.lds.S 
for the 32bit executable.

Signed-off-by: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
---
 arch/x86/include/asm/page_32_types.h |    5 -----
 arch/x86/kernel/vmlinux.lds.S        |   13 ++++---------
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/page_32_types.h b/arch/x86/include/asm/page_32_types.h
index ade619f..ec5c104 100644
--- a/arch/x86/include/asm/page_32_types.h
+++ b/arch/x86/include/asm/page_32_types.h
@@ -35,11 +35,6 @@
 #define __VIRTUAL_MASK_SHIFT	32
 #endif	/* CONFIG_X86_PAE */
 
-/*
- * Kernel image size is limited to 512 MB (see in arch/x86/kernel/head_32.S)
- */
-#define KERNEL_IMAGE_SIZE	(512 * 1024 * 1024)
-
 #ifndef __ASSEMBLY__
 
 /*
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index bf47007..3f8d8e7 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -362,13 +362,7 @@ SECTIONS
 }
 
 
-#ifdef CONFIG_X86_32
-/*
- * The ASSERT() sink to . is intentional, for binutils 2.14 compatibility:
- */
-. = ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
-	   "kernel image bigger than KERNEL_IMAGE_SIZE");
-#else
+#ifdef CONFIG_X86_64
 /*
  * Per-cpu symbols which need to be offset from __per_cpu_load
  * for the boot processor.
@@ -378,7 +372,8 @@ INIT_PER_CPU(gdt_page);
 INIT_PER_CPU(irq_stack_union);
 
 /*
- * Build-time check on the image size:
+ * Build-time check on the image size.
+ * The ASSERT() sink to . is intentional, for binutils 2.14 compatibility.
  */
 . = ASSERT((_end - _text <= KERNEL_IMAGE_SIZE),
 	   "kernel image bigger than KERNEL_IMAGE_SIZE");
@@ -388,7 +383,7 @@ INIT_PER_CPU(irq_stack_union);
            "irq_stack_union is not at start of per-cpu area");
 #endif
 
-#endif /* CONFIG_X86_32 */
+#endif /* CONFIG_X86_64 */
 
 #ifdef CONFIG_KEXEC
 #include <asm/kexec.h>
-- 
1.7.4.1

