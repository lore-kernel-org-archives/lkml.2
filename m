Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab2E0Lp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 07:45:28 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46030 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2E0LpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 07:45:25 -0400
MIME-Version: 1.0
Date: Sun, 27 May 2012 19:45:24 +0800
Message-ID: <CAJd=RBBKk5ObBaaWGRiAbM1qf3EeuMBPKLPy65qV3qxgM5pbTQ@mail.gmail.com>
Subject: [patch] BFS 420: no update of task cpu when changing cpu affinity
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since task cpu is involved in the computation of difference of locality, we
have to delay updating it until the task will be taken off the global runqueue.

If given task is a sleeper, no problem since it has to be activated first.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Sun May 27 09:38:00 2012
@@ -5117,8 +5117,7 @@ int set_cpus_allowed_ptr(struct task_str
 			running_wrong = true;
 		} else
 			resched_task(p);
-	} else
-		set_task_cpu(p, cpumask_any_and(cpu_active_mask, new_mask));
+	}

 out:
 	if (queued)
--
