Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab0DSX7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 19:59:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48280 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab0DSX73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 19:59:29 -0400
X-Authority-Analysis: v=1.1 cv=ZUag8tkj9kgmNMrzofuoEsXxpG43g9sRv4eUZcQ4+as= c=1 sm=0 a=zBnlsAAkvaYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=46Z1fGTnuWNX3Zu3_YsA:9 a=cKN8gCrmeHwS3WKQlQEA:7 a=hjSqr5-rcW97W-9wK6rO9BIgWeEA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: request to add trace off and trace on with events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tim Bird <tim.bird@am.sony.com>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Chase Douglas <chase.douglas@canonical.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100419230438.GA11493@nowhere>
References: <1271707444.10448.12.camel@gandalf.stny.rr.com>
	 <4BCCBF6D.3030105@am.sony.com>
	 <1271709846.10448.29.camel@gandalf.stny.rr.com>
	 <20100419212950.GB8811@nowhere>
	 <1271713074.10448.101.camel@gandalf.stny.rr.com>
	 <20100419220437.GC8811@nowhere>
	 <1271715227.10448.145.camel@gandalf.stny.rr.com>
	 <20100419230438.GA11493@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 19 Apr 2010 19:59:26 -0400
Message-ID: <1271721566.10448.162.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 01:04 +0200, Frederic Weisbecker wrote:

> > # ls event/sched/sched_switch/triggers/tracing_off
> > filter   enable
> > 
> > ?
> 
> 
> That would be perhaps an overkill.

Perhaps, but I was also thinking of having triggers in the system level.
That way all events below it can trigger.

> Having a filter inside means it's on, otherwise it's off.
> 
> 
> 
> > 
> > > 
> > > > 
> > > > This could also allow a user to do:
> > > > 
> > > > echo "(a > 100)" > tracing_on
> > > > echo "(a < 100)" > tracing_off
> > > 
> > > 
> > > Yeah :)
> > > But if the scope of the "tracing off" is only for this event, then
> > > rather use:
> > > 
> > > echo "(a < 100)" > filter
> > > 
> > > You could have tracing_off/on that have this event scope and
> > > tracing_off/on_all for a global tracing scope.
> > 
> > The two are not equivalent. In fact, just enabling a trigger does not
> > mean that the event itself will be traced.
> 
> 
> Yeah, the enable file would first need to be activated before any
> trigger to take effect on the event, just like filters.
> 
> In fact I was thinking of tracing_on/tracing_off as kinds of
> local pause/resume.
> 
> And tracing_on_global/tracing_off_global would act like what does
> /debug/tracing/tracing_on: something that disables every tracing.
> 
> But of course, before any of these conditional triggers to be
> evaluated, you need to enable the corresponding event.

We could have a "trace_event_on" and "trace_event_off" trigger that only
enables the event when hit.

Actually, we can have these triggers enable other events, or make
dynamic triggers:

echo "enable_sched_switch" > events/sched/sched_wakeup/trigger/activate

or something similar.

-- Steve



