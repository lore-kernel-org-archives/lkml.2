Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab0DPQxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 12:53:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35024 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758623Ab0DPQxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 12:53:05 -0400
X-Authority-Analysis: v=1.1 cv=E9k1WvbCwWjFc1mtZtTZCb4xMnZJ3NelAETgZ6iwC6Q= c=1 sm=0 a=8-Qj6YJtbBAA:10 a=IkcTkHD0fZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=NJR8HFZXybemMihKY2gA:9 a=L0xRHl-b1k38QqFrJo3at3PZvWQA:4 a=QEXdDO2ut3YA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 3/3] Stop tracing on a schedule bug
From: Steven Rostedt <rostedt@goodmis.org>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <i2z40ec3ea41004152101gd55713f2w9eadd8d5ea721688@mail.gmail.com>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>
	 <1271262016-18650-3-git-send-email-chase.douglas@canonical.com>
	 <20100415210357.GG5069@nowhere>
	 <k2u40ec3ea41004151445je53e7ef2u5c0e48e038e4efca@mail.gmail.com>
	 <alpine.LFD.2.00.1004160051390.3625@localhost.localdomain>
	 <p2n40ec3ea41004151627u11ca4d7dw46cbd6b58df9f1c8@mail.gmail.com>
	 <alpine.LFD.2.00.1004160138200.3625@localhost.localdomain>
	 <alpine.LFD.2.00.1004160204510.3625@localhost.localdomain>
	 <i2z40ec3ea41004152101gd55713f2w9eadd8d5ea721688@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 12:46:53 -0400
Message-ID: <1271436413.1934.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-15 at 21:01 -0700, Chase Douglas wrote:

> > 2) tracing off can be done via filters on functions and/or events
> >   already - so I doubt that the tracing_off_event(level) is necessary
> >   at all.
> >
> >   schedule_bug() definitely deserves a separate trace_schedule_bug()
> >   event which can be used to stop the tracer by already existing
> >   functionality.
> 
> Steven said he would be fine with a separate TRACE_EVENT_<blah> macro
> for the schedule bug if needed, but I'm not sure we need to go that
> far. If it's configurable through debugfs at run time then it serves
> my purpose. Unless you feel we should have finer grained control
> specifically for scheduling while atomic bugs, I'll just leave it as
> TRACE_EVENT_WARN.

I actually like Thomas's idea better. I need to add the "stop trace on
event" functionality, and we can insert trace events for bugs, and not
have this whole "stop tracing here" functions. Instead we could just add
tracepoints and have a way to pick and choose where to stop tracing.

add a:

include/trace/events/errors.h

#define TRACE_SYSTEM errors

TRACE_EVENT(sched_bug, ....)

etc,


When I get back home, I'll add this functionality to stop tracing on
events. Perhaps I'll even add "TRACE_SUB_SYSTEM" so in the events
directory, we can have sub layers:

events/errors/BUG/...
events/errors/WARNING/...

etc

-- Steve


