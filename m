Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965145Ab2J3RdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:33:11 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49739 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965135Ab2J3RdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:33:06 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/5] rcu: Fix precedence error in cpu_needs_another_gp()
Date: Tue, 30 Oct 2012 10:19:22 -0700
Message-Id: <1351617563-28506-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351617563-28506-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030171906.GA27431@linux.vnet.ibm.com>
 <1351617563-28506-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-7182-0000-0000-000002FDE707
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The fix introduced by a10d206e (rcu: Fix day-one dyntick-idle
stall-warning bug) has a C-language precedence error.  It turns out
that this error is harmless in that the same result is computed for all
inputs, but the code is nevertheless a potential source of confusion.
This commit therefore introduces parentheses in order to force the
execution of the code to reflect the intent.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f9c17c3..effd47a 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -313,7 +313,7 @@ static int
 cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	return *rdp->nxttail[RCU_DONE_TAIL +
-			     ACCESS_ONCE(rsp->completed) != rdp->completed] &&
+			     (ACCESS_ONCE(rsp->completed) != rdp->completed)] &&
 	       !rcu_gp_in_progress(rsp);
 }
 
-- 
1.7.8

