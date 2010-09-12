Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab0ILUj2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 16:39:28 -0400
Received: from mail.openrapids.net ([64.15.138.104]:56503 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753592Ab0ILUj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 16:39:27 -0400
Date: Sun, 12 Sep 2010 16:39:25 -0400
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
Message-ID: <20100912203925.GE32327@Krystal>
References: <20100911173732.551632040@efficios.com> <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop> <AANLkTin0LOuTOcJPiZcZGeZMdqsy2dohyrREw2GGhddJ@mail.gmail.com> <1284237380.2251.56.camel@laptop> <AANLkTi=a91QX-FLURFWNsjbCS1bDLr6GqSpC4_uzm3ta@mail.gmail.com> <1284282392.2251.81.camel@laptop> <1284282867.2251.84.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284282867.2251.84.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:38:07 up 232 days, 23:14,  4 users,  load average: 0.13, 0.10,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Sun, 2010-09-12 at 11:06 +0200, Peter Zijlstra wrote:
> >  * is slice length, + is period length
> > 
> > Patch (sched_latency = 10, sched_min_gran = 10/3)
> > 
> > 
> > 30 |                             +
> >    |
> >    |
> >    |                          +
> >    |
> >    |
> >    |
> >    |
> >    |
> >    |
> > 20 |
> >    |
> >    |
> >    |
> >    |
> >    |
> >    |
> >    |
> >    |
> >    |
> > 10 |  *  +  +  +  +  +  +  +
> >    |
> >    |
> >    |
> >    |
> >    |     *
> >    |
> >    |        *  *              *  *  *  *  *  *
> >    |              *  *
> >    |                    *  *
> > 0  +---------------------------------------------------------
> >    0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 
> 
> 
> Vertical is time , horz is nr_running.
> 
> 
> Note how things fall of a cliff when nr_running goes from 8 to 9. Andrew
> usually kicks people in the teeth for phase change behaviour.

Please refer to my other email asking why your sched_latency = 10 rather than
what I see in sched_fair.c:

unsigned int sysctl_sched_latency = 6000000ULL;

I really might have missed something important there. Is this value recomputed
dynamically somewhere ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
