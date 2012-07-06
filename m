Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab2GFM0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:26:55 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45031 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab2GFM0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 08:26:54 -0400
MIME-Version: 1.0
Date: Fri, 6 Jul 2012 20:26:53 +0800
Message-ID: <CAJd=RBCe7VoW9yeV9eBfA0J-SAvdRcM=YG3ZpPybu53Ecaqyvw@mail.gmail.com>
Subject: [patch] BFS 421-1: use cpu_of
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU is available after runqueue determined.

SOB: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched/bfs.c	Fri Jul  6 20:12:30 2012
+++ b/kernel/sched/bfs.c	Fri Jul  6 20:13:00 2012
@@ -1448,7 +1448,7 @@ static void ttwu_stat(struct task_struct
 	struct rq *rq = this_rq();
 #ifdef CONFIG_SMP
 	if (success)
-		p->wakeup_cpu = smp_processor_id();
+		p->wakeup_cpu = cpu_of(rq);
 #else
 	schedstat_inc(rq, ttwu_local);
 #endif
--
