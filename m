Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab2KGHtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:49:03 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:35906 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2KGHtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:49:02 -0500
MIME-Version: 1.0
Date: Wed, 7 Nov 2012 13:19:01 +0530
Message-ID: <CAKohpomr6wkNNi3tt=obzM=2atZfRLQ0V4XOzX__W1yB8UKgTg@mail.gmail.com>
Subject: [Query]: sched/fair: prio_changed_fair()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>,
        PDSW-power-team <pdsw-power-team@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo/Peter,

I am trying to understand the complex scheduler code and just found
something incorrect (maybe i am not reading it well):

File: kernel/sched/fair.c

static void
prio_changed_fair(struct rq *rq, struct task_struct *p, int oldprio)
{
	if (!p->se.on_rq)
		return;

	/*
	 * Reschedule if we are currently running on this runqueue and
	 * our priority decreased, or if we are not currently running on
	 * this runqueue and our priority is higher than the current's
	 */
	if (rq->curr == p) {
		if (p->prio > oldprio)
			resched_task(rq->curr);
	} else
		check_preempt_curr(rq, p, 0);
}


Comment says that we must mark the task to be rescheduled, if we
are currently running and our priority has decreased. But in code we
are checking (p->prio > oldprio). i.e. reschedule if we were currently
running and our priority increased.

Sorry if i am wrong :(

--
viresh
