Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab1GEMvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:51:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:58343 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab1GEMvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:51:23 -0400
Date: Tue, 5 Jul 2011 12:51:16 GMT
From: tip-bot for Paul McQuade <tungstentide@gmail.com>
Message-ID: <tip-84c15027a7f2fbd7f1180d7cbb60e41abbbaedd2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, arjan@linux.intel.com, tungstentide@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tungstentide@gmail.com, arjan@linux.intel.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <4DE596B4.7030904@gmail.com>
References: <4DE596B4.7030904@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] async: Fixed an include coding style issue
Git-Commit-ID: 84c15027a7f2fbd7f1180d7cbb60e41abbbaedd2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Jul 2011 12:51:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84c15027a7f2fbd7f1180d7cbb60e41abbbaedd2
Gitweb:     http://git.kernel.org/tip/84c15027a7f2fbd7f1180d7cbb60e41abbbaedd2
Author:     Paul McQuade <tungstentide@gmail.com>
AuthorDate: Tue, 31 May 2011 20:51:55 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 14 Jun 2011 22:48:46 -0400

async: Fixed an include coding style issue

Added <linux/atomic.h>,<linux/ktime.h> and Removed <asm/atomic.h>.
Added KERN_DEBUG to printk() functions.

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Paul McQuade <tungstentide@gmail.com>
Link: http://lkml.kernel.org/r/4DE596B4.7030904@gmail.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/async.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index cd9dbb9..d5fe7af 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -49,12 +49,13 @@ asynchronous and synchronous parts of the kernel.
 */
 
 #include <linux/async.h>
+#include <linux/atomic.h>
+#include <linux/ktime.h>
 #include <linux/module.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
-#include <asm/atomic.h>
 
 static async_cookie_t next_cookie = 1;
 
@@ -128,7 +129,8 @@ static void async_run_entry_fn(struct work_struct *work)
 
 	/* 2) run (and print duration) */
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		printk("calling  %lli_%pF @ %i\n", (long long)entry->cookie,
+		printk(KERN_DEBUG "calling  %lli_%pF @ %i\n",
+			(long long)entry->cookie,
 			entry->func, task_pid_nr(current));
 		calltime = ktime_get();
 	}
@@ -136,7 +138,7 @@ static void async_run_entry_fn(struct work_struct *work)
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		rettime = ktime_get();
 		delta = ktime_sub(rettime, calltime);
-		printk("initcall %lli_%pF returned 0 after %lld usecs\n",
+		printk(KERN_DEBUG "initcall %lli_%pF returned 0 after %lld usecs\n",
 			(long long)entry->cookie,
 			entry->func,
 			(long long)ktime_to_ns(delta) >> 10);
@@ -270,7 +272,7 @@ void async_synchronize_cookie_domain(async_cookie_t cookie,
 	ktime_t starttime, delta, endtime;
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		printk("async_waiting @ %i\n", task_pid_nr(current));
+		printk(KERN_DEBUG "async_waiting @ %i\n", task_pid_nr(current));
 		starttime = ktime_get();
 	}
 
@@ -280,7 +282,7 @@ void async_synchronize_cookie_domain(async_cookie_t cookie,
 		endtime = ktime_get();
 		delta = ktime_sub(endtime, starttime);
 
-		printk("async_continuing @ %i after %lli usec\n",
+		printk(KERN_DEBUG "async_continuing @ %i after %lli usec\n",
 			task_pid_nr(current),
 			(long long)ktime_to_ns(delta) >> 10);
 	}
