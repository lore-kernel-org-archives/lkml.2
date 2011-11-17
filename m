Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab1KQPRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:17:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45994 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757785Ab1KQPRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:17:33 -0500
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=PQ8x_VTtLv8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=QyXUC8HyAAAA:8 a=e7DW1LSZoeMWQMrq26QA:9 a=QEXdDO2ut3YA:10 a=dGJ0OcVc7YAA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH] printk: add console output tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20111117150040.GB18437@somewhere>
References: <20111116151037.GA26166@infradead.org>
	 <1321456652.4502.12.camel@jlt3.sipsolutions.net>
	 <1321461693.4181.26.camel@frodo>
	 <1321461902.4502.14.camel@jlt3.sipsolutions.net>
	 <1321462856.4181.28.camel@frodo>
	 <1321468380.4502.16.camel@jlt3.sipsolutions.net>
	 <1321473443.4181.38.camel@frodo>
	 <1321478719.4502.20.camel@jlt3.sipsolutions.net>
	 <20111117145502.GA18437@somewhere>
	 <1321541877.3997.31.camel@jlt3.sipsolutions.net>
	 <20111117150040.GB18437@somewhere>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 10:17:30 -0500
Message-ID: <1321543050.3533.8.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 16:00 +0100, Frederic Weisbecker wrote:
> On Thu, Nov 17, 2011 at 03:57:57PM +0100, Johannes Berg wrote:
> > On Thu, 2011-11-17 at 15:55 +0100, Frederic Weisbecker wrote:
> > 
> > > > +++ b/kernel/trace/printk-trace.c	2011-11-16 21:22:20.000000000 +0100
> > > > @@ -0,0 +1,14 @@
> > > > +/*
> > > > + * printk trace points
> > > > + *
> > > > + * Copyright (C) 2011 Johannes Berg <johannes.berg@intel.com>
> > > > + */
> > > > +
> > > > +#include <linux/string.h>
> > > > +#include <linux/types.h>
> > > > +#include <linux/workqueue.h>
> > > > +#include <linux/sched.h>
> > > > +#include <linux/module.h>
> > > > +
> > > > +#define CREATE_TRACE_POINTS
> > > > +#include <trace/events/printk.h>
> > > 
> > > Why not defining the tracepoint in kernel/printk.c ?

Right, there's no reason to add another file, except to get Johannes's
copyright in the kernel ;-)

> > 
> > Is that even possible? Do you then have to do something like
> > 
> > #include <.../printk.h>
> > #define CREATE_TRACE_POINTS
> > #include <.../printk.h>
> > 
> > or how else? In any case it seemed more common to not do that.
> 
> You can just do what you did:
> 
> #define CREATE_TRACE_POINTS
> #include <trace/events/printk.h>
> 
> but in kernel/printk.c
> 
> We typically define the tracepoint from the file where an unconditional user
> resides.

The above *is* the correct way to do this.

Thanks Frederic for pointing that out. I should have spotted it, but I
blame my meds ;)

-- Steve


