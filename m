Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab2EYNjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:39:51 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57827 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab2EYNjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:39:49 -0400
MIME-Version: 1.0
Date: Fri, 25 May 2012 21:39:49 +0800
Message-ID: <CAJd=RBDt019ynGPgxSEZhk3vw=-JkqQdkfR+uyA3J4=5Kdybdg@mail.gmail.com>
Subject: [patch] BFS 420: fix handling CPU_ONLINE
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check of the given CPU belonging to root domain is inverse when handling
CPU_ONLINE, so correct it.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Fri May 25 20:03:48 2012
@@ -5422,7 +5422,7 @@ migration_call(struct notifier_block *nf
 		/* Update our root-domain */
 		grq_lock_irqsave(&flags);
 		if (rq->rd) {
-			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
+			BUG_ON(cpumask_test_cpu(cpu, rq->rd->span));

 			set_rq_online(rq);
 		}
--
