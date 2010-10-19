Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab0JSV4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:56:51 -0400
Received: from ozlabs.org ([203.10.76.45]:34369 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab0JSV4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:56:50 -0400
Date: Wed, 20 Oct 2010 08:56:42 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Alexey Kardashevskiy <aik@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf, powerpc: Fix power_pmu_event_init to not use
 event->ctx
Message-ID: <20101019215642.GB28973@brick.ozlabs.ibm.com>
References: <20101019055535.GA10398@drongo>
 <1287476932.29097.1617.camel@twins>
 <1287489030.1994.8.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287489030.1994.8.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 01:50:30PM +0200, Peter Zijlstra wrote:

> On Tue, 2010-10-19 at 10:28 +0200, Peter Zijlstra wrote:
>  
> > > (The reason it needs to know whether it is a per-task event is because
> > > there are some hardware events on Power systems which only count when
> > > the processor is not idle, and there are some fixed-function counters
> > > which count such events.  For example, the "run cycles" event counts
> > > cycles when the processor is not idle.  If the user asks to count
> > > cycles, we can use "run cycles" if this is a per-task event, since the
> > > processor is running when the task is running, by definition.  We
> > > can't use "run cycles" if the user asks for "cycles" on a system-wide
> > > counter.)
> 
> Right, so the problem comes from you using run-cycles as cycles? How
> does that interact with things like cpu_relax() will that generate a
> difference in run-cycles vs cycles?

Cycles in cpu_relax() are still counted as run cycles.  Whether cycles
are considered "run" cycles or "idle" cycles is controlled by a bit in
an SPR that we set and clear in the idle loop and in the interrupt
entry code.  Only cycles when we're actually in the idle loop count as
"idle" cycles.

Paul.
