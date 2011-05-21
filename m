Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab1EUOTG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 10:19:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64003 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1EUOTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 10:19:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=O16KIQyoSAGvynV462Pg6NbMGAZmlrVXSM93xsM3tCSPJZLzzo4Hra7xdkpw+RXGs2
         iNQjJkCedYXNw16ieAIrH+9i3wS5FDoxJgvz69V54zEJ8Cz+fRJmGrW84jWIt1BBOC80
         ZrkKY7BhK1pRnWiE+BWuv+7XYZykPhpEK+v/g=
MIME-Version: 1.0
Date: Sat, 21 May 2011 22:19:02 +0800
Message-ID: <BANLkTimxmWiof9s5AvS3v_0X+sMiE=0x5g@mail.gmail.com>
Subject: [PATCH] sched: remove noop in next_prio()
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When computing the next priority for a given run-queue, the check for
RT priority of the task determined by the pick_next_highest_task_rt()
function could be removed, since only RT task is returned by the
function.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched_rt.c	2011-04-27 11:48:50.000000000 +0800
+++ b/kernel/sched_rt.c	2011-05-21 22:10:34.000000000 +0800
@@ -670,7 +670,7 @@ static inline int next_prio(struct rq *r
 {
 	struct task_struct *next = pick_next_highest_task_rt(rq, rq->cpu);

-	if (next && rt_prio(next->prio))
+	if (next)
 		return next->prio;
 	else
 		return MAX_RT_PRIO;
