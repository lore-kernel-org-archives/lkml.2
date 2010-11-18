Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab0KRLx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:53:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62373 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab0KRLx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:53:26 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=AvpIYEOr2ZAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=H9Uav1xiZdIB_Mn6Q8sA:9 a=nBEj7iXcaCPTA-UWyF_Ny6hLI_YA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 0/2] tracing: Have trace_printk()s in the events/
 directory
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1290076866.2109.1305.camel@laptop>
References: <20101118035803.453609353@goodmis.org>
	 <1290076866.2109.1305.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 18 Nov 2010 06:53:23 -0500
Message-ID: <1290081203.30543.96.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 11:41 +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-17 at 22:58 -0500, Steven Rostedt wrote:
> > For example, I added a trace_printk() in kernel/sched.c at line 2180
> > and it creates:
> > 
> > # ls /debug/tracing/events/printk/kernel/sched.c/2180/
> > enable  format
> > 
> > The format is the printk format:
> > 
> > # cat /debug/tracing/events/printk/kernel/sched.c/2180/format 
> > "migrate task %s:%d"
> 
> *groan*, so you're creating a tracepoint per instance?
> 
> That's going to be massive pain for perf.. I really don't see the point
> in splitting all that out.

a) The file directory was what was asked about in the referenced email.
b) This is just an example of a way to display it to the user, which
seems to be very intuitive.
c) Perf can implement the details anyway it wants. It can make a single
tracepoint callback and have the enabling of the points as a special
filter.
d) This was just an RFC that Frederic asked if I would do. I thought it
would be a fun challenge and did it. Let it bit rot in hell for all I
care, I wasn't taking it any further anyway.

-- Steve


