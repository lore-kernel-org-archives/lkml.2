Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1K1VZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 16:25:05 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61433 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1K1VY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 16:24:57 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 2/4] rcu: Irq nesting is always 0 on rcu_enter_idle_common
Date: Mon, 28 Nov 2011 22:24:45 +0100
Message-Id: <1322515487-18690-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
References: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So pass 0 directly as a nesting value on the tracing calls.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index c2aaadf..b80cb41 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -350,11 +350,10 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
  */
 static void rcu_idle_enter_common(struct rcu_dynticks *rdtp)
 {
-	trace_rcu_dyntick("Start", rdtp->dynticks_nesting);
+	trace_rcu_dyntick("Start", 0);
 	if (!idle_cpu(smp_processor_id())) {
 		WARN_ON_ONCE(1);	/* must be idle task! */
-		trace_rcu_dyntick("Error on entry: not idle task",
-				   rdtp->dynticks_nesting);
+		trace_rcu_dyntick("Error on entry: not idle task", 0);
 		ftrace_dump(DUMP_ALL);
 	}
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
-- 
1.7.5.4

