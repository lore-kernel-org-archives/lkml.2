Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab2DCJUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 05:20:23 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:58047 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751572Ab2DCJTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 05:19:51 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+0spZv2FO0lq4ZB+FvxR8oE617e06tNeRYcvN8T/
	aRiwpyW1gyRqEs
Message-ID: <1333444788.9072.9.camel@marge.simpson.net>
Subject: [patch] sched,rt: let the user see rt queues in /proc/sched_debug
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 03 Apr 2012 11:19:48 +0200
In-Reply-To: <1333444106.9072.4.camel@marge.simpson.net>
References: <1333444106.9072.4.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ec514c48 made rt queues invisible in sched_debug, restore visibility.

Signed-off-by: Mike Galbraith <efault@gmx.de>
---
 kernel/sched/rt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2079,11 +2079,10 @@ extern void print_rt_rq(struct seq_file
 
 void print_rt_stats(struct seq_file *m, int cpu)
 {
-	rt_rq_iter_t iter;
 	struct rt_rq *rt_rq;
 
 	rcu_read_lock();
-	for_each_rt_rq(rt_rq, iter, cpu_rq(cpu))
+	for_each_leaf_rt_rq(rt_rq, cpu_rq(cpu))
 		print_rt_rq(m, cpu, rt_rq);
 	rcu_read_unlock();
 }


