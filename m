Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab1FHXGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 19:06:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:60771 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab1FHXGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 19:06:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,340,1304319600"; 
   d="scan'208";a="11444406"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, x86@kernel.org
Subject: [PATCH] x86: Fix sys_call_table type in asm/syscall.h v2
Date: Wed,  8 Jun 2011 16:04:55 -0700
Message-Id: <1307574295-4991-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Make the sys_call_table type defined in asm/syscall.h match
the definition in syscall_64.c

v2: include asm/syscall.h in syscall_64.c too. I left uml alone
because it doesn't have an syscall.h on its own and including
the native one leads to other errors.
Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/syscall.h |    3 ++-
 arch/x86/kernel/syscall_64.c   |    3 +--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index c4a348f..32295b7 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -16,7 +16,8 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 
-extern const unsigned long sys_call_table[];
+typedef void (*sys_call_ptr_t)(void);
+extern const sys_call_ptr_t sys_call_table[];
 
 /*
  * Only the low 32 bits of orig_ax are meaningful, so we return int.
diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
index a576626..c6e0f33 100644
--- a/arch/x86/kernel/syscall_64.c
+++ b/arch/x86/kernel/syscall_64.c
@@ -4,6 +4,7 @@
 #include <linux/sys.h>
 #include <linux/cache.h>
 #include <asm/asm-offsets.h>
+#include <asm/syscall.h>
 
 #define __NO_STUBS
 
@@ -15,8 +16,6 @@
 #define __SYSCALL(nr, sym) [nr] = sym,
 #undef _ASM_X86_UNISTD_64_H
 
-typedef void (*sys_call_ptr_t)(void);
-
 extern void sys_ni_syscall(void);
 
 asmlinkage const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
-- 
1.7.4.4

