Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab2FOS60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:58:26 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59209 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab2FOS6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:58:23 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/6] rcu: Rationalize ordering of torture_ops list
Date: Fri, 15 Jun 2012 11:57:50 -0700
Message-Id: <1339786674-25265-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615185725.GA25163@linux.vnet.ibm.com>
 <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061518-7282-0000-0000-000009F316AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Move the raw SRCU interfaces out of the middle of the normal SRCU
interfaces.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index e66b34a..9850479 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1908,8 +1908,8 @@ rcu_torture_init(void)
 	static struct rcu_torture_ops *torture_ops[] =
 		{ &rcu_ops, &rcu_sync_ops, &rcu_expedited_ops,
 		  &rcu_bh_ops, &rcu_bh_sync_ops, &rcu_bh_expedited_ops,
-		  &srcu_ops, &srcu_sync_ops, &srcu_raw_ops,
-		  &srcu_raw_sync_ops, &srcu_expedited_ops,
+		  &srcu_ops, &srcu_sync_ops, &srcu_expedited_ops,
+		  &srcu_raw_ops, &srcu_raw_sync_ops,
 		  &sched_ops, &sched_sync_ops, &sched_expedited_ops, };
 
 	mutex_lock(&fullstop_mutex);
-- 
1.7.8

