Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab0ILHVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 03:21:20 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:51377 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751754Ab0ILHVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 03:21:19 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ndDwf8EsnrOu4ntNVM0xcglWgrcKEg3xmoA0TAY
	HcS+9iQf/k0DVu
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <20100912061452.GA3383@elte.hu>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com>  <20100912061452.GA3383@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Sep 2010 09:21:38 +0200
Message-Id: <1284276098.9111.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-12 at 08:14 +0200, Ingo Molnar wrote:
> * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > (on a uniprocessor 2.0 GHz Pentium M)
> > 
> > * Without the patch:
> > 
> >  - wakeup-latency with SIGEV_THREAD in parallel with youtube video and
> >    make -j10
> > 
> > maximum latency: 50107.8 µs
> > average latency: 6609.2 µs
> > missed timer events: 0
> 
> I tried your patches on a similar UP system, using wakeup-latency.c. I 
> also measured the vanilla upstream kernel (cced86a) with the default 
> granularity settings, and also vanilla with a sched_min_granularity/3 
> tune (patch attached below for that).
> 
> I got the following results (make -j10 kbuild load, average of 3 runs):
> 
>  vanilla: 
> 
>   maximum latency: 38278.9 µs
>   average latency:  7730.1 µs
> 
>  mathieu-dyn:
> 
>   maximum latency: 28698.8 µs
>   average latency:  7757.1 µs
> 
>  peterz-min_gran/3:
> 
>   maximum latency: 22702.1 µs
>   average latency:  6684.8 µs

One thing that springs to mind with make is that it does vfork, so kinda
sorta continues running in drag, so shouldn't get credit for sleeping,
as that introduces bogus spread.  Post vfork parent notification time
adjustment may suffice, think I'll try that.

	-Mike

