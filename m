Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2AaCpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 21:45:04 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:54169 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab2AaCpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 21:45:02 -0500
Message-ID: <4F2754A0.9090306@ct.jp.nec.com>
Date: Tue, 31 Jan 2012 11:40:32 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: sched: fix compilation warning on !SMP
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

  CC      kernel/sched/fair.o
kernel/sched/fair.c:218:36: warning: 'max_load_balance_interval' defined but not used [-Wunused-variable]

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Vincent Guittot <vincent.guittot@linaro.org>
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
-- 
1.7.7.6

