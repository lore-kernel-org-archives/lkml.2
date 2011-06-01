Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1FAODv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 10:03:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63691 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab1FAODs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 10:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Cm5jikzyRGYDpxEncVHs13JoSZJqmaSMFjbS2HeqbAaDM9MYXBzaaj30SjlUZEAOBm
         9m96f8s+gX8KXGDUEAxa73wMcBBmkEvE0UHB58Lk1MBhUUB5i6CMpAKOhL92UctoS59w
         p1MT72HeWRIVJsD5nj1j226wvKCV9mbPdCsuA=
MIME-Version: 1.0
Date: Wed, 1 Jun 2011 22:03:47 +0800
Message-ID: <BANLkTimqWD=q6YnSDi-v9y=LMWecgEzEWg@mail.gmail.com>
Subject: [PATCH] sched: remove resetting exec_start in put_prev_task_rt()
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resetting exec_start, after updated in update_curr_rt(), could open window for
messing up the subsequent computations of delta_exec of the given task.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 kernel/sched_rt.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 88725c9..0f0cfce 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1166,7 +1166,6 @@ static struct task_struct
*pick_next_task_rt(struct rq *rq)
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 {
 	update_curr_rt(rq);
-	p->se.exec_start = 0;

 	/*
 	 * The previous task needs to be made eligible for pushing
