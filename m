Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab2GVVME (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 17:12:04 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32788 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2GVVMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 17:12:01 -0400
From: Fredrik Gustafsson <iveqy@iveqy.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Fredrik Gustafsson <iveqy@iveqy.com>
Subject: [PATCH] [timer] Cleaned up according to scripts/check_patch.pl
Date: Sun, 22 Jul 2012 23:11:45 +0200
Message-Id: <1342991505-18947-1-git-send-email-iveqy@iveqy.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's still 6 warnings left:
* WARNING: EXPORT_SYMBOL(foo); should immediately follow its
  function/variable

	This is an error in check_patch.pl

* WARNING: quoted string split across lines 1516: FILE: timer.c:1516:

	Is left unsolved because of lack of a good solution.

* WARNING: line over 80 characters

	Is not fixed, see https://lkml.org/lkml/2012/2/3/394

Signed-off-by: Fredrik Gustafsson <iveqy@iveqy.com>
---
 kernel/timer.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 6ec7e7e..a5ece2a 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -40,18 +40,16 @@
 #include <linux/irq_work.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-
-#include <asm/uaccess.h>
-#include <asm/unistd.h>
-#include <asm/div64.h>
-#include <asm/timex.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/unistd.h>
+#include <linux/div64.h>
+#include <linux/timex.h>
+#include <linux/io.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/timer.h>
 
 u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
-
 EXPORT_SYMBOL(jiffies_64);
 
 /*
@@ -91,12 +89,12 @@ static DEFINE_PER_CPU(struct tvec_base *, tvec_bases) = &boot_tvec_bases;
 /* Functions below help us manage 'deferrable' flag */
 static inline unsigned int tbase_get_deferrable(struct tvec_base *base)
 {
-	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
+	return (unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG;
 }
 
 static inline struct tvec_base *tbase_get_base(struct tvec_base *base)
 {
-	return ((struct tvec_base *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
+	return (struct tvec_base *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG);
 }
 
 static inline void timer_set_deferrable(struct timer_list *timer)
@@ -1171,7 +1169,7 @@ static inline void __run_timers(struct tvec_base *base)
 			void (*fn)(unsigned long);
 			unsigned long data;
 
-			timer = list_first_entry(head, struct timer_list,entry);
+			timer = list_first_entry(head, struct timer_list, entry);
 			fn = timer->function;
 			data = timer->data;
 
@@ -1494,8 +1492,7 @@ signed long __sched schedule_timeout(signed long timeout)
 	struct timer_list timer;
 	unsigned long expire;
 
-	switch (timeout)
-	{
+	switch (timeout) {
 	case MAX_SCHEDULE_TIMEOUT:
 		/*
 		 * These two special cases are useful to be comfortable
@@ -1515,7 +1512,7 @@ signed long __sched schedule_timeout(signed long timeout)
 		 * that will tell you if something is gone wrong and where.
 		 */
 		if (timeout < 0) {
-			printk(KERN_ERR "schedule_timeout: wrong timeout "
+			pr_err("schedule_timeout: wrong timeout "
 				"value %lx\n", timeout);
 			dump_stack();
 			current->state = TASK_RUNNING;
@@ -1762,7 +1759,7 @@ static int __cpuinit timer_cpu_notify(struct notifier_block *self,
 	long cpu = (long)hcpu;
 	int err;
 
-	switch(action) {
+	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		err = init_timers_cpu(cpu);
@@ -1809,7 +1806,6 @@ void msleep(unsigned int msecs)
 	while (timeout)
 		timeout = schedule_timeout_uninterruptible(timeout);
 }
-
 EXPORT_SYMBOL(msleep);
 
 /**
@@ -1824,7 +1820,6 @@ unsigned long msleep_interruptible(unsigned int msecs)
 		timeout = schedule_timeout_interruptible(timeout);
 	return jiffies_to_msecs(timeout);
 }
-
 EXPORT_SYMBOL(msleep_interruptible);
 
 static int __sched do_usleep_range(unsigned long min, unsigned long max)
-- 
1.7.2.5

