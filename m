Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab2FNMWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 08:22:16 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53502 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab2FNMWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 08:22:15 -0400
MIME-Version: 1.0
Date: Thu, 14 Jun 2012 20:22:14 +0800
Message-ID: <CAJd=RBBrSVk6bfXUtEr4fqXZf7rPun-DpU9f3YAJ=sgHnqciWQ@mail.gmail.com>
Subject: [patch] BFS 421: remove time_task_grq_lock_irq
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again do cleanup.


--- a/kernel/sched/bfs.c	Wed Jun 13 19:56:46 2012
+++ b/kernel/sched/bfs.c	Thu Jun 14 20:00:08 2012
@@ -535,12 +535,6 @@ static inline struct rq *task_grq_lock_i
 	return task_rq(p);
 }

-static inline void time_task_grq_lock_irq(struct task_struct *p)
-	__acquires(grq.lock)
-{
-	struct rq *rq = task_grq_lock_irq(p);
-	update_clocks(rq);
-}

 static inline void task_grq_unlock_irq(void)
 	__releases(grq.lock)
--
