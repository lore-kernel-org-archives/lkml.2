Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab2LXCOx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 21:14:53 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:42070 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab2LXCOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 21:14:46 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 07/29] kernel/: rename random32() to prandom_u32()
Date: Mon, 24 Dec 2012 11:13:54 +0900
Message-Id: <1356315256-6572-8-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356315256-6572-1-git-send-email-akinobu.mita@gmail.com>
References: <1356315256-6572-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 kernel/rcutree.c      | 2 +-
 kernel/test_kprobes.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e441b77..5b88db8 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1206,7 +1206,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock_irq(&rnp->lock);
 #ifdef CONFIG_PROVE_RCU_DELAY
-		if ((random32() % (rcu_num_nodes * 8)) == 0)
+		if ((prandom_u32() % (rcu_num_nodes * 8)) == 0)
 			schedule_timeout_uninterruptible(2);
 #endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
 		cond_resched();
diff --git a/kernel/test_kprobes.c b/kernel/test_kprobes.c
index f8b11a2..12d6ebb 100644
--- a/kernel/test_kprobes.c
+++ b/kernel/test_kprobes.c
@@ -365,7 +365,7 @@ int init_test_probes(void)
 	target2 = kprobe_target2;
 
 	do {
-		rand1 = random32();
+		rand1 = prandom_u32();
 	} while (rand1 <= div_factor);
 
 	printk(KERN_INFO "Kprobe smoke test started\n");
-- 
1.7.11.7

