Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0H0PV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:21:28 -0400
Received: from mail.openrapids.net ([64.15.138.104]:44263 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753469Ab0H0PV0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:21:26 -0400
Date: Fri, 27 Aug 2010 11:21:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
Message-ID: <20100827152125.GB14926@Krystal>
References: <20100826180908.648103531@efficios.com> <1282849045.1975.1587.camel@laptop> <alpine.LFD.2.00.1008262306140.2768@localhost.localdomain> <alpine.LFD.2.00.1008270013390.2768@localhost.localdomain> <20100826230934.GA4194@Krystal> <1282894655.1975.1650.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1282894655.1975.1650.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:19:20 up 216 days, 17:56,  5 users,  load average: 0.05, 0.05,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2010-08-26 at 19:09 -0400, Mathieu Desnoyers wrote:
> > > WTF can't the damned delivery thread not be created when timer_create
> > > is called and the signal be delivered to that very thread directly via
> > > SIGEV_THREAD_ID ?
> > 
> > Yeah, that sounds exactly like what I proposed about an hour ago on IRC ;) I'm
> > pretty sure that would work.
> > 
> > The only thing we might have to be careful about is what happens if the timer
> > re-fires before the thread completes its execution. We might want to let the
> > signal handler detect these overruns somehow.
> 
> Simply don't use SIGEV_THREAD and spawn you own thread and use
> SIGEV_THREAD_ID yourself, the programmer knows the semantics and knows
> if he cares about overlapping timers etc.

>From man timer_create:

       SIGEV_THREAD
              Upon  timer  expiration,  invoke  sigev_notify_function as if it
              were the start function of a new thread.  (Among the implementa‐
              tion  possibilities  here are that each timer notification could
              result in the creation of a new thread, or that a single  thread
              is  created  to  receive  all  notifications.)   The function is
              invoked   with   sigev_value   as   its   sole   argument.    If
              sigev_notify_attributes  is  not  NULL,  it  should  point  to a
              pthread_attr_t structure that defines  attributes  for  the  new
              thread (see pthread_attr_init(3).

So basically, it's the glibc implementation that is broken, not the standard.

The programmer should expect that thread execution can overlap though.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
