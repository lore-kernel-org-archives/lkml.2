Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab1CVRqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 13:46:33 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58950 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452Ab1CVRqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 13:46:30 -0400
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <peterz@infradead.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] sched, doc: Update sched-design-CFS.txt
Date: Tue, 22 Mar 2011 18:46:18 +0100
Message-Id: <1300815978-16618-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Correct ->dequeue_tree() thinko into sched_class->dequeue_task and drop
all references to ->task_new() since it is obviously gone.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 Documentation/scheduler/sched-design-CFS.txt |    7 +------
 kernel/sched_idletask.c                      |    2 --
 kernel/sched_stoptask.c                      |    2 --
 3 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/Documentation/scheduler/sched-design-CFS.txt b/Documentation/scheduler/sched-design-CFS.txt
index 8239ebb..9996199 100644
--- a/Documentation/scheduler/sched-design-CFS.txt
+++ b/Documentation/scheduler/sched-design-CFS.txt
@@ -164,7 +164,7 @@ This is the (partial) list of the hooks:
    It puts the scheduling entity (task) into the red-black tree and
    increments the nr_running variable.
 
- - dequeue_tree(...)
+ - dequeue_task(...)
 
    When a task is no longer runnable, this function is called to keep the
    corresponding scheduling entity out of the red-black tree.  It decrements
@@ -195,11 +195,6 @@ This is the (partial) list of the hooks:
    This function is mostly called from time tick functions; it might lead to
    process switch.  This drives the running preemption.
 
- - task_new(...)
-
-   The core scheduler gives the scheduling module an opportunity to manage new
-   task startup.  The CFS scheduling module uses it for group scheduling, while
-   the scheduling module for a real-time task does not use it.
 
 
 
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index c82f26c..a776a63 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -94,6 +94,4 @@ static const struct sched_class idle_sched_class = {
 
 	.prio_changed		= prio_changed_idle,
 	.switched_to		= switched_to_idle,
-
-	/* no .task_new for idle tasks */
 };
diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
index 84ec9bc..1ba2bd4 100644
--- a/kernel/sched_stoptask.c
+++ b/kernel/sched_stoptask.c
@@ -102,6 +102,4 @@ static const struct sched_class stop_sched_class = {
 
 	.prio_changed		= prio_changed_stop,
 	.switched_to		= switched_to_stop,
-
-	/* no .task_new for stop tasks */
 };
-- 
1.7.4.rc2

