Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab2AUSGK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:06:10 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:59147 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751441Ab2AUSEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:04:46 -0500
Message-ID: <4F1B0BF1.8020503@xenotime.net>
Date: Sat, 21 Jan 2012 11:03:13 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 11/14] kernel-doc: fix kernel-doc warnings in sched
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix new kernel-doc notation warnings:

Warning(include/linux/sched.h:2094): No description found for parameter 'p'
Warning(include/linux/sched.h:2094): Excess function parameter 'tsk' description in 'is_idle_task'
Warning(kernel/sched/cpupri.c:139): No description found for parameter 'newpri'
Warning(kernel/sched/cpupri.c:139): Excess function parameter 'pri' description in 'cpupri_set'
Warning(kernel/sched/cpupri.c:208): Excess function parameter 'bootmem' description in 'cpupri_init'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Ingo Molnar <mingo@elte.hu>
Cc:	Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sched.h |    2 +-
 kernel/sched/cpupri.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- lnx-33-rc1.orig/include/linux/sched.h
+++ lnx-33-rc1/include/linux/sched.h
@@ -2088,7 +2088,7 @@ extern int sched_setscheduler_nocheck(st
 extern struct task_struct *idle_task(int cpu);
 /**
  * is_idle_task - is the specified task an idle task?
- * @tsk: the task in question.
+ * @p: the task in question.
  */
 static inline bool is_idle_task(struct task_struct *p)
 {
--- lnx-33-rc1.orig/kernel/sched/cpupri.c
+++ lnx-33-rc1/kernel/sched/cpupri.c
@@ -129,7 +129,7 @@ int cpupri_find(struct cpupri *cp, struc
  * cpupri_set - update the cpu priority setting
  * @cp: The cpupri context
  * @cpu: The target cpu
- * @pri: The priority (INVALID-RT99) to assign to this CPU
+ * @newpri: The priority (INVALID-RT99) to assign to this CPU
  *
  * Note: Assumes cpu_rq(cpu)->lock is locked
  *
@@ -200,7 +200,6 @@ void cpupri_set(struct cpupri *cp, int c
 /**
  * cpupri_init - initialize the cpupri structure
  * @cp: The cpupri context
- * @bootmem: true if allocations need to use bootmem
  *
  * Returns: -ENOMEM if memory fails.
  */
