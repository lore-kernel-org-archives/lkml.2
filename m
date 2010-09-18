Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0IRKXD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 06:23:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:42781 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507Ab0IRKW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 06:22:57 -0400
Date: Sat, 18 Sep 2010 10:22:29 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        namhyung@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1284468228-8723-2-git-send-email-namhyung@gmail.com>
References: <1284468228-8723-2-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/futexes] futex: Mark restart_block.futex.uaddr[2] __user
Message-ID: <tip-a3c74c52570c0c4ac90c9a0216de800c39089ba7@git.kernel.org>
Git-Commit-ID: a3c74c52570c0c4ac90c9a0216de800c39089ba7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 18 Sep 2010 10:22:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3c74c52570c0c4ac90c9a0216de800c39089ba7
Gitweb:     http://git.kernel.org/tip/a3c74c52570c0c4ac90c9a0216de800c39089ba7
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 14 Sep 2010 21:43:47 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 18 Sep 2010 12:19:21 +0200

futex: Mark restart_block.futex.uaddr[2] __user

@uaddr and @uaddr2 fields in restart_block.futex are user
pointers. Add __user and remove unnecessary casts.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Darren Hart <dvhltc@us.ibm.com>
LKML-Reference: <1284468228-8723-2-git-send-email-namhyung@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/thread_info.h |    4 ++--
 kernel/futex.c              |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index a8cc4e1..c906965 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -23,12 +23,12 @@ struct restart_block {
 		};
 		/* For futex_wait and futex_wait_requeue_pi */
 		struct {
-			u32 *uaddr;
+			u32 __user *uaddr;
 			u32 val;
 			u32 flags;
 			u32 bitset;
 			u64 time;
-			u32 *uaddr2;
+			u32 __user *uaddr2;
 		} futex;
 		/* For nanosleep */
 		struct {
diff --git a/kernel/futex.c b/kernel/futex.c
index 464de27..45e448a 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1843,7 +1843,7 @@ retry:
 
 	restart = &current_thread_info()->restart_block;
 	restart->fn = futex_wait_restart;
-	restart->futex.uaddr = (u32 *)uaddr;
+	restart->futex.uaddr = uaddr;
 	restart->futex.val = val;
 	restart->futex.time = abs_time->tv64;
 	restart->futex.bitset = bitset;
@@ -1869,7 +1869,7 @@ out:
 
 static long futex_wait_restart(struct restart_block *restart)
 {
-	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
+	u32 __user *uaddr = restart->futex.uaddr;
 	int fshared = 0;
 	ktime_t t, *tp = NULL;
 
