Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab2BATnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:43:12 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:40478 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab2BATnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:43:01 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 13/41] rcu: Make rcutorture flag online/offline failures
Date: Wed,  1 Feb 2012 11:41:31 -0800
Message-Id: <1328125319-5205-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-7282-0000-0000-0000061F24ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Make rcutorture check for CPU-hotplug failures and complain if there
were any.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 88f17b8..a94eaef 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1602,6 +1602,10 @@ rcu_torture_cleanup(void)
 		cur_ops->cleanup();
 	if (atomic_read(&n_rcu_torture_error))
 		rcu_torture_print_module_parms(cur_ops, "End of test: FAILURE");
+	else if (n_online_successes != n_online_attempts ||
+		 n_offline_successes != n_offline_attempts)
+		rcu_torture_print_module_parms(cur_ops,
+					       "End of test: RCU_HOTPLUG");
 	else
 		rcu_torture_print_module_parms(cur_ops, "End of test: SUCCESS");
 }
-- 
1.7.8

