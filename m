Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab1BWBl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:41:26 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37419 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755803Ab1BWBjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:39:52 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 13/14] rcu: eliminate unused boosting statistics
Date: Tue, 22 Feb 2011 17:39:42 -0800
Message-Id: <1298425183-21265-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110223013917.GA20996@linux.vnet.ibm.com>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The n_rcu_torture_boost_allocerror and n_rcu_torture_boost_afferror
statistics are not actually incremented anymore, so eliminate them.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index c224da4..68f434f 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1067,7 +1067,7 @@ rcu_torture_printk(char *page)
 	cnt += sprintf(&page[cnt], "%s%s ", torture_type, TORTURE_FLAG);
 	cnt += sprintf(&page[cnt],
 		       "rtc: %p ver: %ld tfle: %d rta: %d rtaf: %d rtf: %d "
-		       "rtmbe: %d rtbke: %ld rtbre: %ld rtbae: %ld rtbafe: %ld "
+		       "rtmbe: %d rtbke: %ld rtbre: %ld "
 		       "rtbf: %ld rtb: %ld nt: %ld",
 		       rcu_torture_current,
 		       rcu_torture_current_version,
@@ -1078,8 +1078,6 @@ rcu_torture_printk(char *page)
 		       atomic_read(&n_rcu_torture_mberror),
 		       n_rcu_torture_boost_ktrerror,
 		       n_rcu_torture_boost_rterror,
-		       n_rcu_torture_boost_allocerror,
-		       n_rcu_torture_boost_afferror,
 		       n_rcu_torture_boost_failure,
 		       n_rcu_torture_boosts,
 		       n_rcu_torture_timers);
-- 
1.7.3.2

