Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422740Ab2LGQYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 11:24:15 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56263 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422660Ab2LGQYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 11:24:14 -0500
Date: Fri, 7 Dec 2012 16:23:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are
	synchronised across all cpus
Message-ID: <20121207162346.GW14363@n2100.arm.linux.org.uk>
References: <1354817466.30905.13.camel@linaro1.home> <1354821581.17101.17.camel@gandalf.local.home> <1354872138.3176.15.camel@computer5.home> <1354888985.17101.41.camel@gandalf.local.home> <1354892111.13000.50.camel@linaro1.home> <1354894134.17101.44.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354894134.17101.44.camel@gandalf.local.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 10:28:54AM -0500, Steven Rostedt wrote:
> On Fri, 2012-12-07 at 14:55 +0000, Jon Medhurst (Tixy) wrote:
> >  
> > > But also realize that function tracing is special :-) We have no cases
> > > like this. The instruction being replaced is a call to mcount. In fact,
> > > we replace it at boot with a nop. And this method only replaces that nop
> > > into a call to function tracer, or replaces the call to function tracer
> > > back to a nop. Always at the start of the function, and never involved
> > > with conditionals. This limitation that function tracing imposes on what
> > > we replace makes things a bit more sane in how we replace it.
> > 
> > Then perhaps the method you suggest will work on ARM :-). However, that
> > is not something I personally propose to implement at this time. (I was
> > doing my good Samaritan act by trying to fix the crashes which another
> > team was getting when trying to use ftrace.)
> > 
> 
> I'm not NACKing your previous patch, I was just suggesting to bring ARM
> up to the future :-)
> 
> I have no problems with the patch, but I just want to put it out there
> that there's better ways. It's part of the remove stomp_machine()
> crusade ;-)

That's fine if there are better ways.  If your view is that this would
bring things "up to the future" consider this: what you suggest is possible
with the standard ARM 32-bit instruction set.  With the more modern Thumb
instruction set, because we now effectively have prefixes, where those
prefixes control the execution of the following instructions, what you
suggest becomes no longer possible.

So, it's not a question of bringing stuff up to the future at all... you
can call it a design regression of you will, but you're really making
demands about how CPUs work which are outside of your remit.

Think of this a bit like you changing the opcodes immediately following a
'LOCK' prefix on x86.  I suspect divorsing the following opcodes from its
prefix would be very bad for the instructions atomicity.
