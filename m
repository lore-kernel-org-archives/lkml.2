Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab1KQPAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:00:51 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50665 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712Ab1KQPAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:00:50 -0500
Date: Thu, 17 Nov 2011 16:00:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] printk: add console output tracing
Message-ID: <20111117150040.GB18437@somewhere>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321541877.3997.31.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 03:57:57PM +0100, Johannes Berg wrote:
> On Thu, 2011-11-17 at 15:55 +0100, Frederic Weisbecker wrote:
> 
> > > +++ b/kernel/trace/printk-trace.c	2011-11-16 21:22:20.000000000 +0100
> > > @@ -0,0 +1,14 @@
> > > +/*
> > > + * printk trace points
> > > + *
> > > + * Copyright (C) 2011 Johannes Berg <johannes.berg@intel.com>
> > > + */
> > > +
> > > +#include <linux/string.h>
> > > +#include <linux/types.h>
> > > +#include <linux/workqueue.h>
> > > +#include <linux/sched.h>
> > > +#include <linux/module.h>
> > > +
> > > +#define CREATE_TRACE_POINTS
> > > +#include <trace/events/printk.h>
> > 
> > Why not defining the tracepoint in kernel/printk.c ?
> 
> Is that even possible? Do you then have to do something like
> 
> #include <.../printk.h>
> #define CREATE_TRACE_POINTS
> #include <.../printk.h>
> 
> or how else? In any case it seemed more common to not do that.

You can just do what you did:

#define CREATE_TRACE_POINTS
#include <trace/events/printk.h>

but in kernel/printk.c

We typically define the tracepoint from the file where an unconditional user
resides.
