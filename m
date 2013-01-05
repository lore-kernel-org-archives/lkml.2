Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab3AERKR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:10:17 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:42747 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab3AERKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:10:09 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/6] rcutorture: don't compare ptr with 0
Date: Sat,  5 Jan 2013 09:09:37 -0800
Message-Id: <1357405778-13903-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1357405778-13903-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130105170920.GA13766@linux.vnet.ibm.com>
 <1357405778-13903-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-5406-0000-0000-000003E57EE5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 31dea01..0249800 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1749,7 +1749,7 @@ static int rcu_torture_barrier_init(void)
 	barrier_cbs_wq =
 		kzalloc(n_barrier_cbs * sizeof(barrier_cbs_wq[0]),
 			GFP_KERNEL);
-	if (barrier_cbs_tasks == NULL || barrier_cbs_wq == 0)
+	if (barrier_cbs_tasks == NULL || !barrier_cbs_wq)
 		return -ENOMEM;
 	for (i = 0; i < n_barrier_cbs; i++) {
 		init_waitqueue_head(&barrier_cbs_wq[i]);
-- 
1.7.8

