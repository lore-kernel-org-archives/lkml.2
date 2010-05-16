Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0EPB3x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 21:29:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37331 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab0EPB3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 21:29:51 -0400
X-Authority-Analysis: v=1.1 cv=MoOeBCR3UCSroT7bBzr0mtJUqJhHyBWzyNa37ex1qNU= c=1 sm=0 a=EYIAjt0hOJkA:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=KWooURwyB9K2AUoq34EA:9 a=ce1WeSEgeK3OakSEnH0A:7 a=Bim34qFtgQfdQRmek03azVPlSigA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 3/4] tracing: Allow mmio tracer to display
 trace_printk() and other events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Pekka Paalanen <pq@iki.fi>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20100515104602.59c1f0e1@daedalus.pq.iki.fi>
References: <20100513012110.558313399@goodmis.org>
	 <20100513012302.352845720@goodmis.org>
	 <20100513115414.7688b51d@daedalus.pq.iki.fi>
	 <1273752909.27703.809.camel@gandalf.stny.rr.com>
	 <20100513152915.3d3f852b@daedalus.pq.iki.fi>
	 <1273763483.27703.991.camel@gandalf.stny.rr.com>
	 <20100515104602.59c1f0e1@daedalus.pq.iki.fi>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sat, 15 May 2010 21:29:48 -0400
Message-ID: <1273973388.26328.118.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-15 at 10:46 +0300, Pekka Paalanen wrote:
> Sorry, I'm not at my email every day. Real life...

heh, no problem. I'm in no hurry here.

> 
> On Thu, 13 May 2010 11:11:23 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Thu, 2010-05-13 at 15:29 +0300, Pekka Paalanen wrote:
> > > On Thu, 13 May 2010 08:15:09 -0400
> > 
> > > > It only displays other events if the user enabled those
> > > > events.
> > > > 
> > > > But that said, I don't want to break existing userspace
> > > > tools. I can add a mmiotrace option "mmiotrace_all_events",
> > > > if the user wants to see all events within the mmiotracer
> > > > then they can just enable that option, otherwise, the
> > > > mmiotracer will act like it currently does.
> > > > 
> > > > How does that sound?
> > > 
> > > That would be fine. Is it not redundant with what you said in
> > > your first sentence?
> > > 
> > 
> > Right now with this patch as is. When you enable the mmiotracer it
> > clears the ring buffer. But if someone previously enabled an
> > event (like sched_switch for example) then that event will appear
> > in the output of the tracer.
> > 
> > The user will need to disable that event and restart the
> > mmiotracer so the output will not break the userspace tools. Is
> > this OK?
> 
> I think it is ok. No non-mmiotrace events are enabled automatically,
> right? Except perhaps trace_printk()?

Yep, trace events do not show up in a trace unless a user enabled them
themselves. trace_printk() is only for developers modifying their kernel
and needs works the opposite: You need to disable it from writing.

But trace_printk() only exists in the kernel if a developer added it and
recompiled their kernel. End users will never see it.

> 
> If a user enables other events while mmiotracing, I would
> assume he knows what he is doing. End users doing dumps per
> request never even know about other kinds of tracing than
> mmiotrace.
> 
> > If not, then my suggestion is to have an mmiotracer option that
> > keeps it from printing out any event except for the ones it knows
> > about.
> > 
> > The reason I added this patch in the first place was because Larry
> > Finger was using the mmiotrace with trace_printk() and the
> > current code does not print out the trace_printk() when
> > mmiotracer is active.
> 
> If this is *only* about trace_printk(), why not make a handler
> for it to emit MARK lines? Actually, I somehow assumed that
> would have been the case, but apparently the event type is
> different. I do not recall these things too well anymore.

Well, I can imagine that another user may want events too. But still,
I'm thinking the original patch to write everything should work. You
would only see events if you specifically enable them.

> 
> 
> Thanks for keeping me in the loop.
> 

No problem, it is your code we are dealing with.

-- Steve


