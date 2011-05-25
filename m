Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab1EYWyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 18:54:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:40847 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab1EYWyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 18:54:19 -0400
Date: Thu, 26 May 2011 00:54:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Witold Baryluk <baryluk@smp.if.uj.edu.pl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] ftrace: Add internal recursive checks
In-Reply-To: <1306355009.1465.119.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1105260050250.3078@ionos>
References: <1306348063.1465.116.camel@gandalf.stny.rr.com>  <alpine.LFD.2.02.1105252054270.3078@ionos> <1306355009.1465.119.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Steven Rostedt wrote:

> On Wed, 2011-05-25 at 20:57 +0200, Thomas Gleixner wrote:
> > On Wed, 25 May 2011, Steven Rostedt wrote:
> > > +
> > > +	/* Only current can touch these values */
> > > +#define trace_recursion_inc() (current)->trace_recursion++
> > > +#define trace_recursion_dec() (current)->trace_recursion--
> > > +	/* Ring buffer has the 10 LSB bits to count */
> > > +#define trace_recursion_buffer() ((current)->trace_recursion & 0x3ff)
> > > +#define TRACE_INTERNAL_BIT		(1<<11)
> > > +#define TRACE_GLOBAL_BIT		(1<<12)
> > > +#define trace_recursion_set(bit)	(current)->trace_recursion |= (bit)
> > > +#define trace_recursion_clear(bit)	(current)->trace_recursion &= ~(bit)
> > > +#define trace_recursion_test(bit)	((current)->trace_recursion & (bit))
> > > +
> > >  #endif /* CONFIG_TRACING */
> > 
> > Bah, these are only used in kernel/trace/. So can you please add them
> > to a kernel/trace local header file instead of cramming it mindlessly
> > into task_struct just because you're lazy?
> 
> Actually the lazy thing to do was to include it only in
> kernel/trace/trace.h BUT...
> 
> Any user of the function tracer (callbacks) may need to do the same
> thing, because the callbacks could be called without going though the
> list lookup and may need their own bit set.

Errm, what means _MAY_? There are no users outside of kernel/trace/
for this right now. Are you saying that you forgot to update some code
or is this about random out of tree users?
 
Thanks,

	tglx
