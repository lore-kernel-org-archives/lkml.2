Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0H0PXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:23:24 -0400
Received: from mail.openrapids.net ([64.15.138.104]:44489 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753469Ab0H0PXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:23:21 -0400
Date: Fri, 27 Aug 2010 11:23:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
Message-ID: <20100827152319.GC14926@Krystal>
References: <20100826180908.648103531@efficios.com> <1282849045.1975.1587.camel@laptop> <alpine.LFD.2.00.1008262306140.2768@localhost.localdomain> <alpine.LFD.2.00.1008270013390.2768@localhost.localdomain> <20100826230934.GA4194@Krystal> <20100826233651.GB28177@Krystal> <1282894718.1975.1654.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282894718.1975.1654.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:21:47 up 216 days, 17:58,  4 users,  load average: 0.00, 0.02,
	0.04
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2010-08-26 at 19:36 -0400, Mathieu Desnoyers wrote:
> > > The only thing we might have to be careful about is what happens if the timer
> > > re-fires before the thread completes its execution. We might want to let the
> > > signal handler detect these overruns somehow.
> > 
> > Hrm, thinking about it a little more, one of the "plus" sides of these
> > SIGEV_THREAD timers is that a single timer can fork threads that will run on
> > many cores on a multi-core system. If we go for preallocation of a single
> > thread, we lose that. Maybe we could think of a way to preallocate a thread pool
> > instead ? 
> 
> Why try and fix a broken thing, just let the app spawn threads and use
> SIGEV_THREAD_ID itself, it knows its requirements and can do what suits
> the situation best. No need to try and patch up braindead posix stuff.

As I dig through the code and learn more about the posix standard, my
understanding is that the _implementation_ is broken. The standard just leaves
enough rope for the implementation to either do the right thing or to hang
itself. Sadly glibc seems to have chosen the second option.

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
