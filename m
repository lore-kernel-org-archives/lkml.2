Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1DZM60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:58:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:38000 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478Ab1DZM6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:58:24 -0400
Date: Tue, 26 Apr 2011 12:58:01 GMT
From: tip-bot for Hillf Danton <dhillf@gmail.com>
Message-ID: <tip-1437f5bca3c2d162f058cba37dfbeb20f619040d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dhillf@gmail.com, a.p.zijlstra@chello.nl, yong.zhang0@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhillf@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        yong.zhang0@gmail.com, mingo@elte.hu
In-Reply-To: <BANLkTin-FfQfqW5ym1iuEmrk8s777Y1LAg@mail.gmail.com>
References: <BANLkTin-FfQfqW5ym1iuEmrk8s777Y1LAg@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove noop in alloc_rt_sched_group()
Git-Commit-ID: 1437f5bca3c2d162f058cba37dfbeb20f619040d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Apr 2011 12:58:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1437f5bca3c2d162f058cba37dfbeb20f619040d
Gitweb:     http://git.kernel.org/tip/1437f5bca3c2d162f058cba37dfbeb20f619040d
Author:     Hillf Danton <dhillf@gmail.com>
AuthorDate: Sat, 23 Apr 2011 21:29:05 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 13:34:08 +0200

sched: Remove noop in alloc_rt_sched_group()

The rq varible, though computed for each possible cpu, has nothing to
do in the function, so it can be removed.

This also eliminates a build warning.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/BANLkTin-FfQfqW5ym1iuEmrk8s777Y1LAg@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9cde2dd..f11a2a5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8226,7 +8226,6 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	struct rt_rq *rt_rq;
 	struct sched_rt_entity *rt_se;
-	struct rq *rq;
 	int i;
 
 	tg->rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
@@ -8240,8 +8239,6 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
 
 	for_each_possible_cpu(i) {
-		rq = cpu_rq(i);
-
 		rt_rq = kzalloc_node(sizeof(struct rt_rq),
 				     GFP_KERNEL, cpu_to_node(i));
 		if (!rt_rq)
