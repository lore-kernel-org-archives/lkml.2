Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab1EJFkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 01:40:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56584 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab1EJFkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 01:40:00 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=UZYI7n2t75YA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=InRpvulfD1FCqfm_8OIA:9 a=8a69WQ0EBP5kCqAW36sA:7 a=QEXdDO2ut3YA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20110510044438.GB19446@dastard>
References: <4DC45537.6070609@linux.intel.com>
	 <1304713252.25414.2532.camel@gandalf.stny.rr.com>
	 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
	 <20110507065803.GA23414@elte.hu>
	 <1304765110.25414.2564.camel@gandalf.stny.rr.com>
	 <20110507144402.GC2859@elte.hu> <1304788829.11129.57.camel@frodo>
	 <20110507190033.GA11465@elte.hu> <1304996847.2969.151.camel@frodo>
	 <20110510044438.GB19446@dastard>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 01:39:50 -0400
Message-ID: <1305005990.2969.158.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 14:44 +1000, Dave Chinner wrote:
> On Mon, May 09, 2011 at 11:07:27PM -0400, Steven Rostedt wrote:
> > What happens if someone designs a tool that analyzes the XFS
> > filesystem's 200+ tracepoints? Will all those tracepoints now become
> > ABI?
> 
> That's crazy talk.

Right!

> 
> XFS tracepoints are _not ever_ guaranteed to be consistent from one
> kernel to another - they are highly dependent on the implementation
> of the code, and as such will change *without warning*. This has
> been the case for the XFS event subsystem since back in the days of
> Irix (yes, that's where most of the events were originally
> implemented). The fact that they are now exported via TRACE_EVENT()
> (so no kernel debugger is needed) does not change the fact the
> information is really for developer use only and as such are
> volatile....

But what makes these tracepoints any different from any other
tracepoint? Like power manament.

> 
> So, if someone wants to write an application that parses the XFS
> tracepoints directly, then they have to live with the fact that
> tracepoints will come and go and change size and shape all the
> time.

I totally agree. But that is our "wish" and may not reflect reality. The
whole point of this thread is if the kernel exports something to
userspace (in a released kernel), and userspace tools start to depend on
that data, the "reality" is that data just became an ABI, and Linus will
revert any changes that breaks that tool.

This is the precedence that I want to avoid. Yes, this may be "crazy
talk", but the possibility of it happening exists. In this case, I
rather be crazy than right.

-- Steve


