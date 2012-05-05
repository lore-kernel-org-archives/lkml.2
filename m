Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab2EESsC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:48:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54228 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2EESsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:48:00 -0400
Date: Sat, 5 May 2012 11:47:49 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-c6ae063aaf3786b9db7f19a90bf4ed8aaebb7f90@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dhowells@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, tglx@linutronix.de
In-Reply-To: <20120503085033.967140188@linutronix.de>
References: <20120503085033.967140188@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] frv: Use core allocator for task_struct
Git-Commit-ID: c6ae063aaf3786b9db7f19a90bf4ed8aaebb7f90
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 11:47:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c6ae063aaf3786b9db7f19a90bf4ed8aaebb7f90
Gitweb:     http://git.kernel.org/tip/c6ae063aaf3786b9db7f19a90bf4ed8aaebb7f90
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:47 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:21 +0200

frv: Use core allocator for task_struct

There is no point having a copy of the core allocator.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: David Howells <dhowells@redhat.com>
Link: http://lkml.kernel.org/r/20120503085033.967140188@linutronix.de

---
 arch/frv/include/asm/thread_info.h |    2 --
 arch/frv/kernel/process.c          |   10 ----------
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/frv/include/asm/thread_info.h b/arch/frv/include/asm/thread_info.h
index 92d83ea..aaea388 100644
--- a/arch/frv/include/asm/thread_info.h
+++ b/arch/frv/include/asm/thread_info.h
@@ -21,8 +21,6 @@
 
 #define THREAD_SIZE		8192
 
-#define __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
-
 /*
  * low level task data that entry.S needs immediate access to
  * - this struct should fit entirely inside of one cache line
diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index 1ac84b2..ed09e9e 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -43,16 +43,6 @@ asmlinkage void ret_from_fork(void);
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-struct task_struct *alloc_task_struct_node(int node)
-{
-	return kmalloc_node(sizeof(task_struct), GFP_KERNEL, node);
-}
-
-void free_task_struct(struct task_struct *p)
-{
-	kfree(p);
-}
-
 static void core_sleep_idle(void)
 {
 #ifdef LED_DEBUG_SLEEP
