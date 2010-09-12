Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab0ILSQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:16:28 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37493 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751663Ab0ILSQ1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:16:27 -0400
Date: Sun, 12 Sep 2010 14:16:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
	nr_running
Message-ID: <20100912181626.GB32327@Krystal>
References: <20100911173732.551632040@efficios.com> <20100911174003.051303123@efficios.com> <20100912061452.GA3383@elte.hu> <1284276098.9111.24.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1284276098.9111.24.camel@marge.simson.net>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:13:50 up 232 days, 20:50,  6 users,  load average: 0.07, 0.06,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith (efault@gmx.de) wrote:
> On Sun, 2010-09-12 at 08:14 +0200, Ingo Molnar wrote:
> > * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > 
> > > (on a uniprocessor 2.0 GHz Pentium M)
> > > 
> > > * Without the patch:
> > > 
> > >  - wakeup-latency with SIGEV_THREAD in parallel with youtube video and
> > >    make -j10
> > > 
> > > maximum latency: 50107.8 탎
> > > average latency: 6609.2 탎
> > > missed timer events: 0
> > 
> > I tried your patches on a similar UP system, using wakeup-latency.c. I 
> > also measured the vanilla upstream kernel (cced86a) with the default 
> > granularity settings, and also vanilla with a sched_min_granularity/3 
> > tune (patch attached below for that).
> > 
> > I got the following results (make -j10 kbuild load, average of 3 runs):
> > 
> >  vanilla: 
> > 
> >   maximum latency: 38278.9 탎
> >   average latency:  7730.1 탎
> > 
> >  mathieu-dyn:
> > 
> >   maximum latency: 28698.8 탎
> >   average latency:  7757.1 탎
> > 
> >  peterz-min_gran/3:
> > 
> >   maximum latency: 22702.1 탎
> >   average latency:  6684.8 탎
> 
> One thing that springs to mind with make is that it does vfork, so kinda
> sorta continues running in drag, so shouldn't get credit for sleeping,
> as that introduces bogus spread.  Post vfork parent notification time
> adjustment may suffice, think I'll try that.

Hrm, I might be misunderstanding what you are saying here, but when a new
process/thread is forked and woken up, we fall in the "initial" case of
place_entity, so we increase the vruntime of a whole slice rather than getting
credit for sleeping.

Or am I missing your point ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
