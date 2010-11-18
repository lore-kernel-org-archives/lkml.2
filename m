Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab0KROJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:09:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:41381 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758262Ab0KROJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:09:16 -0500
Date: Thu, 18 Nov 2010 14:08:40 GMT
From: tip-bot for Alex Shi <alex.shi@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, ncrao@google.com, efault@gmx.de,
        alex.shi@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ncrao@google.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        alex.shi@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1289928732.5169.211.camel@maggy.simson.net>
References: <1289928732.5169.211.camel@maggy.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix volanomark performance regression
Message-ID: <tip-b5482cfa1c95a188b3054fa33274806add91bbe5@git.kernel.org>
Git-Commit-ID: b5482cfa1c95a188b3054fa33274806add91bbe5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:08:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5482cfa1c95a188b3054fa33274806add91bbe5
Gitweb:     http://git.kernel.org/tip/b5482cfa1c95a188b3054fa33274806add91bbe5
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Tue, 16 Nov 2010 17:34:02 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:11:43 +0100

sched: Fix volanomark performance regression

Commit fab4762 triggers excessive idle balancing, causing a ~30% loss in
volanomark throughput. Remove idle balancing throttle reset.

Originally-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1289928732.5169.211.camel@maggy.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 52ab113..ba0556d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1758,10 +1758,6 @@ static void pull_task(struct rq *src_rq, struct task_struct *p,
 	set_task_cpu(p, this_cpu);
 	activate_task(this_rq, p, 0);
 	check_preempt_curr(this_rq, p, 0);
-
-	/* re-arm NEWIDLE balancing when moving tasks */
-	src_rq->avg_idle = this_rq->avg_idle = 2*sysctl_sched_migration_cost;
-	this_rq->idle_stamp = 0;
 }
 
 /*
