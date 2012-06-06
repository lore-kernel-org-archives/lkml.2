Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2FFNRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:17:53 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47355 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2FFNRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:17:52 -0400
MIME-Version: 1.0
Date: Wed, 6 Jun 2012 21:17:51 +0800
Message-ID: <CAJd=RBDApvTN9L77zxbmYnMEAT8fGcuViQ-x1E-3SPROudaJ1w@mail.gmail.com>
Subject: [patch] BFS 421: fix resched_closest_idle
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frankly it is not fix, but operating cpu_idle_map is not sane if idle_cpus is
not checked first, according to its define.

Btw, the helper will be removed soon as we no longer maintain the sticky bit.


--- a/kernel/sched/bfs.c	Wed Jun  6 20:04:50 2012
+++ b/kernel/sched/bfs.c	Wed Jun  6 20:06:38 2012
@@ -1055,6 +1055,8 @@ resched_closest_idle(struct rq *rq, int
 {
 	cpumask_t tmpmask;

+	if (!grq.idle_cpus)
+		return;
 	cpus_and(tmpmask, p->cpus_allowed, grq.cpu_idle_map);
 	cpu_clear(cpu, tmpmask);
 	if (cpus_empty(tmpmask))
--
