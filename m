Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422901Ab2LGQsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 11:48:46 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56287 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422686Ab2LGQso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 11:48:44 -0500
Date: Fri, 7 Dec 2012 16:45:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are
	synchronised across all cpus
Message-ID: <20121207164530.GX14363@n2100.arm.linux.org.uk>
References: <1354817466.30905.13.camel@linaro1.home> <1354821581.17101.17.camel@gandalf.local.home> <1354872138.3176.15.camel@computer5.home> <1354888985.17101.41.camel@gandalf.local.home> <1354892111.13000.50.camel@linaro1.home> <1354894134.17101.44.camel@gandalf.local.home> <20121207162346.GW14363@n2100.arm.linux.org.uk> <1354898200.17101.50.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354898200.17101.50.camel@gandalf.local.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 11:36:40AM -0500, Steven Rostedt wrote:
> On Fri, 2012-12-07 at 16:23 +0000, Russell King - ARM Linux wrote:
> 
> > That's fine if there are better ways.  If your view is that this would
> > bring things "up to the future" consider this: what you suggest is possible
> > with the standard ARM 32-bit instruction set.  With the more modern Thumb
> > instruction set, because we now effectively have prefixes, where those
> > prefixes control the execution of the following instructions, what you
> > suggest becomes no longer possible.
> > 
> > So, it's not a question of bringing stuff up to the future at all... you
> > can call it a design regression of you will, but you're really making
> > demands about how CPUs work which are outside of your remit.
> > 
> > Think of this a bit like you changing the opcodes immediately following a
> > 'LOCK' prefix on x86.  I suspect divorsing the following opcodes from its
> > prefix would be very bad for the instructions atomicity.
> 
> But what about the limitations that the function tracer imposes on the
> code that gets modified by stop_machine()?
> 
> 1) the original code is simply a call to mcount
> 
> 2) on boot up, that call gets converted into a nop
> 
> 3) the code that gets changed will only be converting a nop to a call
> into the function tracer, and back again.
> 
> IOW, it's a very limited subset of the ARM assembly that gets touched.
> I'm not sure what the op codes are for the above, but I can imagine they
> don't impose the prefixes as you described.
> 
> If that's the case, is it still possible to change to the breakpoint
> method?

I have no idea; I've no idea how ftrace works on ARM.  That's something
other people use and deal with.  Last (and only) time I used the built-in
kernel tracing facilities I ended up giving up with it and going back to
using my sched-clock+record+printk based approaches instead on account
of the kernels built-in tracing being far too heavy.
