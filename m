Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab1FJO6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 10:58:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50718 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab1FJO6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 10:58:39 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=cWu3orRm09UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=IZyfPognZdWxBsoFQYoA:9 a=-6VMX1tvV1O9qpDBKmMA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: remove resetting exec_start in
 put_prev_task_rt()
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTing2boYvDQqcxaqveYhbG2H1Zyvrw@mail.gmail.com>
References: <BANLkTimqWD=q6YnSDi-v9y=LMWecgEzEWg@mail.gmail.com>
	 <BANLkTikoO5F5H4sEUoDPKX3qiahuehp=Mg@mail.gmail.com>
	 <1307622863.9218.40.camel@gandalf.stny.rr.com>
	 <BANLkTing2boYvDQqcxaqveYhbG2H1Zyvrw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 10 Jun 2011 10:58:37 -0400
Message-ID: <1307717917.9218.45.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 22:48 +0800, Hillf Danton wrote:
> On Thu, Jun 9, 2011 at 8:34 PM, Steven Rostedt <rostedt@goodmis.org> wrote:

> Resetting exec_start to zero has no negative functionality in RT scheduling,
> as shown by Yong.
> 
> After put_prev_task() is called in schedule(),
> 
> 	put_prev_task(rq, prev);
> 	next = pick_next_task(rq);
> 	clear_tsk_need_resched(prev);
> 
> next is picked. Lets assume that next is not prev, and prev is still on RQ,
> then prev's sched_class is changed to CFS while it is waiting on RQ.
> After sched_class switch, prev is under CFS charge, and the exec_start field
> could be taken into other games.
> 
> In task_hot(), called when migrating task, zeroed exec_start is trapped as
> the following.
> 

How could any of that happen? This is all done under the rq->lock.
prev's sched class can not change at this time. Everything you stated is
protected by the rq->lock. I don't see any race conditions here.

-- Steve


