Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab1KSMuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 07:50:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56026 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1KSMuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 07:50:37 -0500
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 1/3] rcu-more-fallout.patch
Date: Sat, 19 Nov 2011 13:50:26 +0100
Message-Id: <1321707028-12487-2-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1321707028-12487-1-git-send-email-jkacur@redhat.com>
References: <1321707028-12487-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cherry-picked for v3.0-rt and fixed minor merge conflict
Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/rcutiny.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 7bbac7d..f1e4bee 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -271,6 +271,7 @@ void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 EXPORT_SYMBOL_GPL(call_rcu_sched);
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 /*
  * Post an RCU bottom-half callback to be invoked after any subsequent
  * quiescent state.
@@ -280,6 +281,7 @@ void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 	__call_rcu(head, func, &rcu_bh_ctrlblk);
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
+#endif
 
 void rcu_barrier_bh(void)
 {
-- 
1.7.2.3

