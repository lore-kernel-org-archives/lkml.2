Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab1JHH4U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 03:56:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55587 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1JHH4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 03:56:11 -0400
Subject: Re: Linux 3.1-rc9
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Simon Kirby <sim@hostway.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 08 Oct 2011 09:55:51 +0200
In-Reply-To: <20111008005035.GC22843@hostway.ca>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
	 <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca>
	 <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318060551.8395.0.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 17:50 -0700, Simon Kirby wrote:
> On Fri, Oct 07, 2011 at 08:01:55PM +0200, Peter Zijlstra wrote:
> 
> > @@ -2571,6 +2573,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
> >  static inline void thread_group_cputime_init(struct signal_struct *sig)
> >  {
> >       raw_spin_lock_init(&sig->cputimer.lock);
> > +     raw_spin_lock_init(&sig->cputimer.runtime_lock);
> 
> My 3.1-rc9 tree has just spin_lock_init() here, not raw_*.
> 
> Which tree is your patch against? -next or something?

or something yeah.. tip/master I think.

> It applies with some cooking like this, but will it be right?
> 
> > sed s/raw_// ../sched-patch-noraw.diff | patch -p1 --dry
> patching file include/linux/sched.h
> Hunk #1 succeeded at 503 (offset -1 lines).
> Hunk #2 succeeded at 512 (offset -1 lines).
> Hunk #3 succeeded at 2568 (offset -5 lines).
> patching file kernel/posix-cpu-timers.c
> patching file kernel/sched_stats.h 

yes that would be fine.
