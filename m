Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab0DSWNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 18:13:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47624 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab0DSWNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 18:13:49 -0400
X-Authority-Analysis: v=1.1 cv=E9k1WvbCwWjFc1mtZtTZCb4xMnZJ3NelAETgZ6iwC6Q= c=1 sm=0 a=zBnlsAAkvaYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=A_kOvf3FS9Ot71pqOTMA:9 a=J1ieX7EJKZzx_LdtmK98SkHVwTsA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
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
In-Reply-To: <20100419220437.GC8811@nowhere>
References: <1271707444.10448.12.camel@gandalf.stny.rr.com>
	 <4BCCBF6D.3030105@am.sony.com>
	 <1271709846.10448.29.camel@gandalf.stny.rr.com>
	 <20100419212950.GB8811@nowhere>
	 <1271713074.10448.101.camel@gandalf.stny.rr.com>
	 <20100419220437.GC8811@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 19 Apr 2010 18:13:47 -0400
Message-ID: <1271715227.10448.145.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 00:04 +0200, Frederic Weisbecker wrote:
> On Mon, Apr 19, 2010 at 05:37:54PM -0400, Steven Rostedt wrote:

> > # cat event/sched/sched_switch/triggers/tracing_off
> > disabled
> > 
> > Or it can be a filter, or enabled.
> 
> 
> Yep, since it would share exatly the same code than filter (as
> filter basically becomes a trigger command), it can behave the
> same: displaying "none" when there is no filter, or a filter.
> 

Then do we make the triggers themselves directories too?

# ls event/sched/sched_switch/triggers/tracing_off
filter   enable

?

> 
> > 
> > This could also allow a user to do:
> > 
> > echo "(a > 100)" > tracing_on
> > echo "(a < 100)" > tracing_off
> 
> 
> Yeah :)
> But if the scope of the "tracing off" is only for this event, then
> rather use:
> 
> echo "(a < 100)" > filter
> 
> You could have tracing_off/on that have this event scope and
> tracing_off/on_all for a global tracing scope.

The two are not equivalent. In fact, just enabling a trigger does not
mean that the event itself will be traced.

-- Steve


