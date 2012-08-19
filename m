Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab2HSC7n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:59:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:60723 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab2HSC5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="210415447"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 25/74] x86, lto: Fix sys_call_table type in asm/syscall.h v2
Date: Sat, 18 Aug 2012 19:56:21 -0700
Message-Id: <1345345030-22211-26-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
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
index 1ace47b..c36962d 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -20,7 +20,8 @@
 #include <asm/thread_info.h>	/* for TS_COMPAT */
 #include <asm/unistd.h>
 
-extern const unsigned long sys_call_table[];
+typedef void (*sys_call_ptr_t)(void);
+extern const sys_call_ptr_t sys_call_table[];
 
 /*
  * Only the low 32 bits of orig_ax are meaningful, so we return int.
diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
index 3967318..4ac730b 100644
--- a/arch/x86/kernel/syscall_64.c
+++ b/arch/x86/kernel/syscall_64.c
@@ -4,6 +4,7 @@
 #include <linux/sys.h>
 #include <linux/cache.h>
 #include <asm/asm-offsets.h>
+#include <asm/syscall.h>
 
 #define __SYSCALL_COMMON(nr, sym, compat) __SYSCALL_64(nr, sym, compat)
 
@@ -19,8 +20,6 @@
 
 #define __SYSCALL_64(nr, sym, compat) [nr] = sym,
 
-typedef void (*sys_call_ptr_t)(void);
-
 extern void sys_ni_syscall(void);
 
 asmlinkage const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
-- 
1.7.7.6

