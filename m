Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab1BQPqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:46:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48979 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab1BQPqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:46:35 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=JGpTz_e83PYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=L9VTgz3bM-Nn0lf47EMA:9 a=dbJilpM4d4_IRrSjHUQA:7 a=8HqBBV4ImTl7sEPZDnUMHsqgLQIA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is
 for x86_64 right now)
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>, 2nddept-manager@sdl.hitachi.co.jp
In-Reply-To: <4D5D4013.4070602@hitachi.com>
References: <20110209200249.111932716@goodmis.org>
	 <4D5D1672.6070206@hitachi.com>
	 <1297948703.23343.907.camel@gandalf.stny.rr.com>
	 <4D5D4013.4070602@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Feb 2011 10:46:31 -0500
Message-ID: <1297957591.23343.921.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 00:34 +0900, Masami Hiramatsu wrote:
> (2011/02/17 22:18), Steven Rostedt wrote:
> > On Thu, 2011-02-17 at 21:37 +0900, Masami Hiramatsu wrote:
> > 
> >> Oops! with this change, current kprobes might not be able to probe
> >> the entry of functions, because that is always reserved by ftrace!
> >> I think we need to have some new interface for replacing each other
> >> safely...
> > 
> > Good point. I suspect that this wont be ready till .40 anyway. When I
> > get a chance to work more an this, I'll also include patches where if
> > -mfentry is activated kprobes will just hook to the mcount caller
> > instead. Or ftrace itself :)
> 
> Ah, that's a good idea! :) it could be done without -mfentry too.
> But is that possible to modify just one mcount entry? I also worry
> about the latency of enabling/disabling one entry.

I would have it go through the ftrace function tracing facility, which
would handle which entry to enable/disable. It still does stopmachine.
Is that an issue to enable/disable kprobes? The "fast" enable/disable
could be done by the called function to just ignore the call.

Also note, if there's other callbacks that are attached to the function
being traced, no stop machine is enabled. The callbacks are just a list
and as long as a function has an associated callback, no code
modification needs to be done to add or remove other callbacks.

> 
> BTW, without dynamic ftrace (no code modifying), I think we don't
> need to reserve mcount code, because no one modifies it.

Correct. And even today, you can remove any kprobe code that checks for
mcount without dynamic ftrace enabled. But I'm not sure if anyone
enables the function tracer without dynamic ftrace, except for debugging
in archs that do not support dynamic ftrace. As the overhead of this is
quite high even when function tracer is disabled.

-- Steve


