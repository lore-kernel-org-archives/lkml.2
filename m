Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab1DWN3K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 09:29:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57104 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab1DWN3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 09:29:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=gM49+MZl02KEEdihAxOmaLvvPDlCh2V7yXnfJJCpVNsnI+ki6QY5pF8GsCzrTy8eTt
         AyArIYiAksHZhliI5HTT05LpTS6aQa8JEMxcAu/z1enEGyoqwKv80B6dgIm/bhhlax0X
         QphZ4SK2FzK7UEcHBX9e0TT2SJ3RlSG1Mdm3I=
MIME-Version: 1.0
Date: Sat, 23 Apr 2011 21:29:05 +0800
Message-ID: <BANLkTin-FfQfqW5ym1iuEmrk8s777Y1LAg@mail.gmail.com>
Subject: [PATCH] sched: remove noop in alloc_rt_sched_group()
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rq varible, though computed for each possible cpu, has nothing to
do in the function, so it could be removed.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched.c	2011-03-30 03:09:48.000000000 +0800
+++ b/kernel/sched.c	2011-04-23 21:23:48.000000000 +0800
@@ -8539,7 +8539,6 @@ int alloc_rt_sched_group(struct task_gro
 {
 	struct rt_rq *rt_rq;
 	struct sched_rt_entity *rt_se;
-	struct rq *rq;
 	int i;

 	tg->rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
@@ -8553,8 +8552,6 @@ int alloc_rt_sched_group(struct task_gro
 			ktime_to_ns(def_rt_bandwidth.rt_period), 0);

 	for_each_possible_cpu(i) {
-		rq = cpu_rq(i);
-
 		rt_rq = kzalloc_node(sizeof(struct rt_rq),
 				     GFP_KERNEL, cpu_to_node(i));
 		if (!rt_rq)
