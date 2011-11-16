Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab1KPOwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:52:06 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:48131 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab1KPOwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:52:04 -0500
Subject: Re: [PATCH] tracing: add trace console
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1321454928.4181.22.camel@frodo>
References: <1321438728.4773.16.camel@jlt3.sipsolutions.net>
	 <1321452954.4181.20.camel@frodo>  <1321453537.27735.0.camel@twins>
	 <1321453846.4502.0.camel@jlt3.sipsolutions.net>
	 <1321454928.4181.22.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 15:51:57 +0100
Message-ID: <1321455117.4502.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 09:48 -0500, Steven Rostedt wrote:
> On Wed, 2011-11-16 at 15:30 +0100, Johannes Berg wrote:
> > On Wed, 2011-11-16 at 15:25 +0100, Peter Zijlstra wrote:
> > 
> > > > >  kernel/trace/Kconfig         |   13 ++++++++++
> > > > >  kernel/trace/Makefile        |    2 +
> > > > >  kernel/trace/trace-console.c |   55 +++++++++++++++++++++++++++++++++++++++++++
> > > > >  3 files changed, 70 insertions(+)
> > > > > 
> > > > > --- a/kernel/trace/Kconfig    2011-11-16 11:11:27.000000000 +0100
> > > > > +++ b/kernel/trace/Kconfig    2011-11-16 11:11:35.000000000 +0100
> > > > > @@ -368,6 +368,19 @@ config BLK_DEV_IO_TRACE
> > > > >  
> > > > >         If unsure, say N.
> > > > >  
> > > > > +config TRACE_CONSOLE
> > > > > +     tristate "Support for a tracing console"
> > > > > +     help
> > > > > +       Say M (or Y if you must, but this is not recommended) 
> > > 
> > > Why not?
> > 
> > It'll always be registered and you have no way to turn it off then, so
> > you can't trace without getting every printk. I didn't want to add extra
> > API to toggle it, but building it in might be a bit odd that way.
> 
> Actually, that's not quite true. You could just do:
> 
> echo 0 > /debug/tracing/options/trace_printk

Oh. Maybe I'll just remove it this then. I guess you kinda have to know
(or be told) you want this anyway.

johannes

