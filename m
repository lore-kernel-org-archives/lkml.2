Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab2EVMpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:45:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61741 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab2EVMpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:45:10 -0400
MIME-Version: 1.0
Date: Tue, 22 May 2012 20:45:10 +0800
Message-ID: <CAJd=RBDRA6s5aV0rg+uknsML60Z0q8wXC1wgh7KQ+SoSSSQf-g@mail.gmail.com>
Subject: Re: BFS 420: try to preempt after checking priority
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will not try to preempt running tasks if no increment in priority,
to shorten the hold time of global run-queue lock.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Tue May 22 20:03:58 2012
@@ -3853,7 +3853,8 @@ void rt_mutex_setprio(struct task_struct
 		resched_task(p);
 	if (queued) {
 		enqueue_task(p);
-		try_preempt(p, rq);
+		if (prio < oldprio)
+			try_preempt(p, rq);
 	}

 	task_grq_unlock(&flags);
--
