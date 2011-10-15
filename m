Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1JONOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 09:14:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45415 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab1JONO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 09:14:29 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 4/5] include/linux/sem.h: make sysv_sem empty if SYSVIPC is disabled
Date: Sat, 15 Oct 2011 15:21:55 +0200
Message-Id: <1318684915-2005-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the sysvsem undo, each task struct contains a sysv_sem structure
with a pointer to the undo information.
This pointer is only necessary if sysvipc is enabled - thus
the pointer can be made conditional on CONFIG_SYSVIPC.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 include/linux/sem.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/sem.h b/include/linux/sem.h
index 4648426..10d6b22 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -96,16 +96,21 @@ struct sem_array {
 	int			complex_count;	/* pending complex operations */
 };
 
+#ifdef CONFIG_SYSVIPC
+
 struct sysv_sem {
 	struct sem_undo_list *undo_list;
 };
 
-#ifdef CONFIG_SYSVIPC
-
 extern int copy_semundo(unsigned long clone_flags, struct task_struct *tsk);
 extern void exit_sem(struct task_struct *tsk);
 
 #else
+
+struct sysv_sem {
+	/* empty */
+};
+
 static inline int copy_semundo(unsigned long clone_flags, struct task_struct *tsk)
 {
 	return 0;
-- 
1.7.6.4

