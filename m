Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab1CWNtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:49:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:38721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932196Ab1CWNtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:49:36 -0400
Date: Wed, 23 Mar 2011 13:49:06 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        borislav.petkov@amd.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <1300815978-16618-1-git-send-email-bp@amd64.org>
References: <1300815978-16618-1-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched, doc: Update sched-design-CFS.txt
Message-ID: <tip-1232d6132a986125f6a687ab9b61a4330e319270@git.kernel.org>
Git-Commit-ID: 1232d6132a986125f6a687ab9b61a4330e319270
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Mar 2011 13:49:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1232d6132a986125f6a687ab9b61a4330e319270
Gitweb:     http://git.kernel.org/tip/1232d6132a986125f6a687ab9b61a4330e319270
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Tue, 22 Mar 2011 18:46:18 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Mar 2011 14:09:41 +0100

sched, doc: Update sched-design-CFS.txt

Correct ->dequeue_tree() thinko into sched_class->dequeue_task
and drop all references to ->task_new() since it is obviously
gone.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1300815978-16618-1-git-send-email-bp@amd64.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
