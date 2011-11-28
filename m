Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab1K1Xep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:34:45 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37020 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374Ab1K1Xd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:33:59 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 11/13] rcu: Identify dyntick-idle CPUs on first force_quiescent_state() pass
Date: Mon, 28 Nov 2011 15:33:03 -0800
Message-Id: <1322523185-456-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111128233212.GA32279@linux.vnet.ibm.com>
References: <20111128233212.GA32279@linux.vnet.ibm.com>
x-cbid: 11112823-8974-0000-0000-000003806470
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Fixes and workarounds for a number of issues (for example, that in
df4012edc) make it safe to once again detect dyntick-idle CPUs on the
first pass of force_quiescent_state(), so this commit makes that change.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index aab9ed5..69bb372 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -607,7 +607,7 @@ int rcu_is_cpu_rrupt_from_idle(void)
 static int dyntick_save_progress_counter(struct rcu_data *rdp)
 {
 	rdp->dynticks_snap = atomic_add_return(0, &rdp->dynticks->dynticks);
-	return 0;
+	return (rdp->dynticks_snap & 0x1) == 0;
 }
 
 /*
-- 
1.7.3.2

