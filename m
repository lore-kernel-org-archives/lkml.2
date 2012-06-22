Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab2FVP0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:26:08 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53329 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933132Ab2FVP0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:26:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/22] rcu: Remove needless initialization
Date: Fri, 22 Jun 2012 08:17:09 -0700
Message-Id: <1340378241-6458-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622151655.GA6249@linux.vnet.ibm.com>
 <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-1780-0000-0000-000006B6BBA0
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000282; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000003; SDB=6.00150292; UDB=6.00034140; UTC=2012-06-22
 15:25:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

For global variables, C defaults all fields to zero.  The initialization
of the rcu_state structure's ->n_force_qs and ->n_force_qs_ngp fields
is therefore redundant, so this commit removes these initializations.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ac6e0c2..7622073 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -73,8 +73,6 @@ static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
 	.orphan_donetail = &sname##_state.orphan_donelist, \
 	.barrier_mutex = __MUTEX_INITIALIZER(sname##_state.barrier_mutex), \
 	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&sname##_state.fqslock), \
-	.n_force_qs = 0, \
-	.n_force_qs_ngp = 0, \
 	.name = #sname, \
 }
 
-- 
1.7.8

