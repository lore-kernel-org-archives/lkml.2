Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab2EHMcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:32:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54881 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab2EHMcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:32:11 -0400
Date: Tue, 8 May 2012 05:31:58 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-6c0a9fa62feb7e9fdefa9720bcc03040c9b0b311@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <20120505150141.306358267@linutronix.de>
References: <20120505150141.306358267@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] fork: Remove the weak insanity
Git-Commit-ID: 6c0a9fa62feb7e9fdefa9720bcc03040c9b0b311
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:32:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c0a9fa62feb7e9fdefa9720bcc03040c9b0b311
Gitweb:     http://git.kernel.org/tip/6c0a9fa62feb7e9fdefa9720bcc03040c9b0b311
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:40 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 13:55:20 +0200

fork: Remove the weak insanity

We error out when compiling with gcc4.1.[01] as it miscompiles
__weak. The workaround with magic defines is not longer
necessary. Make it __weak again.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20120505150141.306358267@linutronix.de

---
 arch/sh/include/asm/thread_info.h  |    1 -
 arch/x86/include/asm/thread_info.h |    1 -
 kernel/fork.c                      |    8 +-------
 3 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/arch/sh/include/asm/thread_info.h b/arch/sh/include/asm/thread_info.h
index 20ee40a..09963d4 100644
--- a/arch/sh/include/asm/thread_info.h
+++ b/arch/sh/include/asm/thread_info.h
@@ -98,7 +98,6 @@ static inline struct thread_info *current_thread_info(void)
 extern struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node);
 extern void free_thread_info(struct thread_info *ti);
 extern void arch_task_cache_init(void);
-#define arch_task_cache_init arch_task_cache_init
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
 extern void init_thread_xstate(void);
 
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index ad6df8c..8692a16 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -284,6 +284,5 @@ static inline bool is_ia32_task(void)
 extern void arch_task_cache_init(void);
 extern void free_thread_info(struct thread_info *ti);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
-#define arch_task_cache_init arch_task_cache_init
 #endif
 #endif /* _ASM_X86_THREAD_INFO_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index b9372a0..a79b36e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -203,13 +203,7 @@ void __put_task_struct(struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(__put_task_struct);
 
-/*
- * macro override instead of weak attribute alias, to workaround
- * gcc 4.1.0 and 4.1.1 bugs with weak attribute and empty functions.
- */
-#ifndef arch_task_cache_init
-#define arch_task_cache_init()
-#endif
+void __init __weak arch_task_cache_init(void) { }
 
 void __init fork_init(unsigned long mempages)
 {
