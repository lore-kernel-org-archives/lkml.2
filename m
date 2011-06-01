Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab1FAOXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 10:23:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34602 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab1FAOW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 10:22:59 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=cWu3orRm09UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=P-zH6Fbi6VzdvBoGX5QA:9 a=Az-tnAt17RxsUB6xRE8A:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: remove resetting exec_start in
 put_prev_task_rt()
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTimqWD=q6YnSDi-v9y=LMWecgEzEWg@mail.gmail.com>
References: <BANLkTimqWD=q6YnSDi-v9y=LMWecgEzEWg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 01 Jun 2011 10:22:57 -0400
Message-ID: <1306938177.10135.20.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 22:03 +0800, Hillf Danton wrote:
> Resetting exec_start, after updated in update_curr_rt(), could open window for
> messing up the subsequent computations of delta_exec of the given task.

The domain scheduling was mostly done by Peter, but when you make a
change like this, you need to explain it better than this. I really have
no idea what you mean in this change log.

Please give an example of how this "open window" can mess up the
subsequent computations of delta_exec. That is, have write a theoretical
timeline of events that shows in detail how this can mess things up.

This makes understanding your changes much easier, otherwise you will
have to wait till we have the time to look and figure things out
ourselves. As we are currently working on other areas of the kernel so
you will have to wait much longer than if you showed us exactly what
happened.

Thanks!

-- Steve

> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>  kernel/sched_rt.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 88725c9..0f0cfce 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1166,7 +1166,6 @@ static struct task_struct
> *pick_next_task_rt(struct rq *rq)
>  static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
>  {
>  	update_curr_rt(rq);
> -	p->se.exec_start = 0;
> 
>  	/*
>  	 * The previous task needs to be made eligible for pushing


