Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab2A2Qfx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 11:35:53 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51132 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab2A2Qfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 11:35:52 -0500
Subject: [PATCH] sched: At sched_fork use __set_task_cpu().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: mingo@elte.hu, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 Jan 2012 22:34:37 +0600
Message-ID: <1327854877.8504.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 We don't use select_task_rq() from sched_fork() anymore and no chance of task gets migrated at
this point. Therefore, we can avoid task migration related checking/accounting, so use
__set_task_cpu() instead of set_task_cpu().

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index df00cb0..a38026e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1755,7 +1755,7 @@ void sched_fork(struct task_struct *p)
 	 * Silence PROVE_RCU.
 	 */
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
-	set_task_cpu(p, cpu);
+	__set_task_cpu(p, cpu);
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)


