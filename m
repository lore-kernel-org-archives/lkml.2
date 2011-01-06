Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab1AFXxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:53:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60083 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab1AFXxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:53:50 -0500
Date: Fri, 7 Jan 2011 00:53:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] scheduler changes for v2.6.38
Message-ID: <20110106235332.GA15940@elte.hu>
References: <20110106092833.GA16125@elte.hu>
 <AANLkTinotRxScOHEb0HgFgSpGPkq_6jKTv5CfvnQM=ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinotRxScOHEb0HgFgSpGPkq_6jKTv5CfvnQM=ee@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Ingo, can we please not do things like this:
> 
> > diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> > index 155a415..562c56e 100644
> > --- a/kernel/trace/trace_selftest.c
> > +++ b/kernel/trace/trace_selftest.c
> > @@ -558,7 +558,7 @@ trace_selftest_startup_nop(struct tracer *trace, struct trace_array *tr)
> >  static int trace_wakeup_test_thread(void *data)
> >  {
> >        /* Make this a RT thread, doesn't need to be too high */
> > -       struct sched_param param = { .sched_priority = 5 };
> > +       static struct sched_param param = { .sched_priority = 5 };
> >        struct completion *x = data;
> >
> >        sched_setscheduler(current, SCHED_FIFO, &param);
> > diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> > index 5b08215..c812c49 100644
> > --- a/kernel/watchdog.c
> > +++ b/kernel/watchdog.c
> > @@ -307,7 +307,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
> >  */
> >  static int watchdog(void *unused)
> >  {
> > -       struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
> > +       static struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
> >        struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
> >
> >        sched_setscheduler(current, SCHED_FIFO, &param);
> 
> It's just nasty and horrible.

Agreed, and i keep flaming people every time i notice it. Alas here i didnt notice 
it and it slipped through. Will fix it.

Thanks,

	Ingo
