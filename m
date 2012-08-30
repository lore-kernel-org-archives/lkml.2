Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab2H3STh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:19:37 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38852 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab2H3STa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:19:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 14/23] rcu: Remove now-unused rcu_state fields
Date: Thu, 30 Aug 2012 11:18:29 -0700
Message-Id: <1346350718-30937-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083018-2398-0000-0000-000009EA0076
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000293; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00169857; UDB=6.00038507; UTC=2012-08-30
 18:19:24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Moving the RCU grace-period processing to a kthread and adjusting the
tracing resulted in two of the rcu_state structure's fields being unused.
This commit therefore removes them.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 2d4cc18..8f0293c 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -378,13 +378,6 @@ struct rcu_state {
 
 	u8	fqs_state ____cacheline_internodealigned_in_smp;
 						/* Force QS state. */
-	u8	fqs_active;			/* force_quiescent_state() */
-						/*  is running. */
-	u8	fqs_need_gp;			/* A CPU was prevented from */
-						/*  starting a new grace */
-						/*  period because */
-						/*  force_quiescent_state() */
-						/*  was running. */
 	u8	boost;				/* Subject to priority boost. */
 	unsigned long gpnum;			/* Current gp number. */
 	unsigned long completed;		/* # of last completed gp. */
-- 
1.7.8

