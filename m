Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab0HaPCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:02:31 -0400
Received: from mail.openrapids.net ([64.15.138.104]:55940 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932345Ab0HaPCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:02:30 -0400
Date: Tue, 31 Aug 2010 11:02:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
Message-ID: <20100831150228.GA3694@Krystal>
References: <alpine.LFD.2.00.1008270013390.2768@localhost.localdomain> <20100826230934.GA4194@Krystal> <1282894655.1975.1650.camel@laptop> <20100827152125.GB14926@Krystal> <1282923686.1975.2780.camel@laptop> <20100827160946.GG14926@Krystal> <1282930072.1975.2962.camel@laptop> <20100827183240.GC22679@Krystal> <1282936994.1975.3119.camel@laptop> <20100827195751.GA1030@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100827195751.GA1030@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:52:36 up 220 days, 17:29,  4 users,  load average: 0.00, 0.03,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Fri, 2010-08-27 at 14:32 -0400, Mathieu Desnoyers wrote:
> > > 
> > > These are problems you get only when you allow spawning any number of threads.
> > > If, instead, you create a thread pool at timer creation, then you can allow
> > > concurrency without problems with spawner context and error proparation.
> > 
> > That would be a massive resource waste for the normal case where the
> > interval > handler runtime.
> 
> Not if the application can configure this value. So the "normal" case could be
> set to 1 single thread. Only resource-intensive apps would set this differently,
> e.g. to the detected number of cpus.

.. but as we discussed in private, this would involve adding extra attribute
fields to what the standard proposes. I think the problem comes from the fact
that POSIX considers the pthread attributes to contain every possible thread
attribute one can imagine, which does not take into account the internal kernel
state set by other interfaces.

So this leaves us with a single-threaded SIGEV_THREAD, which is pretty much
useless. But at least it is not totally impossible for glibc to get it right by
moving to an implementation which uses only one thread.

So until one finds the time to work on fixing glibc SIGEV_THREAD timers, I would
strongly recommend against using it.

Thanks,

Mathieu

> 
> Mathieu
> 
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
