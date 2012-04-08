Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab2DHLdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 07:33:20 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59079 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2DHLdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 07:33:07 -0400
MIME-Version: 1.0
Date: Sun, 8 Apr 2012 19:33:06 +0800
Message-ID: <CAJd=RBA0Qymw3dadvv5WntVNOr22rn7XPYe0SivY9F+SH1gofw@mail.gmail.com>
Subject: [PATCH] DLS: cleanup clearing overload
From: Hillf Danton <dhillf@gmail.com>
To: Dario Faggioli <raistlin@linux.it>, Juri Lelli <juri.lelli@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have to info puller that there is no more diet, even if CPU goes off.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched_dl.c	Sat Apr  7 15:00:28 2012
+++ b/kernel/sched_dl.c	Sun Apr  8 19:24:30 2012
@@ -83,9 +83,6 @@ static inline void dl_set_overload(struc

 static inline void dl_clear_overload(struct rq *rq)
 {
-	if (!rq->online)
-		return;
-
 	atomic_dec(&rq->rd->dlo_count);
 	cpumask_clear_cpu(rq->cpu, rq->rd->dlo_mask);
 }
--
