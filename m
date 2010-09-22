Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab0IVFSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 01:18:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab0IVFSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 01:18:54 -0400
From: cdahlin@redhat.com
To: linux-kernel@vger.kernel.org
Cc: Casey Dahlin <cdahlin@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, Roland McGrath <roland@redhat.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3/3] hook up inotify_add_watch_at for x86
Date: Wed, 22 Sep 2010 01:16:58 -0400
Message-Id: <1285132618-31573-4-git-send-email-cdahlin@redhat.com>
In-Reply-To: <1285132618-31573-1-git-send-email-cdahlin@redhat.com>
References: <1285132618-31573-1-git-send-email-cdahlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Dahlin <cdahlin@redhat.com>

Signed-off-by: Casey Dahlin <cdahlin@redhat.com>
---
 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    3 ++-
 arch/x86/include/asm/unistd_64.h   |    2 ++
 arch/x86/kernel/syscall_table_32.S |    1 +
 4 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 518bb99..1edff69 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -851,4 +851,5 @@ ia32_sys_call_table:
 	.quad sys_fanotify_init
 	.quad sys32_fanotify_mark
 	.quad sys_prlimit64		/* 340 */
+	.quad sys_inotify_add_watch_at
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index b766a5e..ae82b2b 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -346,10 +346,11 @@
 #define __NR_fanotify_init	338
 #define __NR_fanotify_mark	339
 #define __NR_prlimit64		340
+#define __NR_inotify_add_watch_at	341
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 341
+#define NR_syscalls 342
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 363e9b8..f9c704a 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -669,6 +669,8 @@ __SYSCALL(__NR_fanotify_init, sys_fanotify_init)
 __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
 #define __NR_prlimit64				302
 __SYSCALL(__NR_prlimit64, sys_prlimit64)
+#define __NR_inotify_add_watch_at		303
+__SYSCALL(__NR_inotify_add_watch_at, sys_inotify_add_watch_at)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index b35786d..a9b3682 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -340,3 +340,4 @@ ENTRY(sys_call_table)
 	.long sys_fanotify_init
 	.long sys_fanotify_mark
 	.long sys_prlimit64		/* 340 */
+	.long sys_inotify_add_watch_at
-- 
1.7.2.3

