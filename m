Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897Ab0GQLMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 07:12:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:41410 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679Ab0GQLMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 07:12:22 -0400
Date: Sat, 17 Jul 2010 11:12:01 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1278626014.2834.74.camel@sbs-t61.sc.intel.com>
References: <1278626014.2834.74.camel@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Update rq->clock for nohz balanced cpus
Message-ID: <tip-5343bdb8fd076f16edc9d113a9e35e2a1d1f4966@git.kernel.org>
Git-Commit-ID: 5343bdb8fd076f16edc9d113a9e35e2a1d1f4966
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 17 Jul 2010 11:12:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5343bdb8fd076f16edc9d113a9e35e2a1d1f4966
Gitweb:     http://git.kernel.org/tip/5343bdb8fd076f16edc9d113a9e35e2a1d1f4966
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 9 Jul 2010 15:19:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 17 Jul 2010 12:02:08 +0200

sched: Update rq->clock for nohz balanced cpus

Suresh spotted that we don't update the rq->clock in the nohz
load-balancer path.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1278626014.2834.74.camel@sbs-t61.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index b4da534..e44a591 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3596,6 +3596,7 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 		}
 
 		raw_spin_lock_irq(&this_rq->lock);
+		update_rq_clock(this_rq);
 		update_cpu_load(this_rq);
 		raw_spin_unlock_irq(&this_rq->lock);
 
