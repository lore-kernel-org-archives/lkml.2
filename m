Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab1JLVf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 17:35:59 -0400
Received: from peace.netnation.com ([204.174.223.2]:46503 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab1JLVf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 17:35:58 -0400
Date: Wed, 12 Oct 2011 14:35:55 -0700
From: Simon Kirby <sim@hostway.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111012213555.GC24461@hostway.ca>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com> <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca> <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca> <1318060551.8395.0.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318060551.8395.0.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 08, 2011 at 09:55:51AM +0200, Peter Zijlstra wrote:

> On Fri, 2011-10-07 at 17:50 -0700, Simon Kirby wrote:
> > On Fri, Oct 07, 2011 at 08:01:55PM +0200, Peter Zijlstra wrote:
> > 
> > > @@ -2571,6 +2573,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
> > >  static inline void thread_group_cputime_init(struct signal_struct *sig)
> > >  {
> > >       raw_spin_lock_init(&sig->cputimer.lock);
> > > +     raw_spin_lock_init(&sig->cputimer.runtime_lock);
> > 
> > My 3.1-rc9 tree has just spin_lock_init() here, not raw_*.
> > 
> > Which tree is your patch against? -next or something?
> 
> or something yeah.. tip/master I think.
> 
> > It applies with some cooking like this, but will it be right?
> > 
> > > sed s/raw_// ../sched-patch-noraw.diff | patch -p1 --dry
> > patching file include/linux/sched.h
> > Hunk #1 succeeded at 503 (offset -1 lines).
> > Hunk #2 succeeded at 512 (offset -1 lines).
> > Hunk #3 succeeded at 2568 (offset -5 lines).
> > patching file kernel/posix-cpu-timers.c
> > patching file kernel/sched_stats.h 
> 
> yes that would be fine.

This patch (s/raw_//) has been stable on 5 boxes for a day. I'll push to
another 15 shortly and confirm tomorrow. Meanwhile, we had another ~4
boxes lock up on 3.1-rc9 _with_ d670ec13 reverted (all CPUs spinning),
but there weren't enough serial cables to log all of them and we haven't
been lucky enough to capture anything other than what fits on 80x25.
I'm hoping it's just the same bug you've already fixed. Strangely, boxes
on -rc6 and -rc7 haven't hit it, but those are across clusters with
different workloads.

Thanks!

Simon-
