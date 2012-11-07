Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab2KGH4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:56:52 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:38553 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2KGH4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:56:50 -0500
Message-ID: <509A1438.7020008@linux.vnet.ibm.com>
Date: Wed, 07 Nov 2012 15:56:40 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>,
        PDSW-power-team <pdsw-power-team@arm.com>
Subject: Re: [Query]: sched/fair: prio_changed_fair()
References: <CAKohpomr6wkNNi3tt=obzM=2atZfRLQ0V4XOzX__W1yB8UKgTg@mail.gmail.com>
In-Reply-To: <CAKohpomr6wkNNi3tt=obzM=2atZfRLQ0V4XOzX__W1yB8UKgTg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12110707-5816-0000-0000-000005429B05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 03:49 PM, Viresh Kumar wrote:
Hi, Viresh
> Hi Ingo/Peter,
> 
> I am trying to understand the complex scheduler code and just found
> something incorrect (maybe i am not reading it well):
> 
> File: kernel/sched/fair.c
> 
> static void
> prio_changed_fair(struct rq *rq, struct task_struct *p, int oldprio)
> {
> 	if (!p->se.on_rq)
> 		return;
> 
> 	/*
> 	 * Reschedule if we are currently running on this runqueue and
> 	 * our priority decreased, or if we are not currently running on
> 	 * this runqueue and our priority is higher than the current's
> 	 */
> 	if (rq->curr == p) {
> 		if (p->prio > oldprio)
> 			resched_task(rq->curr);
> 	} else
> 		check_preempt_curr(rq, p, 0);
> }
> 
> 
> Comment says that we must mark the task to be rescheduled, if we
> are currently running and our priority has decreased. But in code we
> are checking (p->prio > oldprio). i.e. reschedule if we were currently
> running and our priority increased.

It's the user nice value I suppose, so it should be reversed when we are
talking about weight.

Regards,
Michael Wang

> 
> Sorry if i am wrong :(
> 
> --
> viresh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

