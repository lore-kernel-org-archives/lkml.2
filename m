Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab2BTAVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:21:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57405 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab2BTAVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:21:35 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 28/30] x32: If configured, add x32 system calls to system call tables
Date: Sun, 19 Feb 2012 16:08:06 -0800
Message-Id: <1329696488-16970-29-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:21:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

If CONFIG_X86_X32_ABI is defined, add the x32 system calls to the
system call tables.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/asm-offsets_64.c |    6 +++++-
 arch/x86/kernel/syscall_64.c     |    7 ++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index c3354f7..1b4754f 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -2,7 +2,11 @@
 
 #define __SYSCALL_64(nr, sym, compat) [nr] = 1,
 #define __SYSCALL_COMMON(nr, sym, compat) [nr] = 1,
-#define __SYSCALL_X32(nr, sym, compat) /* Not yet */
+#ifdef CONFIG_X86_X32_ABI
+# define __SYSCALL_X32(nr, sym, compat) [nr] = 1,
+#else
+# define __SYSCALL_X32(nr, sym, compat) /* nothing */
+#endif
 static char syscalls_64[] = {
 #include <asm/syscalls_64.h>
 };
diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
index 26c4ca1..5c7f8c2 100644
--- a/arch/x86/kernel/syscall_64.c
+++ b/arch/x86/kernel/syscall_64.c
@@ -6,7 +6,12 @@
 #include <asm/asm-offsets.h>
 
 #define __SYSCALL_COMMON(nr, sym, compat) __SYSCALL_64(nr, sym, compat)
-#define __SYSCALL_X32(nr, sym, compat) /* Not yet */
+
+#ifdef CONFIG_X86_X32_ABI
+# define __SYSCALL_X32(nr, sym, compat) __SYSCALL_64(nr, sym, compat)
+#else
+# define __SYSCALL_X32(nr, sym, compat) /* nothing */
+#endif
 
 #define __SYSCALL_64(nr, sym, compat) extern asmlinkage void sym(void) ;
 #include <asm/syscalls_64.h>
-- 
1.7.6.5

