Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab1EXLxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 07:53:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48852 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753831Ab1EXLxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 07:53:38 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Itd0ZH6FIRS/D8CQqdo+wFskHvaKNRPff7BY7sG
	3CeM661PvnMHoR
Subject: Re: [PATCH] sched: remove noop in next_prio()
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <BANLkTikhvhptDG-eRZ9uD5wSm3RxTn1RFw@mail.gmail.com>
References: <BANLkTimxmWiof9s5AvS3v_0X+sMiE=0x5g@mail.gmail.com>
	 <BANLkTikhvhptDG-eRZ9uD5wSm3RxTn1RFw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 13:53:34 +0200
Message-ID: <1306238014.16375.0.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 16:17 +0800, Yong Zhang wrote:
> On Sat, May 21, 2011 at 10:19 PM, Hillf Danton <dhillf@gmail.com> wrote:
> > When computing the next priority for a given run-queue, the check for
> > RT priority of the task determined by the pick_next_highest_task_rt()
> > function could be removed, since only RT task is returned by the
> > function.
> >
> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> 
> Yup, it's true.

(could whack the else while there)

> Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
> 
> > ---
> >
> > --- a/kernel/sched_rt.c 2011-04-27 11:48:50.000000000 +0800
> > +++ b/kernel/sched_rt.c 2011-05-21 22:10:34.000000000 +0800
> > @@ -670,7 +670,7 @@ static inline int next_prio(struct rq *r
> >  {
> >        struct task_struct *next = pick_next_highest_task_rt(rq, rq->cpu);
> >
> > -       if (next && rt_prio(next->prio))
> > +       if (next)
> >                return next->prio;
> >        else
> >                return MAX_RT_PRIO;
> >
> 
> 
> 


