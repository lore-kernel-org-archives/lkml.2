Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab2FPG7P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 02:59:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52432 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab2FPG7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 02:59:14 -0400
Date: Sat, 16 Jun 2012 08:59:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
Message-ID: <20120616065903.GA24594@gmail.com>
References: <1339649173.13377.191.camel@gandalf.stny.rr.com>
 <20120614045930.GA10508@kroah.com>
 <1339671715.13377.209.camel@gandalf.stny.rr.com>
 <20120614154153.GD17140@kroah.com>
 <1339693625.13377.242.camel@gandalf.stny.rr.com>
 <20120615042233.GA10973@localhost>
 <20120615043017.GA9587@kroah.com>
 <20120615120430.GB23681@gmail.com>
 <20120615231318.GD8205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615231318.GD8205@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Fri, Jun 15, 2012 at 02:04:30PM +0200, Ingo Molnar wrote:
> > 
> > * Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > > On Fri, Jun 15, 2012 at 12:22:33PM +0800, Fengguang Wu wrote:
> > > > > I actually would like to make these more compact. As all my test box
> > > > > consoles go through serial ports, just booting through this takes more
> > > > > time the the compile itself.
> > > > 
> > > > The tests took 23 seconds boot time on one kernel:
> > > > 
> > > >         [    0.152934] Testing tracer nop: PASSED
> > > >         ...1577 lines total...
> > > >         [   23.206550] Testing kprobe tracing: OK
> > > > 
> > > > And 135 seconds in another bloated kernel:
> > > > 
> > > >         [  115.396441] Testing event 9p_client_req: OK
> > > >         ...2545 lines total...
> > > >         [  240.268783] Testing kprobe tracing: OK
> > > > 
> > > > I'd appreciate if the boot time can be reduced. Because I'm doing
> > > > kernel boot tests for *every single* commits.
> > > > 
> > > > It may look insane amount of work, but it's still manageable: with 10
> > > > kvm instances each take 1 minute to boot test a kernel, I can boot
> > > > test 60*24*10=14400 kernels in one day. That's a rather big number.
> > > > That allows me to run more cpu/vm/io stress tests for each kernel :-)
> > > 
> > > Do you really want to enable those tests for your test 
> > > kernels?  Can they fail if we mess up other parts of the 
> > > kernel, or do they only test the tracing portions?
> > 
> > These printk's are useful, are used for a specific (albeit 
> > limited) purpose and were and continue to be useful in that 
> > role.
> > 
> > The changes Steve bisected to broke this use of printk().
> 
> And note, fixed others :)

Sorry, the "we fix some bugs and introduce others" stance is not 
a valid response to a regression. Either fix *all* regressions 
or revert the original change. Simple and robust policy, isn't 
it?

> > Please apply Steve's fix, fix it yourself or revert the 
> > changes that regressed printk().
> 
> I thought Steve's patch was just a RFC thing, is it really 
> something that everyone wants to see applied?

You mean the adding of an API to flush buffered output when 
that's the desired outcome? Why the heck should we *not* want 
that? Either I'm the weird one or you are being difficult ;-)

Thanks,

	Ingo
