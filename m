Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab1EJIJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:09:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59551 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab1EJIJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:09:31 -0400
Date: Tue, 10 May 2011 10:09:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
Message-ID: <20110510080918.GB27426@elte.hu>
References: <4DC45537.6070609@linux.intel.com>
 <1304713252.25414.2532.camel@gandalf.stny.rr.com>
 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
 <20110507065803.GA23414@elte.hu>
 <1304765110.25414.2564.camel@gandalf.stny.rr.com>
 <20110507144402.GC2859@elte.hu>
 <1304788829.11129.57.camel@frodo>
 <20110507190033.GA11465@elte.hu>
 <1304996847.2969.151.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304996847.2969.151.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > > > PowerTop uses the perf ABI because it's a rather convenient and unified 
> > > > method to get a rich selection of events via the same facility, same 
> > > > ring-buffer, using a system call ABI, etc.
> > > 
> > > It seams that Arjan read the perf kernel code to see how the raw data was 
> > > laid out and read it directly.
> > 
> > Yes, of course - i also have code that uses the syscall directly, it's 
> > easier to code up ad-hoc than to parse some XML-lookalike descriptor from 
> > /debug/tracing/events/.
> 
> So you admit this is a ad-hoc way of doing things. [...]

There's nothing wrong with being able to code and make use of instrumentation 
ad-hoc, using a simple interface.

The *worst* possible thing is to force user-space to use something complex.
So we kept the perf ABI simple.

> [...] Thus a library is a perfect solution. [...]

That's a non sequitor.

> [...] And the event formats are far from XML-look-a-like. You really think 
> this:
> 
> name: sched_switch
> ID: 57
> format:
> 	field:unsigned short common_type;	offset:0;	size:2;
> 	field:unsigned char common_flags;	offset:2;	size:1;
> 	field:unsigned char common_preempt_count;	offset:3;	size:1;
> 	field:int common_pid;	offset:4;	size:4;
> 	field:int common_lock_depth;	offset:8;	size:4;
> 
> 	field:char prev_comm[TASK_COMM_LEN];	offset:12;	size:16;
> 	field:pid_t prev_pid;	offset:28;	size:4;
> 	field:int prev_prio;	offset:32;	size:4;
> 	field:long prev_state;	offset:40;	size:8;
> 	field:char next_comm[TASK_COMM_LEN];	offset:48;	size:16;
> 	field:pid_t next_pid;	offset:64;	size:4;
> 	field:int next_prio;	offset:68;	size:4;
> 
> Is equivalent to this:
> 
> <?xml version="1.0" encoding="UTF-8"?>
> <KernelShark><CaptureSettings><Events><CaptureType>Events</CaptureType><System>sched</System></Events><Plugin>function_graph</Plugin><File>/tmp/trace.dat</File></CaptureSettings></KernelShark>

I did not say that it's equivalent, i said it's XML look-alike.

Steve, we even joked about that, that if we continue like this we'll end up 
with an XML parser ... I requested several changes to the description format so 
that it becomes more human readable.

Thanks,

	Ingo
