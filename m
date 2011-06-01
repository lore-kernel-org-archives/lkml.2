Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056Ab1FAAvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 20:51:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33222 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673Ab1FAAvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 20:51:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=AR/TySa/t2Hlhunl7GfJRJyX5ociHrR2Ish1EmV8sog/WuHaQs2dhTqYr6Vr8FN9CV
         7gb/6tcUzHG13Doc4ijUFS/afA+ftrX0hEbUMuSk/eGz9u/D+COvymFbqVJvAKi70kO/
         OYW6VHi2+6ImuBM415/mUVI0fBw9D2wCOrd2Y=
Message-ID: <4DE58D24.7070309@gmail.com>
Date: Wed, 01 Jun 2011 01:51:48 +0100
From: Paul McQuade <tungstentide@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] KERNEL: async: Fixed an include coding style issue
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2514174efe73e654c46e669ea2df5169a41d0130 Mon Sep 17 00:00:00 2001
From: Paul McQuade <tungstentide@gmail.com>
Date: Tue, 31 May 2011 20:51:55 +0100
Subject: [PATCH] KERNEL: async: Fixed an include coding style issue
 KERNEL: trace: ftrace: Fixed an include coding style issue

async:
Added <linux/atomic.h>,<linux/ktime.h> and Removed <asm/atomic.h>.
Added KERN_DEBUG to printk() functions.

ftrace:
Removed <asm/ftrace.h> because <linux/ftrace.h> was already declared.
Braces of struct's coding style fixed.

Signed-off-by: Paul McQuade <tungstentide@gmail.com>
---
 kernel/async.c        |   13 +++++++------
 kernel/trace/ftrace.c |   12 ++++--------
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index cd9dbb9..91edc17 100644
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

@@ -128,15 +129,15 @@ static void async_run_entry_fn(struct work_struct
*work)

 	/* 2) run (and print duration) */
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		printk("calling  %lli_%pF @ %i\n", (long long)entry->cookie,
-			entry->func, task_pid_nr(current));
+		printk(KERN_DEBUG "calling  %lli_%pF @ %i\n",
+			(long long)entry->cookie,
+			entry->func, task_pid_nr(current));
 		calltime = ktime_get();
 	}
 	entry->func(entry->data, entry->cookie);
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		rettime = ktime_get();
 		delta = ktime_sub(rettime, calltime);
-		printk("initcall %lli_%pF returned 0 after %lld usecs\n",
+		printk(KERN_DEBUG "initcall %lli_%pF returned 0 after %lld usecs\n",
 			(long long)entry->cookie,
 			entry->func,
 			(long long)ktime_to_ns(delta) >> 10);
@@ -270,7 +271,7 @@ void async_synchronize_cookie_domain(async_cookie_t
cookie,
 	ktime_t starttime, delta, endtime;

 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		printk("async_waiting @ %i\n", task_pid_nr(current));
+		printk(KERN_DEBUG "async_waiting @ %i\n", task_pid_nr(current));
 		starttime = ktime_get();
 	}

@@ -280,7 +281,7 @@ void async_synchronize_cookie_domain(async_cookie_t
cookie,
 		endtime = ktime_get();
 		delta = ktime_sub(endtime, starttime);

-		printk("async_continuing @ %i after %lli usec\n",
+		printk(KERN_DEBUG "async_continuing @ %i after %lli usec\n",
 			task_pid_nr(current),
 			(long long)ktime_to_ns(delta) >> 10);
 	}
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1ee417f..02c1cef 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -32,7 +32,6 @@

 #include <trace/events/sched.h>

-#include <asm/ftrace.h>
 #include <asm/setup.h>

 #include "trace_output.h"
@@ -82,8 +81,7 @@ static int ftrace_disabled __read_mostly;

 static DEFINE_MUTEX(ftrace_lock);

-static struct ftrace_ops ftrace_list_end __read_mostly =
-{
+static struct ftrace_ops ftrace_list_end __read_mostly = {
 	.func		= ftrace_stub,
 };

@@ -785,8 +783,7 @@ static void unregister_ftrace_profiler(void)
 	unregister_ftrace_graph();
 }
 #else
-static struct ftrace_ops ftrace_profile_ops __read_mostly =
-{
+static struct ftrace_ops ftrace_profile_ops __read_mostly = {
 	.func		= function_profile_call,
 };

@@ -999,7 +996,7 @@ struct ftrace_page {
 };

 #define ENTRIES_PER_PAGE \
-  ((PAGE_SIZE - sizeof(struct ftrace_page)) / sizeof(struct dyn_ftrace))
+((PAGE_SIZE - sizeof(struct ftrace_page)) / sizeof(struct dyn_ftrace))

 /* estimate from running different kernels */
 #define NR_TO_INIT		10000
@@ -2483,8 +2480,7 @@ function_trace_probe_call(unsigned long ip,
unsigned long parent_ip)
 	preempt_enable_notrace();
 }

-static struct ftrace_ops trace_probe_ops __read_mostly =
-{
+static struct ftrace_ops trace_probe_ops __read_mostly = {
 	.func		= function_trace_probe_call,
 };

-- 
1.7.4.1

