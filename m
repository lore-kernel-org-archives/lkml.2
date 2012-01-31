Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab2AaN2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:28:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55257 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab2AaN2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:28:39 -0500
Date: Tue, 31 Jan 2012 05:28:08 -0800
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Message-ID: <tip-ed387b781ea6e14b78f449aa2ee4f270b60b01ac@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, vincent.guittot@linaro.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        vincent.guittot@linaro.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4F2754A0.9090306@ct.jp.nec.com>
References: <4F2754A0.9090306@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Move SMP-only variable into the SMP section
Git-Commit-ID: ed387b781ea6e14b78f449aa2ee4f270b60b01ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 31 Jan 2012 05:28:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed387b781ea6e14b78f449aa2ee4f270b60b01ac
Gitweb:     http://git.kernel.org/tip/ed387b781ea6e14b78f449aa2ee4f270b60b01ac
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Tue, 31 Jan 2012 11:40:32 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 31 Jan 2012 13:40:59 +0100

sched: Move SMP-only variable into the SMP section

This also fixes the following compilation warning on !SMP:

  CC kernel/sched/fair.o
  kernel/sched/fair.c:218:36: warning: 'max_load_balance_interval' defined but not used [-Wunused-variable]

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4F2754A0.9090306@ct.jp.nec.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8e77a6b..4ab60a2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -215,8 +215,6 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 
 const struct sched_class fair_sched_class;
 
-static unsigned long __read_mostly max_load_balance_interval = HZ/10;
-
 /**************************************************************
  * CFS operations on generic schedulable entities:
  */
@@ -3086,6 +3084,8 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preemp
  * Fair scheduling class load-balancing methods:
  */
 
+static unsigned long __read_mostly max_load_balance_interval = HZ/10;
+
 /*
  * pull_task - move a task from a remote runqueue to the local runqueue.
  * Both runqueues must be locked.
