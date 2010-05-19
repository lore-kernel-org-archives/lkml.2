Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0ESTik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:38:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab0ESTij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:38:39 -0400
X-Authority-Analysis: v=1.1 cv=XlIRUSWzFvHiorqRgyN8fup7OiOLcGcwhtEWqPJTlSs= c=1 sm=0 a=PMJxTGDUVXsA:10 a=0qYQvVkOOIcA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=OU6sqDUyULhso8YJjvsA:9 a=R1cLvV8W5MgR9kzBrDoA:7 a=N2QZfOWX0boA_aurDMEnsB3xqI4A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC] Unified Ring Buffer (Next Generation)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <20100519192542.GD18073@basil.fritz.box>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com>
	 <20100519181001.GC18073@basil.fritz.box>
	 <1274294658.26328.997.camel@gandalf.stny.rr.com>
	 <20100519192542.GD18073@basil.fritz.box>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 19 May 2010 15:38:33 -0400
Message-ID: <1274297913.26328.1057.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 21:25 +0200, Andi Kleen wrote:

> > Perhaps, but the goal is actually to handle all the features of perf and
> > ftrace in a generic fashion.
> 
> Ok so your goal is to only cover perf and ftrace and let all 
> the other users be alone? 
> 

Yes, my goal is to unify perf and ftrace, but that's because that is
what I am working most on.

> > 
> > You also bring up a point that I try very hard to get across. When
> > people think of a ring buffer, they think of the ones that they created
> > in CS101, not realizing that when you are dealing with production
> > systems, handling the requirements makes the buffering much more
> > complex.
> 
> For most users the simple ones are totally adequate though.
> 
> > Perhaps the answer is we are fine with more than one ring buffer. I'm OK
> 
> That's what we already have in fact: kfifo, ftrace, perf, a couple
> of private ones all over.
> 
> I think a couple of private ones could be converted to kfifo
> (I did some of that for my own code) 
> 
> But I don't really see how you can marry the simple kfifo world
> to the highend bells'n'whistles ftrace world. And even in the highend
> world there might be space for multiple specialized ones.
> 
> On the other hand if the highend world had less overhead
> then at least some of the "higher end" kfifo users could start 
> considering to use it.

If Mathieu can pull off the requirements that can handle all of ftrace
and perf in a light weight manner, then great. But if the end result is
still to much for these "private" users, then we should have a
"ring_buffer_lite", and perhaps even base it off of a kfifo itself.

Note, it would be nice to have a single location that (a) ring buffer(s)
reside at. This way if a developer has a need for a ring buffer then
they can have a single location to look for one.

Maybe the ring buffer code should go in lib/ringbuffers/ instead of
kernel/ringbuffer/.

-- Steve


