Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab2FKMuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 08:50:14 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40247 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab2FKMuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 08:50:12 -0400
MIME-Version: 1.0
Date: Mon, 11 Jun 2012 20:50:11 +0800
Message-ID: <CAJd=RBDfZ4=dLjNV8E0TNk3V=qFfrrFVevP5dBfigaW8GaW5ww@mail.gmail.com>
Subject: [patch] BFS 421: revert handle CPU_ONLINE
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No reason to change whatever in the __init region, or I have to handle
why the newly built kernel hangs as early as she could.


--- a/kernel/sched/bfs.c	Fri Jun  8 21:34:34 2012
+++ b/kernel/sched/bfs.c	Mon Jun 11 20:07:46 2012
@@ -5349,7 +5349,7 @@ migration_call(struct notifier_block *nf
 		/* Update our root-domain */
 		grq_lock_irqsave(&flags);
 		if (rq->rd) {
-			BUG_ON(cpumask_test_cpu(cpu, rq->rd->span));
+			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));

 			set_rq_online(rq);
 		}
--
