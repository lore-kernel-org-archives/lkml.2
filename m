Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab0DSUoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 16:44:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51084 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab0DSUoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 16:44:08 -0400
X-Authority-Analysis: v=1.1 cv=ZUag8tkj9kgmNMrzofuoEsXxpG43g9sRv4eUZcQ4+as= c=1 sm=0 a=zBnlsAAkvaYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=Cl93p3Yo3IC6YUjMddsA:9 a=ImbjCMi8EUaFmQa7AvYjdokM6D4A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: request to add trace off and trace on with events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Tim Bird <tim.bird@am.sony.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Chase Douglas <chase.douglas@canonical.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BCCBF6D.3030105@am.sony.com>
References: <1271707444.10448.12.camel@gandalf.stny.rr.com>
	 <4BCCBF6D.3030105@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 19 Apr 2010 16:44:06 -0400
Message-ID: <1271709846.10448.29.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 13:39 -0700, Tim Bird wrote:
> On 04/19/2010 01:04 PM, Steven Rostedt wrote:
> > Hi Tom,
> > 
> > Could you add a way to do a call to tracing_on() or tracing_off() via
> > the filters. I would like to do something like:
> > 
> > 
> > echo 'if (pid == 1234) traceoff' > events/sched/sched_wakeup/filter
> > 
> > Where, if the sched_wakeup event is hit with pid == 1234 it will turn
> > tracing off.
> 
> Just a comment on the nomenclature.  In KFT I called
> things like this "triggers".  I'm not sure what other

Yeah, Mathieu calls them triggers too. But if you do, I'm fine with
calling them that as well.

> tracing systems call them.  I'm a little worried about
> overloading the filtering abstraction with trigger
> semantics.  (I like the idea of triggers, but it might
> be better to control them with another pseudo-file for
> clarity.)
> 
> I suppose both are a form of conditional execution.
> Filtering has an implicit action of either 'trace this'
> or 'don't trace this', while triggering usually has
> an action, often explicit, to start or stop tracing.
> However, since they both use the conditional testing,
> it might be a pain to reproduce this code for a different
> pseudo-file.

I thought about a separate file, but I like the idea of having control
over them. We could add a "trigger" file too, but I'm not sure if that
would be any clearer.

If we add a trigger file, then the filter can be separate, and we just
trigger the trigger if the filter passes.

This may be better, because then the triggers do not mess with the
filtering code, and I can add it without modification to Tom's code.

-- Steve


