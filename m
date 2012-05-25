Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab2EYNmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:42:00 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53358 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2EYNl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:41:58 -0400
MIME-Version: 1.0
Date: Fri, 25 May 2012 21:41:57 +0800
Message-ID: <CAJd=RBDvKvMykzzZYk7=j=bwX7kC7J3H0vv33_vwbVMw+w4OMw@mail.gmail.com>
Subject: [patch] BFS 420: get correct runqueue when waking up newly created task
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When waking up newly created task, runqueue should be determined based on the
parent task for correctly checking if the current task is parent.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Fri May 25 20:07:06 2012
@@ -1771,7 +1771,7 @@ void wake_up_new_task(struct task_struct
 	unsigned long flags;
 	struct rq *rq;

-	rq = task_grq_lock(p, &flags);
+	rq = task_grq_lock(p->parent, &flags);
 	p->state = TASK_RUNNING;
 	parent = p->parent;
 	/* Unnecessary but small chance that the parent changed CPU */
--
