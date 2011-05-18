Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab1ERNYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 09:24:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44582 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116Ab1ERNYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 09:24:07 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=nZMiEFGSWTUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=udWBuIU7i9_Wxex5M7YA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: correct how RT task is picked
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <BANLkTikMdAG4HFmhiB9c3x97FH0N3PnpHA@mail.gmail.com>
References: <BANLkTikkeR_yf1HGhgq7WEO-kEvDGkV_tw@mail.gmail.com>
	 <BANLkTim4n-WA_6nJpg4Nd99yuc3f+VWkcw@mail.gmail.com>
	 <BANLkTikOecxhb8pZfAd19FLrPAPY4zacDQ@mail.gmail.com>
	 <20110512120606.GA3639@zhy> <20110518013842.GD23940@home.goodmis.org>
	 <BANLkTikOW9t6F8jvTJ0uPvyYDy+mpXh-DA@mail.gmail.com>
	 <BANLkTikMdAG4HFmhiB9c3x97FH0N3PnpHA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 18 May 2011 09:24:04 -0400
Message-ID: <1305725044.26849.11.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 21:19 +0800, Hillf Danton wrote:

> Hi all
> 
> The patch is prepared again, in which tests for both cpu and
> nr_cpus_allowed are dropped.
> 
> The reason to drop nr_cpus_allowed is to make sure that the
> returned value is correct for both case that cpu == rq->cpu and
> case that cpu != rq->cpu.

-ENOPARSE

Why would we pick a task that can't migrate?

-- Steve

> 
> thanks
> 
> Hillf
> ---
> 
> --- a/kernel/sched_rt.c	2011-04-27 11:48:50.000000000 +0800
> +++ b/kernel/sched_rt.c	2011-05-18 21:16:22.000000000 +0800
> @@ -1149,9 +1149,7 @@ static void deactivate_task(struct rq *r
> 
>  static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
>  {
> -	if (!task_running(rq, p) &&
> -	    (cpu < 0 || cpumask_test_cpu(cpu, &p->cpus_allowed)) &&
> -	    (p->rt.nr_cpus_allowed > 1))
> +	if (!task_running(rq, p) && cpumask_test_cpu(cpu, &p->cpus_allowed))
>  		return 1;
>  	return 0;
>  }


