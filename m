Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178Ab2FOEh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 00:37:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:32431 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab2FOEh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 00:37:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165925715"
Date: Fri, 15 Jun 2012 12:37:53 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
Message-ID: <20120615043753.GA11155@localhost>
References: <1339649173.13377.191.camel@gandalf.stny.rr.com>
 <20120614045930.GA10508@kroah.com>
 <1339671715.13377.209.camel@gandalf.stny.rr.com>
 <20120614154153.GD17140@kroah.com>
 <1339693625.13377.242.camel@gandalf.stny.rr.com>
 <20120615042233.GA10973@localhost>
 <20120615043017.GA9587@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615043017.GA9587@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 09:30:17PM -0700, Greg Kroah-Hartman wrote:
> On Fri, Jun 15, 2012 at 12:22:33PM +0800, Fengguang Wu wrote:
> > > I actually would like to make these more compact. As all my test box
> > > consoles go through serial ports, just booting through this takes more
> > > time the the compile itself.
> > 
> > The tests took 23 seconds boot time on one kernel:
> > 
> >         [    0.152934] Testing tracer nop: PASSED
> >         ...1577 lines total...
> >         [   23.206550] Testing kprobe tracing: OK
> > 
> > And 135 seconds in another bloated kernel:
> > 
> >         [  115.396441] Testing event 9p_client_req: OK
> >         ...2545 lines total...
> >         [  240.268783] Testing kprobe tracing: OK
> > 
> > I'd appreciate if the boot time can be reduced. Because I'm doing
> > kernel boot tests for *every single* commits.
> > 
> > It may look insane amount of work, but it's still manageable: with 10
> > kvm instances each take 1 minute to boot test a kernel, I can boot
> > test 60*24*10=14400 kernels in one day. That's a rather big number.
> > That allows me to run more cpu/vm/io stress tests for each kernel :-)
> 
> Do you really want to enable those tests for your test kernels?  Can
> they fail if we mess up other parts of the kernel, or do they only test
> the tracing portions?

Good question. If the tests are only relevant to the tracing system,
it's better to enable them only when testing the tracing commits. Just
like I won't run ext4 tests for an XFS commit.

Thanks,
Fengguang
