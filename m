Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab0EZRi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:38:58 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:52301 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757138Ab0EZRi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:38:57 -0400
Date: Wed, 26 May 2010 18:38:15 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Kevin D. Kissell" <kevink@paralogos.com>
Cc: Julia Lawall <julia@diku.dk>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Affinity Automation (was Re: [PATCH 3/17] arch/mips/kernel: Add
 missing read_unlock)
Message-ID: <20100526173815.GB17043@linux-mips.org>
References: <Pine.LNX.4.64.1005261754390.23743@ask.diku.dk>
 <20100526163227.GA17043@linux-mips.org>
 <4BFD5A19.5030602@paralogos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFD5A19.5030602@paralogos.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 10:27:53AM -0700, Kevin D. Kissell wrote:
> Date:   Wed, 26 May 2010 10:27:53 -0700
> From: "Kevin D. Kissell" <kevink@paralogos.com>
> To: Ralf Baechle <ralf@linux-mips.org>
> CC: Julia Lawall <julia@diku.dk>, linux-mips@linux-mips.org,
> 	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
> Subject: Affinity Automation (was Re: [PATCH 3/17] arch/mips/kernel: Add
>  missing
>  read_unlock)
> Content-Type: text/plain; charset=ISO-8859-1; format=flowed
> 
> Ralf Baechle wrote:
> >Your patch appears correct - and mipsmt_sys_sched_setaffinity() even
> >more broken than you thought.  It duplicates some code from kernel/sched.c
> >and has gotten out of sync.
> Yeah, that was inevitable.  Since the distribution of the previous
> message seems to cover concerned developers outside the MIPS
> community, let me make one final(?) plea to actually do this right.
> 
> The MIPS SMTC support for managing a single FPU context on a
> processor with multiple integer TC contexts involves having the
> system make automous, real time, decisions about scheduling
> affinity.  It may be a first, but it can't possibly be the only
> case, especially as we've started seeing more and more mainstream
> multi-core, multi-thread designs.  System and chip resources are
> going to be "closer" to one processor or another.  The current Linux
> paradigm is that it's the responsibility of programs, or users, to
> know what the optimal placement of processes should be for a given
> system platform, and while it's absolutely appropriate to provide
> that level of control for the cases where the user really does know
> best, it's mildly insane to make that the only way that thread
> placement can be optimized.  It's really the OS's job to match
> demand to resources.
> 
> My contention years ago was, and remains, that it would be a bad
> idea to burden the main scheduler loop with checks for two different
> levels of affinity, system-automatic and user-specified.  It would
> add non-trivially to the cache footprint and execution overhead of
> thread dispatch, and there's no logical need for it.  So the model I
> proposed, and implemented in the cloned affinity system calls for
> SMTC, was that a *single* affinity mask continue to be used by the
> scheduler, but that the per-thread data structures carry two:  The
> one requested explicitly by the user, and the one actually used by
> the scheduler.  The idea is that normally those two are the same,
> but that the system - in the MIPS SMTC case, the FPU emulator - can
> overlay its constraints with the user's constraints to come up with
> an intersection-of-sets constraint that satisfies both (there was a
> clause which prevents system affinity heuristics from restricting
> the affinity mask to a null set of CPUs, though of course the user
> can do that if he really wants to).
> 
> There's nothing particularly MIPS-specific about the problem or the
> solution.  Most of the mechanisms should really be in
> platform-independent code, so we don't get the drift of cloned
> components.
> 
> I don't recall who owned the scheduler at the time, but whoever it
> was was too busy dealing with mainstream processor problems to even
> engage in a dialogue about this.  Is it time to raise the question
> again?

That was Ingo Molnar.  The scheduler is owned by these two guys:

SCHEDULER
M:      Ingo Molnar <mingo@elte.hu>
M:      Peter Zijlstra <peterz@infradead.org>
S:      Maintained
F:      kernel/sched*
F:      include/linux/sched.h

I've added them to cc.

  Ralf
