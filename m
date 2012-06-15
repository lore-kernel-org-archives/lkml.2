Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086Ab2FOEWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 00:22:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:35273 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab2FOEWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 00:22:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165921981"
Date: Fri, 15 Jun 2012 12:22:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
Message-ID: <20120615042233.GA10973@localhost>
References: <1339649173.13377.191.camel@gandalf.stny.rr.com>
 <20120614045930.GA10508@kroah.com>
 <1339671715.13377.209.camel@gandalf.stny.rr.com>
 <20120614154153.GD17140@kroah.com>
 <1339693625.13377.242.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339693625.13377.242.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I actually would like to make these more compact. As all my test box
> consoles go through serial ports, just booting through this takes more
> time the the compile itself.

The tests took 23 seconds boot time on one kernel:

        [    0.152934] Testing tracer nop: PASSED
        ...1577 lines total...
        [   23.206550] Testing kprobe tracing: OK

And 135 seconds in another bloated kernel:

        [  115.396441] Testing event 9p_client_req: OK
        ...2545 lines total...
        [  240.268783] Testing kprobe tracing: OK

I'd appreciate if the boot time can be reduced. Because I'm doing
kernel boot tests for *every single* commits.

It may look insane amount of work, but it's still manageable: with 10
kvm instances each take 1 minute to boot test a kernel, I can boot
test 60*24*10=14400 kernels in one day. That's a rather big number.
That allows me to run more cpu/vm/io stress tests for each kernel :-)

Thanks,
Fengguang
