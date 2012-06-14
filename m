Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab2FNMXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 08:23:13 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33147 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab2FNMXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 08:23:11 -0400
MIME-Version: 1.0
Date: Thu, 14 Jun 2012 20:23:10 +0800
Message-ID: <CAJd=RBDh44Ka2YPrEGy1SYBngNDmD76O92+D11f8nJh-oNjf4g@mail.gmail.com>
Subject: [patch] BFS 421: use NS_TO_MS
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets easy reader once more.


--- a/kernel/sched/bfs.c	Thu Jun 14 20:01:50 2012
+++ b/kernel/sched/bfs.c	Thu Jun 14 20:03:42 2012
@@ -992,15 +992,11 @@ static void activate_task(struct task_st
 {
 	update_clocks(rq);

-	/*
-	 * Sleep time is in units of nanosecs, so shift by 20 to get a
-	 * milliseconds-range estimation of the amount of time that the task
-	 * spent sleeping:
-	 */
+	/* Sleep time is tracked in units of nanosecs, but reported in ms */
 	if (unlikely(prof_on == SLEEP_PROFILING)) {
 		if (p->state == TASK_UNINTERRUPTIBLE)
 			profile_hits(SLEEP_PROFILING, (void *)get_wchan(p),
-				     (rq->clock - p->last_ran) >> 20);
+					NS_TO_MS(rq->clock - p->last_ran));
 	}

 	p->prio = effective_prio(p);
--
