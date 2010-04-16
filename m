Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab0DPT62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 15:58:28 -0400
Received: from www.tglx.de ([62.245.132.106]:38044 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317Ab0DPT61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 15:58:27 -0400
Date: Fri, 16 Apr 2010 21:58:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Chase Douglas <chase.douglas@canonical.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 3/3] Stop tracing on a schedule bug
In-Reply-To: <1271436413.1934.5.camel@localhost>
Message-ID: <alpine.LFD.2.00.1004162155220.3625@localhost.localdomain>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>  <1271262016-18650-3-git-send-email-chase.douglas@canonical.com>  <20100415210357.GG5069@nowhere>  <k2u40ec3ea41004151445je53e7ef2u5c0e48e038e4efca@mail.gmail.com> 
 <alpine.LFD.2.00.1004160051390.3625@localhost.localdomain>  <p2n40ec3ea41004151627u11ca4d7dw46cbd6b58df9f1c8@mail.gmail.com>  <alpine.LFD.2.00.1004160138200.3625@localhost.localdomain>  <alpine.LFD.2.00.1004160204510.3625@localhost.localdomain> 
 <i2z40ec3ea41004152101gd55713f2w9eadd8d5ea721688@mail.gmail.com> <1271436413.1934.5.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

On Fri, 16 Apr 2010, Steven Rostedt wrote:

> On Thu, 2010-04-15 at 21:01 -0700, Chase Douglas wrote:
> 
> > > 2) tracing off can be done via filters on functions and/or events
> > >   already - so I doubt that the tracing_off_event(level) is necessary
> > >   at all.
> > >
> > >   schedule_bug() definitely deserves a separate trace_schedule_bug()
> > >   event which can be used to stop the tracer by already existing
> > >   functionality.
> > 
> > Steven said he would be fine with a separate TRACE_EVENT_<blah> macro
> > for the schedule bug if needed, but I'm not sure we need to go that
> > far. If it's configurable through debugfs at run time then it serves
> > my purpose. Unless you feel we should have finer grained control
> > specifically for scheduling while atomic bugs, I'll just leave it as
> > TRACE_EVENT_WARN.
> 
> I actually like Thomas's idea better. I need to add the "stop trace on
> event" functionality, and we can insert trace events for bugs, and not

I just assumed that it would work for events already. The stop trace on
function filter works perfect and is a very conveniant tool.

> have this whole "stop tracing here" functions. Instead we could just add
> tracepoints and have a way to pick and choose where to stop tracing.
> 
> add a:
> 
> include/trace/events/errors.h
> 
> #define TRACE_SYSTEM errors
> 
> TRACE_EVENT(sched_bug, ....)
> 
> etc,
> 
> 
> When I get back home, I'll add this functionality to stop tracing on
> events. Perhaps I'll even add "TRACE_SUB_SYSTEM" so in the events
> directory, we can have sub layers:
> 
> events/errors/BUG/...
> events/errors/WARNING/...

I like that idea. That's solving the problem in a very elegant way.

Thanks,

	tglx
