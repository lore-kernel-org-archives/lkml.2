Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab1FONwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 09:52:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38507 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab1FONwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 09:52:36 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=vhdKIqpQuCYA:10 a=BXO1rc9F_QsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=Td47693tbtDpLw27fQkA:9 a=zG6h97lxyDAQbLbMo2YA:7 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110615135234.178602283@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 15 Jun 2011 09:48:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul McQuade <tungstentide@gmail.com>
Subject: [PATCH 06/16 v2] async: Fixed an include coding style issue
References: <20110615134841.767565350@goodmis.org>
Content-Disposition: inline; filename=0006-async-Fixed-an-include-coding-style-issue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul McQuade <tungstentide@gmail.com>

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
-- 
1.7.4.4


