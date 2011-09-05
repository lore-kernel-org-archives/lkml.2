Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab1IESqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 14:46:11 -0400
Received: from li271-223.members.linode.com ([178.79.152.223]:46168 "EHLO
	mail.mleia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab1IESqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:46:03 -0400
From: Vladimir Zapolskiy <vz@mleia.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] sched: share task comm length value to userspace
Date: Mon,  5 Sep 2011 21:38:01 +0300
Message-Id: <1315247881-31597-1-git-send-email-vz@mleia.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change allows to get a defined length of task comm in
userspace. For a moment this value is implied at least in two cases:
* max length of comm value got from /proc/$pid/stat
* max string length argument of prctl(PR_[SG]ET_NAME, ...)

For these reasons it becomes desirable to impart task comm max length
value to userspace.

Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
---
 include/linux/sched.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ac2c05..21d300b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -42,6 +42,9 @@
 /* Can be ORed in to make sure the process is reverted back to SCHED_NORMAL on fork */
 #define SCHED_RESET_ON_FORK     0x40000000
 
+/* Task command name length */
+#define TASK_COMM_LEN 16
+
 #ifdef __KERNEL__
 
 struct sched_param {
@@ -242,9 +245,6 @@ extern char ___assert_task_state[1 - 2*!!(
 #define set_current_state(state_value)		\
 	set_mb(current->state, (state_value))
 
-/* Task command name length */
-#define TASK_COMM_LEN 16
-
 #include <linux/spinlock.h>
 
 /*
-- 
1.7.5.4

