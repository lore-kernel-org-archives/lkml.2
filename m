Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab1HQNg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:36:58 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33657 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab1HQNgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:36:54 -0400
From: Geunsik Lim <leemgs1@gmail.com>
To: Jiri Kosina <trivial@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] trivial: helpful task_struct remarks
Date: Wed, 17 Aug 2011 22:36:43 +0900
Message-Id: <1313588203-7489-1-git-send-email-leemgs1@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geunsik Lim <geunsik.lim@samsung.com>

This is trivial patch for helpful description of task_struct elements.
'???' remark is not good as a description of data structure.
And, append description information about the meanings of pid and tgid.

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 include/linux/sched.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ac2c05..1a078f8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1293,8 +1293,7 @@ struct task_struct {
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
 	unsigned int jobctl;	/* JOBCTL_*, siglock protected */
-	/* ??? */
-	unsigned int personality;
+	unsigned int personality; /* Personality types of process */
 	unsigned did_exec:1;
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
@@ -1305,8 +1304,8 @@ struct task_struct {
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
 
-	pid_t pid;
-	pid_t tgid;
+	pid_t pid; /* Process ID, return value of gettid system call */
+	pid_t tgid; /* Thread group ID, return value of getpid system call */
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 	/* Canary value for the -fstack-protector gcc feature */
-- 
1.7.1

