Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab1FPQ53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:57:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48794 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525Ab1FPQ50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:57:26 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=LNPuZ-ntsc0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ErseyReNmn3HWoBTfBUA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: find all lowest run-queues for RT task
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1308243122.9218.143.camel@gandalf.stny.rr.com>
References: <BANLkTikNYY3zKM+VUF3AbTTD0idZnt3w=Q@mail.gmail.com>
	 <1308243122.9218.143.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 16 Jun 2011 12:57:25 -0400
Message-ID: <1308243445.9218.145.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 12:52 -0400, Steven Rostedt wrote:

> > diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
> > index 2722dc1..d4c0b46 100644
> > --- a/kernel/sched_cpupri.c
> > +++ b/kernel/sched_cpupri.c
> > @@ -181,8 +181,10 @@ int cpupri_init(struct cpupri *cp)
> >  			goto cleanup;
> >  	}
> > 
> > -	for_each_possible_cpu(i)
> > +	for_each_possible_cpu(i) {
> >  		cp->cpu_to_pri[i] = CPUPRI_INVALID;
> > +		cpupri_set(cp, i, MAX_RT_PRIO);
> > +	}
> 
> This is OK, and I may add it. It's just an initialization, and because
> things like the migration thread run on all CPUs, the first time an RT
> task is run on a CPU and dequeued, it will have the cpupri_set() to
> MX_RT_PRIO anyway. But for clean up sake, it may be good to initialize
> it to a valid mask and not be ZERO.
> 

I take it back, this isn't needed either, as the cpupri_set() is
initialized when the rq comes on line.

-- Steve


