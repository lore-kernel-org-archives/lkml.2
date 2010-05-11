Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab0EKXdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 19:33:23 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58619 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab0EKXdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 19:33:11 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH RFC tip/core/rcu 04/11] powerpc: remove all rcu head initializations
Date: Tue, 11 May 2010 16:32:59 -0700
Message-Id: <1273620786-20392-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100511233241.GA20250@linux.vnet.ibm.com>
References: <20100511233241.GA20250@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all rcu head inits. We don't care about the RCU head state before passing
it to call_rcu() anyway. Only leave the "on_stack" variants so debugobjects can
keep track of objects on stack.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/powerpc/mm/pgtable.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
index ebc2f38..2c7e801 100644
--- a/arch/powerpc/mm/pgtable.c
+++ b/arch/powerpc/mm/pgtable.c
@@ -92,7 +92,6 @@ static void pte_free_rcu_callback(struct rcu_head *head)
 
 static void pte_free_submit(struct pte_freelist_batch *batch)
 {
-	INIT_RCU_HEAD(&batch->rcu);
 	call_rcu(&batch->rcu, pte_free_rcu_callback);
 }
 
-- 
1.7.0.6

