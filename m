Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab1BBWDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:03:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:50084 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab1BBWDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:03:15 -0500
Date: Wed, 2 Feb 2011 22:03:04 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134419.389755466@linutronix.de>
References: <20110201134419.389755466@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Make posix-cpu-timers functions static
Message-ID: <tip-bc2c8ea483d73e95fc88f1fc9e7755180f89b892@git.kernel.org>
Git-Commit-ID: bc2c8ea483d73e95fc88f1fc9e7755180f89b892
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 22:03:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc2c8ea483d73e95fc88f1fc9e7755180f89b892
Gitweb:     http://git.kernel.org/tip/bc2c8ea483d73e95fc88f1fc9e7755180f89b892
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:52:12 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:17 +0100

posix-timers: Make posix-cpu-timers functions static

All functions are accessed via clock_posix_cpu now. So make them static.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134419.389755466@linutronix.de>
---
 include/linux/posix-timers.h |   12 ------------
 kernel/posix-cpu-timers.c    |   27 +++++++++++++++------------
 2 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index ef574d1..8206255 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -91,18 +91,6 @@ void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock);
 /* function to call to trigger timer event */
 int posix_timer_event(struct k_itimer *timr, int si_private);
 
-int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *ts);
-int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *ts);
-int posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *ts);
-int posix_cpu_timer_create(struct k_itimer *timer);
-int posix_cpu_nsleep(const clockid_t which_clock, int flags,
-		     struct timespec *rqtp, struct timespec __user *rmtp);
-long posix_cpu_nsleep_restart(struct restart_block *restart_block);
-int posix_cpu_timer_set(struct k_itimer *timer, int flags,
-			struct itimerspec *new, struct itimerspec *old);
-int posix_cpu_timer_del(struct k_itimer *timer);
-void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp);
-
 void posix_cpu_timer_schedule(struct k_itimer *timer);
 
 void run_posix_cpu_timers(struct task_struct *task);
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 504fbab..609e187 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -176,7 +176,8 @@ static inline cputime_t virt_ticks(struct task_struct *p)
 	return p->utime;
 }
 
-int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
+static int
+posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
 {
 	int error = check_clock(which_clock);
 	if (!error) {
@@ -194,7 +195,8 @@ int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
 	return error;
 }
 
-int posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *tp)
+static int
+posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *tp)
 {
 	/*
 	 * You can never reset a CPU clock, but we check for other errors
@@ -317,7 +319,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 }
 
 
-int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
+static int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 {
 	const pid_t pid = CPUCLOCK_PID(which_clock);
 	int error = -EINVAL;
@@ -379,7 +381,7 @@ int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
  * This is called from sys_timer_create() and do_cpu_nanosleep() with the
  * new timer already all-zeros initialized.
  */
-int posix_cpu_timer_create(struct k_itimer *new_timer)
+static int posix_cpu_timer_create(struct k_itimer *new_timer)
 {
 	int ret = 0;
 	const pid_t pid = CPUCLOCK_PID(new_timer->it_clock);
@@ -425,7 +427,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
  * If we return TIMER_RETRY, it's necessary to release the timer's lock
  * and try again.  (This happens when the timer is in the middle of firing.)
  */
-int posix_cpu_timer_del(struct k_itimer *timer)
+static int posix_cpu_timer_del(struct k_itimer *timer)
 {
 	struct task_struct *p = timer->it.cpu.task;
 	int ret = 0;
@@ -665,8 +667,8 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
  * If we return TIMER_RETRY, it's necessary to release the timer's lock
  * and try again.  (This happens when the timer is in the middle of firing.)
  */
-int posix_cpu_timer_set(struct k_itimer *timer, int flags,
-			struct itimerspec *new, struct itimerspec *old)
+static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
+			       struct itimerspec *new, struct itimerspec *old)
 {
 	struct task_struct *p = timer->it.cpu.task;
 	union cpu_time_count old_expires, new_expires, old_incr, val;
@@ -820,7 +822,7 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	return ret;
 }
 
-void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
+static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 {
 	union cpu_time_count now;
 	struct task_struct *p = timer->it.cpu.task;
@@ -1481,8 +1483,10 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
 	return error;
 }
 
-int posix_cpu_nsleep(const clockid_t which_clock, int flags,
-		     struct timespec *rqtp, struct timespec __user *rmtp)
+static long posix_cpu_nsleep_restart(struct restart_block *restart_block);
+
+static int posix_cpu_nsleep(const clockid_t which_clock, int flags,
+			    struct timespec *rqtp, struct timespec __user *rmtp)
 {
 	struct restart_block *restart_block =
 		&current_thread_info()->restart_block;
@@ -1517,7 +1521,7 @@ int posix_cpu_nsleep(const clockid_t which_clock, int flags,
 	return error;
 }
 
-long posix_cpu_nsleep_restart(struct restart_block *restart_block)
+static long posix_cpu_nsleep_restart(struct restart_block *restart_block)
 {
 	clockid_t which_clock = restart_block->nanosleep.index;
 	struct timespec t;
@@ -1542,7 +1546,6 @@ long posix_cpu_nsleep_restart(struct restart_block *restart_block)
 
 }
 
-
 #define PROCESS_CLOCK	MAKE_PROCESS_CPUCLOCK(0, CPUCLOCK_SCHED)
 #define THREAD_CLOCK	MAKE_THREAD_CPUCLOCK(0, CPUCLOCK_SCHED)
 
