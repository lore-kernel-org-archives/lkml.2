Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1EYUXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:23:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62910 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab1EYUXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:23:32 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=oOzZnGprw0sA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=yv5NWj7In-qZ4A2nawEA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH] ftrace: Add internal recursive checks
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Witold Baryluk <baryluk@smp.if.uj.edu.pl>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.02.1105252054270.3078@ionos>
References: <1306348063.1465.116.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1105252054270.3078@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 25 May 2011 16:23:29 -0400
Message-ID: <1306355009.1465.119.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 20:57 +0200, Thomas Gleixner wrote:
> On Wed, 25 May 2011, Steven Rostedt wrote:
> > +
> > +	/* Only current can touch these values */
> > +#define trace_recursion_inc() (current)->trace_recursion++
> > +#define trace_recursion_dec() (current)->trace_recursion--
> > +	/* Ring buffer has the 10 LSB bits to count */
> > +#define trace_recursion_buffer() ((current)->trace_recursion & 0x3ff)
> > +#define TRACE_INTERNAL_BIT		(1<<11)
> > +#define TRACE_GLOBAL_BIT		(1<<12)
> > +#define trace_recursion_set(bit)	(current)->trace_recursion |= (bit)
> > +#define trace_recursion_clear(bit)	(current)->trace_recursion &= ~(bit)
> > +#define trace_recursion_test(bit)	((current)->trace_recursion & (bit))
> > +
> >  #endif /* CONFIG_TRACING */
> 
> Bah, these are only used in kernel/trace/. So can you please add them
> to a kernel/trace local header file instead of cramming it mindlessly
> into task_struct just because you're lazy?

Actually the lazy thing to do was to include it only in
kernel/trace/trace.h BUT...

Any user of the function tracer (callbacks) may need to do the same
thing, because the callbacks could be called without going though the
list lookup and may need their own bit set.

But that said, I'll move these over to include/linux/ftrace.h as that is
probably the better location for it.

-- Steve


