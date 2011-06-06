Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1FFKxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:53:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45599 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab1FFKxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:53:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mVvOIFxv46xynrlXPl19CiVU8Hhkq2xChE/e0d/jU5W6gYElbR+yRfuXqu0bLwCmOb
         /0E7JdVVXlCKogmU6RxOXUZ6Y7FgJ008NXJwi1cxPtkcdxUQ2AP6TI36TM+z9tP3doxn
         oo0q1OJ11Ziau+wKyPG6pls1usFxKoAX7CSKA=
From: Connor Hansen <cmdkhh@gmail.com>
To: tj@kernel.org
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
        Connor Hansen <cmdkhh@gmail.com>
Subject: [PATCH] kernel/async.c: Add missing loglevel to initcall_debug printks
Date: Mon,  6 Jun 2011 03:52:44 -0700
Message-Id: <1307357564-5258-1-git-send-email-cmdkhh@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk messages in initcall_debug checks are informational
and should be marked with the KERN_INFO log level.

Signed-off-by: Connor Hansen <cmdkhh@gmail.com>
---
 kernel/async.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index cd9dbb9..c25f9c1 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -128,7 +128,8 @@ static void async_run_entry_fn(struct work_struct *work)
 
 	/* 2) run (and print duration) */
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		printk("calling  %lli_%pF @ %i\n", (long long)entry->cookie,
+		printk(KERN_INFO "calling  %lli_%pF @ %i\n",
+			(long long)entry->cookie,
 			entry->func, task_pid_nr(current));
 		calltime = ktime_get();
 	}
@@ -136,7 +137,7 @@ static void async_run_entry_fn(struct work_struct *work)
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		rettime = ktime_get();
 		delta = ktime_sub(rettime, calltime);
-		printk("initcall %lli_%pF returned 0 after %lld usecs\n",
+		printk(KERN_INFO "initcall %lli_%pF returned 0 after %lld usecs\n",
 			(long long)entry->cookie,
 			entry->func,
 			(long long)ktime_to_ns(delta) >> 10);
@@ -270,7 +271,8 @@ void async_synchronize_cookie_domain(async_cookie_t cookie,
 	ktime_t starttime, delta, endtime;
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		printk("async_waiting @ %i\n", task_pid_nr(current));
+		printk(KERN_INFO "async_waiting @ %i\n",
+			task_pid_nr(current));
 		starttime = ktime_get();
 	}
 
@@ -280,7 +282,7 @@ void async_synchronize_cookie_domain(async_cookie_t cookie,
 		endtime = ktime_get();
 		delta = ktime_sub(endtime, starttime);
 
-		printk("async_continuing @ %i after %lli usec\n",
+		printk(KERN_INFO "async_continuing @ %i after %lli usec\n",
 			task_pid_nr(current),
 			(long long)ktime_to_ns(delta) >> 10);
 	}
-- 
1.7.4.4

