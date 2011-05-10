Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab1EJEo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 00:44:59 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:45616 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870Ab1EJEo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 00:44:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AosEAG3CyE15LBzagWdsb2JhbACmAhUBARYmJcVODoYABJ5d
Date: Tue, 10 May 2011 14:44:38 +1000
From: Dave Chinner <david@fromorbit.com>
To: Steven Rostedt <rostedt@goodmis.org>
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
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
Message-ID: <20110510044438.GB19446@dastard>
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
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 11:07:27PM -0400, Steven Rostedt wrote:
> >  Nor do you really seem to see the problem that changing tracepoints 
> > brings with itself.
> 
> I am not for changing tracepoints on a whim. But I would like
> tracepoints to change as the kernel design changes. The reason
> tracepoints have currently been stable is that kernel design changes do
> not happen often. But they do happen, and I foresee that in the future,
> the kernel will have a large number of "legacy tracepoints", and we will
> be stuck maintaining them forever.
> 
> What happens if someone designs a tool that analyzes the XFS
> filesystem's 200+ tracepoints? Will all those tracepoints now become
> ABI?

That's crazy talk.

XFS tracepoints are _not ever_ guaranteed to be consistent from one
kernel to another - they are highly dependent on the implementation
of the code, and as such will change *without warning*. This has
been the case for the XFS event subsystem since back in the days of
Irix (yes, that's where most of the events were originally
implemented). The fact that they are now exported via TRACE_EVENT()
(so no kernel debugger is needed) does not change the fact the
information is really for developer use only and as such are
volatile....

So, if someone wants to write an application that parses the XFS
tracepoints directly, then they have to live with the fact that
tracepoints will come and go and change size and shape all the
time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
