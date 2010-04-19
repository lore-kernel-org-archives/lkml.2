Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab0DSVh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:37:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56776 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab0DSVh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:37:56 -0400
X-Authority-Analysis: v=1.1 cv=E9k1WvbCwWjFc1mtZtTZCb4xMnZJ3NelAETgZ6iwC6Q= c=1 sm=0 a=zBnlsAAkvaYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=HNgIk0J_KvSHESlEGNYA:9 a=nYdWiXNiG5D1olA7iFdsE3BbX2EA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
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
In-Reply-To: <20100419212950.GB8811@nowhere>
References: <1271707444.10448.12.camel@gandalf.stny.rr.com>
	 <4BCCBF6D.3030105@am.sony.com>
	 <1271709846.10448.29.camel@gandalf.stny.rr.com>
	 <20100419212950.GB8811@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 19 Apr 2010 17:37:54 -0400
Message-ID: <1271713074.10448.101.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 23:29 +0200, Frederic Weisbecker wrote:

> The problem with having triggers defined in the filter file is that
> you couldn't set a normal filter plus a trigger.
> 
> That said a filter itself could be a trigger.
> 
> if (cond) filter
> 
> This is going to break some ABI though.
> 
> In fact having one file per trigger type is going to make the
> things much easier if you don't want to encumber with syntax parsing,
> and just reuse the filtering code as is with very few modification.
> This is going to be also easier for the users as they don't have to
> remember the syntax or the available triggers.
> 
> Say you are in an event directory:
> 
> $ ls triggers/
> 
> filter
> tracing_off
> tracing_on
> dump_trace
> 
> $ echo "(a == 1 && b == 2)" > tracing_off
> 
> So in the above example, you just reuse the filtering code,
> no need to parse an if or a command.
> The filter becomes a command. I've listed it in the triggers
> directory but this just to express the fact it can be treated
> like whatever trigger command, this is just an implementation
> POV. In fact we can just keep it in the event directory.


I like this. Heck, all registered triggers can be shown here.

# cat event/sched/sched_switch/triggers/tracing_off
disabled

Or it can be a filter, or enabled.

This could also allow a user to do:

echo "(a > 100)" > tracing_on
echo "(a < 100)" > tracing_off

-- Steve



