Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030846Ab2CUOMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:12:20 -0400
Received: from seven.medozas.de ([188.40.89.202]:40783 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030317Ab2CUOMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:12:19 -0400
From: Jan Engelhardt <jengelh@medozas.de>
To: akpm@linux-foundation.org
Cc: gorcunov@openvz.org, linux-kernel@vger.kernel.org, jengelh@medozas.de
Subject: [PATCH] procfs: use more apprioriate types when dumping /proc/N/stat
Date: Wed, 21 Mar 2012 15:12:16 +0100
Message-Id: <1332339136-26022-1-git-send-email-jengelh@medozas.de>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* field 14, 15: clock_t is a long
* field 18, 19: task_nice/task_prio return int
* field 24: get_mm_rss returns unsigned long
* field 36, 37: always 0

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 fs/proc/array.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index c602b8d..1451dd6 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -361,7 +361,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task, int whole)
 {
 	unsigned long vsize, eip, esp, wchan = ~0UL;
-	long priority, nice;
+	int priority, nice;
 	int tty_pgrp = -1, tty_nr = 0;
 	sigset_t sigign, sigcatch;
 	char state;
@@ -463,8 +463,8 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	start_time = nsec_to_clock_t(start_time);
 
 	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
-%lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
-%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
+%lu %lu %lu %ld %ld %ld %ld %d %d %d 0 %llu %lu %lu %lu %lu %lu %lu %lu \
+%lu %lu %lu %lu %lu %lu 0 0 %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
 		pid_nr_ns(pid, ns),
 		tcomm,
 		state,
@@ -503,8 +503,6 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		sigign      .sig[0] & 0x7fffffffUL,
 		sigcatch    .sig[0] & 0x7fffffffUL,
 		wchan,
-		0UL,
-		0UL,
 		task->exit_signal,
 		task_cpu(task),
 		task->rt_priority,
-- 
1.7.7

