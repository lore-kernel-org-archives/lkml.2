Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965760Ab0HFV3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 17:29:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49105 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761764Ab0HFV3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 17:29:37 -0400
X-Authority-Analysis: v=1.1 cv=puNM1lMKksHKE6hmMqMstpyRmqXf+M/teYaxpNq+S3U= c=1 sm=0 a=vMBlIDAt6S4A:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=fd6j61FBm051ZTlz6r0A:9 a=ehj1m-hygN0oItJ1aMUfAdmFZh8A:4 a=PUjeQqilurYA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [PATCH] tracing: wake up tasks reading trace_pipe on write to
 trace_marker
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20100806205549.GB5345@nowhere>
References: <20100727224408.GB4142@joi.lan>
	 <1281127136.3352.13.camel@gandalf.stny.rr.com>
	 <20100806205549.GB5345@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 06 Aug 2010 17:29:35 -0400
Message-ID: <1281130175.3352.15.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 22:55 +0200, Frederic Weisbecker wrote:

> > This can't work. trace_printk() and friends must be able to be used
> > anywhere. This can cause race conditions with the rq locks in the
> > scheduler.
> > 
> > But you do bring up a good idea. That is, perhaps we should have a way
> > to attach to known safe tracepoints that we can hook to to check if a
> > wake up should happen or not.
> 
> 
> This could be a simple macro that takes the name of the trace event:
> 
> 
> DEFINE_EVENT(event_tpl, event_name, ...);
> 
> 
> TRACE_EVENT_NO_WAKE(event_name);
> 

Yeah, that may be worth doing for 2.6.37. Might as well also add a
trace_printk_nowake() too, when you know you are in dangerous locations
like the scheduler or NMI.


> I think trace events should be wakeable by default as it looks safe for
> most of them. But probably we don't want that per event class.
> 
> In the unsafe list, I only have some sched and lock events in
> mind, but I bet there are some others.

Yep, will put that on my todo list.

Thanks,

-- Steve


