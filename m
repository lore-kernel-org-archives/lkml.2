Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab2DJOZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:25:36 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54376 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758759Ab2DJOZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:25:35 -0400
MIME-Version: 1.0
Date: Tue, 10 Apr 2012 22:25:33 +0800
Message-ID: <CAJd=RBAsSHp2KSnwF6h1fYCQyMCA-Lg31WNr9eTbuenkAU+vbw@mail.gmail.com>
Subject: [patch] DLS: fix switched_from_dl
From: Hillf Danton <dhillf@gmail.com>
To: Dario Faggioli <raistlin@linux.it>, Juri Lelli <juri.lelli@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pull only if the current task switches from DLS, since it was not preempted
by pushable tasks waiting on other runqueues.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched_dl.c	Mon Apr  9 19:39:56 2012
+++ b/kernel/sched_dl.c	Tue Apr 10 21:23:52 2012
@@ -1466,12 +1466,7 @@ static void switched_from_dl(struct rq *
 		hrtimer_try_to_cancel(&p->dl.dl_timer);

 #ifdef CONFIG_SMP
-	/*
-	 * Since this might be the only -deadline task on the rq,
-	 * this is the right place to try to pull some other one
-	 * from an overloaded cpu, if any.
-	 */
-	if (!rq->dl.dl_nr_running)
+	if (p == rq->curr)
 		pull_dl_task(rq);
 #endif
 }
--
