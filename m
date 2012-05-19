Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab2ESHXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 03:23:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42984 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab2ESHXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 03:23:16 -0400
MIME-Version: 1.0
Date: Sat, 19 May 2012 15:23:16 +0800
Message-ID: <CAJd=RBBomAmcyxQKptdJUsmCH=TR9fL6-yfnmRtFK_S4xn56LQ@mail.gmail.com>
Subject: Re: BFS 420: cleanup in tick handling
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu on stack is not needed, so remove it.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Sat May 19 15:18:24 2012
@@ -2822,8 +2822,7 @@ void wake_up_idle_cpu(int cpu);
  */
 void scheduler_tick(void)
 {
-	int cpu __maybe_unused = smp_processor_id();
-	struct rq *rq = cpu_rq(cpu);
+	struct rq *rq = this_rq();

 	sched_clock_tick();
 	/* grq lock not grabbed, so only update rq clock */
--
