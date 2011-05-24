Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab1EXN1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:27:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54052 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab1EXN1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:27:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=lY3lo5bHyD5a1YaeDMulYKSI8QHugJwwijKtWY9oeeeMepRtJ0SOJxfbmeFS7eRXx0
         w1eGkTL6SupHXZmLEV1MxYyGNEhqmKBVK3PLXNasP3wihcDwVIZZg3eS+Vq5jlj2uKwL
         dQ0Q9b7qEeRcgixhvdsBPmCmPHF2tmvt1xt/Q=
MIME-Version: 1.0
Date: Tue, 24 May 2011 21:27:10 +0800
Message-ID: <BANLkTin4OiDiPO3znMvKTVZcYukHReydMQ@mail.gmail.com>
Subject: [PATCH] sched: fix need_resched() when checking peempt
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When checking if current task could be preempted by a newly woken task,
further check could be bypassed if the current thread is different from
the current task of run-queue, and it is corrected accordingly.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- tip-git/kernel/sched_rt.c	Sun May 22 20:12:01 2011
+++ sched_rt.c	Tue May 24 20:31:27 2011
@@ -1074,7 +1074,7 @@ static void check_preempt_curr_rt(struct
 	 * to move current somewhere else, making room for our non-migratable
 	 * task.
 	 */
-	if (p->prio == rq->curr->prio && !need_resched())
+	if (p->prio == rq->curr->prio && !test_tsk_need_resched(rq->curr))
 		check_preempt_equal_prio(rq, p);
 #endif
 }
