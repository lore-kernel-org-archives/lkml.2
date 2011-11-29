Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1LCIUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 03:20:52 -0500
Received: from www17.your-server.de ([213.133.104.17]:58076 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab1LCIUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 03:20:51 -0500
Subject: [PATCH] sched: Use kcalloc instead of kzalloc to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.348.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/kernel/rcutorture.c b/kernel/rcutorture.c
--- a/kernel/rcutorture.c 2011-11-13 11:08:11.807536650 +0100
+++ b/kernel/rcutorture.c 2011-11-28 20:09:11.653518946 +0100
@@ -1494,7 +1494,7 @@ rcu_torture_init(void)
 		writer_task = NULL;
 		goto unwind;
 	}
-	fakewriter_tasks = kzalloc(nfakewriters * sizeof(fakewriter_tasks[0]),
+	fakewriter_tasks = kcalloc(nfakewriters, sizeof(fakewriter_tasks[0]),
 				   GFP_KERNEL);
 	if (fakewriter_tasks == NULL) {
 		VERBOSE_PRINTK_ERRSTRING("out of memory");
@@ -1512,7 +1512,7 @@ rcu_torture_init(void)
 			goto unwind;
 		}
 	}
-	reader_tasks = kzalloc(nrealreaders * sizeof(reader_tasks[0]),
+	reader_tasks = kcalloc(nrealreaders, sizeof(reader_tasks[0]),
 			       GFP_KERNEL);
 	if (reader_tasks == NULL) {
 		VERBOSE_PRINTK_ERRSTRING("out of memory");
diff -u -p a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c 2011-11-13 11:08:11.917538384 +0100
+++ b/kernel/sched.c 2011-11-28 20:09:30.620411188 +0100
@@ -8527,10 +8527,10 @@ int alloc_fair_sched_group(struct task_g
 	struct sched_entity *se;
 	int i;
 
-	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * nr_cpu_ids, GFP_KERNEL);
+	tg->cfs_rq = kcalloc(nr_cpu_ids, sizeof(cfs_rq), GFP_KERNEL);
 	if (!tg->cfs_rq)
 		goto err;
-	tg->se = kzalloc(sizeof(se) * nr_cpu_ids, GFP_KERNEL);
+	tg->se = kcalloc(nr_cpu_ids, sizeof(se), GFP_KERNEL);
 	if (!tg->se)
 		goto err;
 
@@ -8619,10 +8619,10 @@ int alloc_rt_sched_group(struct task_gro
 	struct sched_rt_entity *rt_se;
 	int i;
 
-	tg->rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
+	tg->rt_rq = kcalloc(nr_cpu_ids, sizeof(rt_rq), GFP_KERNEL);
 	if (!tg->rt_rq)
 		goto err;
-	tg->rt_se = kzalloc(sizeof(rt_se) * nr_cpu_ids, GFP_KERNEL);
+	tg->rt_se = kcalloc(nr_cpu_ids, sizeof(rt_se), GFP_KERNEL);
 	if (!tg->rt_se)
 		goto err;
 
