Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552Ab1FABcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 21:32:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36990 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758218Ab1FABci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 21:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=f5Zan5EqDsoBiUeCTxT96jxLN0UKhZW3X2e44iDbG+ASb4ojNrEYTwxPCTQj9tIDWQ
         j6DXDa5ggxXIgBsHh1FdILbxXXs9OaO1ZJGnKMsy8VdlPpAjYd5Aein9+NrzyA8vT27o
         q9+bhvQOaUeR+e2CAILPRgVCWvY7Rzabc1lsw=
Message-ID: <4DE596B4.7030904@gmail.com>
Date: Wed, 01 Jun 2011 02:32:36 +0100
From: Paul McQuade <tungstentide@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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

async:
Added <linux/atomic.h>,<linux/ktime.h> and Removed <asm/atomic.h>.
Added KERN_DEBUG to printk() functions.

Signed-off-by: Paul McQuade <tungstentide@gmail.com>
---
 kernel/async.c        |   13 +++++++------
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

