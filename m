Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab0IKUwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 16:52:16 -0400
Received: from mail.openrapids.net ([64.15.138.104]:53791 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752182Ab0IKUwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 16:52:15 -0400
Date: Sat, 11 Sep 2010 16:52:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
	nr_running
Message-ID: <20100911205213.GA1390@Krystal>
References: <20100911173732.551632040@efficios.com> <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop> <AANLkTin0LOuTOcJPiZcZGeZMdqsy2dohyrREw2GGhddJ@mail.gmail.com> <1284237380.2251.56.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284237380.2251.56.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:49:23 up 231 days, 23:26,  5 users,  load average: 0.08, 0.06,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Sat, 2010-09-11 at 12:21 -0700, Linus Torvalds wrote:
> > On Sat, Sep 11, 2010 at 11:57 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > Not at all charmed, this look like random changes without conceptual
> > > integrity.
> > 
> > I wish people actually looked at the _numbers_ and reacted to them,
> > rather than argue theory.
> > 
> > Guys, we have cases of bad latency under load. That's a pretty
> > undeniable fact. Arguing against a patch because of some theoretical
> > issue without at all even acknowledging the latency improvements is, I
> > think, really bad form.
> > 
> > So please. Acknowledge the latency issue. And come up with better
> > patches, rather than just shoot down alternatives. Because if the
> > answer is just NAK with no alternative, then that answer is worthless.
> > No?
> 
> >From what I can make up:
> 
>   LAT=`cat /proc/sys/kernel/sched_latency_ns`; 
>   echo $((LAT/8)) > /proc/sys/kernel/sched_min_granularity_ns
> 
> will give you pretty much the same result as Mathieu's patch.

Not quite. Doing what you propose here would change the scheduling granularity
(thus decrease throughput because it would schedule more often) when there are
few tasks running. My approach does not: it only shrinks granularity when the
number of running tasks increases over 3.

Thanks,

Mathieu

> 
> But if you want us to change the scheduler to be more latency sensitive
> and trade in throughput for other benchmarks, we can do that.

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
