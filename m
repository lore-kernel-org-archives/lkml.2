Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab2FOJvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 05:51:38 -0400
Received: from mx2.parallels.com ([64.131.90.16]:37151 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756267Ab2FOJvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 05:51:36 -0400
Message-ID: <4FDB050F.7040503@parallels.com>
Date: Fri, 15 Jun 2012 13:49:03 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <mingo@kernel.org>, <pjt@google.com>, <venki@google.com>, <efault@gmx.de>,
        <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/4] sched: Push put_prev_task() into pick_next_task()
References: <20120614132902.800827488@chello.nl> <20120614133212.690691207@chello.nl>
In-Reply-To: <20120614133212.690691207@chello.nl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 05:29 PM, Peter Zijlstra wrote:
> +static struct task_struct *
> +pick_next_task_rt(struct rq *rq, struct task_struct *prev)
>   {
> -	struct task_struct *p = _pick_next_task_rt(rq);
> +	struct task_struct *p;
> +	struct rt_rq *rt_rq =&rq->rt;
> +
> +	if (!rt_rq->rt_nr_running)
> +		return NULL;
> +
> +	if (rt_rq_throttled(rt_rq))
> +		return NULL;
> +
> +	if (prev)
> +		prev->sched_class->put_prev_task(rq, prev);
> +
it might be me, but this one sounds strange. If the responsibility of 
putting the task now lays with pic_next_task, you can't return NULL 
without doing this first.


