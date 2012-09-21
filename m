Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab2IUNmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:42:31 -0400
Received: from forward3.mail.yandex.net ([77.88.46.8]:37832 "EHLO
	forward3.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab2IUNma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:42:30 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Sep 2012 09:42:30 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH]sched/rt.c: leaf_rt_rq_list contains empty queues. Fix it
MIME-Version: 1.0
Message-Id: <668281348234555@web30d.yandex.ru>
Date: Fri, 21 Sep 2012 17:35:55 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function __enqueue_rt_entity() adds an empty queue to leaf_rt_rq_list.

So, pick_next_highest_task_rt() picks empty queues. Fix it.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
---
 kernel/sched/rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 944cb68..b07edb9 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1103,7 +1103,7 @@ static void __enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head)
 	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
 		return;
 
-	if (!rt_rq->rt_nr_running)
+	if (rt_rq->rt_nr_running)
 		list_add_leaf_rt_rq(rt_rq);
 
 	if (head)
