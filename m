Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934626Ab1FWXN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:13:58 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45549 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934569Ab1FWXMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:12:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=badqE1BtyvnlHZ5PmV1ZiewkNG0fX0kAs0n8VhjaSUm684Sjuhcb644bjOLz3JavB1
         cY3cSP9qooAQJo9I5LRH8+X9o2vXi4EM3g2PKLzzb10ATv6Ep3fuP3zhhO4Sg+KYoryf
         Ktqm22nFMa/zCXbNoaGVOLkwHSwPfo13H0IlE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/3] rcu: Inform the user about dynticks idle mode on PROVE_RCU warning
Date: Fri, 24 Jun 2011 01:12:39 +0200
Message-Id: <1308870760-14153-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308870760-14153-1-git-send-email-fweisbec@gmail.com>
References: <1308870760-14153-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inform the user if we are in extended quiescent state when
an illegal use of rcu is detected.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/lockdep.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index df2ad37..e77de90 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -4008,6 +4008,10 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 	printk("%s:%d %s!\n", file, line, s);
 	printk("\nother info that might help us debug this:\n\n");
 	printk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
+
+	if (rcu_check_extended_qs())
+		printk("rcu is in extended quiescent state!\n");
+
 	lockdep_print_held_locks(curr);
 	printk("\nstack backtrace:\n");
 	dump_stack();
-- 
1.7.5.4

