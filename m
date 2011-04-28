Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab1D1JwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 05:52:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077Ab1D1JwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 05:52:10 -0400
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, avi@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org
Subject: [PATCH 1/2] rcu: export rcu_note_context_switch() function
Date: Thu, 28 Apr 2011 12:52:02 +0300
Message-Id: <1303984323-3203-2-git-send-email-gleb@redhat.com>
In-Reply-To: <1303984323-3203-1-git-send-email-gleb@redhat.com>
References: <1303984323-3203-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 include/linux/rcutiny.h |    6 +-----
 kernel/rcutiny.c        |    7 +++++++
 kernel/rcutree.c        |    1 +
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 30ebd7c..8e5f7cf 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -93,11 +93,7 @@ static inline int rcu_needs_cpu(int cpu)
 
 #endif /* #else #ifdef CONFIG_TINY_RCU */
 
-static inline void rcu_note_context_switch(int cpu)
-{
-	rcu_sched_qs(cpu);
-	rcu_preempt_note_context_switch();
-}
+extern void rcu_note_context_switch(int cpu);
 
 /*
  * Return the number of grace periods.
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 0c343b9..3d715a4 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -78,6 +78,13 @@ void rcu_exit_nohz(void)
 
 #endif /* #ifdef CONFIG_NO_HZ */
 
+void rcu_note_context_switch(int cpu)
+{
+	rcu_sched_qs(cpu);
+	rcu_preempt_note_context_switch();
+}
+EXPORT_SYMBOL_GPL(rcu_note_context_switch);
+
 /*
  * Helper function for rcu_qsctr_inc() and rcu_bh_qsctr_inc().
  * Also disable irqs to avoid confusion due to interrupt handlers
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index dd4aea8..0837d63 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -124,6 +124,7 @@ void rcu_note_context_switch(int cpu)
 	rcu_sched_qs(cpu);
 	rcu_preempt_note_context_switch(cpu);
 }
+EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
 #ifdef CONFIG_NO_HZ
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
-- 
1.7.2.3

