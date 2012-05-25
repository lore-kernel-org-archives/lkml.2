Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab2EYGv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 02:51:27 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:51733 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2EYGvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 02:51:25 -0400
Message-ID: <4FBF2A1D.2090302@ct.jp.nec.com>
Date: Fri, 25 May 2012 15:43:41 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] sched/rt: Remove redundant check before push_rt_task()
References: <4FBF29B2.9030904@ct.jp.nec.com>
In-Reply-To: <4FBF29B2.9030904@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Currently rq->rt.overloaded is checked twice in switched_to_rt().
Remove the first one which out of push_rt_task().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/sched/rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index c5565c3..a601a70 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1907,7 +1907,7 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
 	 */
 	if (p->on_rq && rq->curr != p) {
 #ifdef CONFIG_SMP
-		if (rq->rt.overloaded && push_rt_task(rq) &&
+		if (push_rt_task(rq) &&
 		    /* Don't resched if we changed runqueues */
 		    rq != task_rq(p))
 			check_resched = 0;
-- 
1.7.7.6

