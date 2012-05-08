Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab2EHMiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:38:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55051 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab2EHMiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:38:05 -0400
Date: Tue, 8 May 2012 05:37:50 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-803fc74f06cf3cd23417463ca5a176b41717ec19@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jesper.nilsson@axis.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jesper.nilsson@axis.com, tglx@linutronix.de
In-Reply-To: <20120505150141.681236240@linutronix.de>
References: <20120505150141.681236240@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] cris: Use common threadinfo allocator
Git-Commit-ID: 803fc74f06cf3cd23417463ca5a176b41717ec19
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:37:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  803fc74f06cf3cd23417463ca5a176b41717ec19
Gitweb:     http://git.kernel.org/tip/803fc74f06cf3cd23417463ca5a176b41717ec19
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:43 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 14:08:44 +0200

cris: Use common threadinfo allocator

There is no functional difference. __get_free_pages() ends up calling
alloc_pages_node().

This also allocates only one page which matches THREAD_SIZE instead of
an extra page for nothing.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Link: http://lkml.kernel.org/r/20120505150141.681236240@linutronix.de
---
 arch/cris/include/asm/processor.h   |    5 ++---
 arch/cris/include/asm/thread_info.h |    6 ------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/cris/include/asm/processor.h b/arch/cris/include/asm/processor.h
index 4210d72..8dc56ef 100644
--- a/arch/cris/include/asm/processor.h
+++ b/arch/cris/include/asm/processor.h
@@ -25,13 +25,12 @@ struct task_struct;
  */
 #define TASK_UNMAPPED_BASE      (PAGE_ALIGN(TASK_SIZE / 3))
 
-/* THREAD_SIZE is the size of the task_struct/kernel_stack combo.
+/* THREAD_SIZE is the size of the thread_info/kernel_stack combo.
  * normally, the stack is found by doing something like p + THREAD_SIZE
  * in CRIS, a page is 8192 bytes, which seems like a sane size
  */
-
 #define THREAD_SIZE       PAGE_SIZE
-#define KERNEL_STACK_SIZE PAGE_SIZE
+#define THREAD_SIZE_ORDER (0)
 
 /*
  * At user->kernel entry, the pt_regs struct is stacked on the top of the kernel-stack.
diff --git a/arch/cris/include/asm/thread_info.h b/arch/cris/include/asm/thread_info.h
index 29b9288..5b1c448 100644
--- a/arch/cris/include/asm/thread_info.h
+++ b/arch/cris/include/asm/thread_info.h
@@ -65,12 +65,6 @@ struct thread_info {
 
 #define init_thread_info	(init_thread_union.thread_info)
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-/* thread information allocation */
-#define alloc_thread_info_node(tsk, node)	\
-	((struct thread_info *) __get_free_pages(GFP_KERNEL, 1))
-#define free_thread_info(ti) free_pages((unsigned long) (ti), 1)
-
 #endif /* !__ASSEMBLY__ */
 
 /*
