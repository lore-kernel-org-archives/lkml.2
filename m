Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2CMEqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:46:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35160 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab2CMEqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:46:14 -0400
Date: Mon, 12 Mar 2012 21:45:55 -0700
From: tip-bot for Diwakar Tundlam <dtundlam@nvidia.com>
Message-ID: <tip-554cecaf733623b327eef9652b65965eb1081b81@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, dtundlam@nvidia.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dtundlam@nvidia.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE4665237994F30EF@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE4665237994F30EF@HQMAIL04.nvidia.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/nohz: Correctly initialize 'next_balance'
  in 'nohz' idle balancer
Git-Commit-ID: 554cecaf733623b327eef9652b65965eb1081b81
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 12 Mar 2012 21:46:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  554cecaf733623b327eef9652b65965eb1081b81
Gitweb:     http://git.kernel.org/tip/554cecaf733623b327eef9652b65965eb1081b81
Author:     Diwakar Tundlam <dtundlam@nvidia.com>
AuthorDate: Wed, 7 Mar 2012 14:44:26 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Mar 2012 20:43:16 +0100

sched/nohz: Correctly initialize 'next_balance' in 'nohz' idle balancer

The 'next_balance' field of 'nohz' idle balancer must be initialized
to jiffies. Since jiffies is initialized to negative 300 seconds the
'nohz' idle balancer does not run for the first 300s (5mins) after
bootup. If no new processes are spawed or no idle cycles happen, the
load on the cpus will remain unbalanced for that duration.

Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1DD7BFEDD3147247B1355BEFEFE4665237994F30EF@HQMAIL04.nvidia.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index def17aa..11f3979 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5571,6 +5571,7 @@ __init void init_sched_fair_class(void)
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
 
 #ifdef CONFIG_NO_HZ
+	nohz.next_balance = jiffies;
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
 	cpu_notifier(sched_ilb_notifier, 0);
 #endif
