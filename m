Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab1G1VOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 17:14:47 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14022 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab1G1VOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 17:14:44 -0400
Date: Thu, 28 Jul 2011 23:14:43 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] sched: take rt_rq->rt_runtime_lock around
 rt_rq->rt_runtime modification
In-Reply-To: <1311887581.2617.374.camel@laptop>
Message-ID: <alpine.LNX.2.00.1107282313320.20477@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107282211370.20477@swampdragon.chaosbits.net> <1311887581.2617.374.camel@laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jul 2011, Peter Zijlstra wrote:

> On Thu, 2011-07-28 at 22:13 +0200, Jesper Juhl wrote:
> > Everywhere (that I could find) where we modify rt_rq->rt_runtime we hold 
> > rt_rq->rt_runtime_lock except in alloc_rt_sched_group(). Shouldn't we do 
> > so - as per this patch. ???
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  kernel/sched.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index ccacdbd..d5a3737 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -8488,7 +8488,9 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
> >  			goto err_free_rq;
> >  
> >  		init_rt_rq(rt_rq, cpu_rq(i));
> > +		raw_spin_lock(&rt_rq->rt_runtime_lock);
> >  		rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
> > +		raw_spin_unlock(&rt_rq->rt_runtime_lock);
> >  		init_tg_rt_entry(tg, rt_rq, rt_se, i, parent->rt_se[i]);
> 
> This is init code, the rt_rq is fresh and isn't exposed yet. There isn't
> any concurrency.
> 

I was actually wondering if that was the case, but wasn't sure, so I 
thought - better safe than sorry and ask :-)

Thank you for the feedback.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

