Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102Ab2FBPQG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 11:16:06 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:46730 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757909Ab2FBPQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 11:16:03 -0400
Date: Sat, 2 Jun 2012 17:16:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        nikunj@linux.vnet.ibm.com, Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [PATCH 01/27] smpboot: Provide a generic method to boot
	secondary processors
Message-ID: <20120602151602.GB17409@merkur.ravnborg.org>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091008.31979.93586.stgit@srivatsabhat.in.ibm.com> <20120601165322.GB18870@merkur.ravnborg.org> <4FC94518.4010908@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC94518.4010908@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2012 at 04:11:28AM +0530, Srivatsa S. Bhat wrote:
> On 06/01/2012 10:23 PM, Sam Ravnborg wrote:
> 
> >> +
> >> +
> >> +/* Implement the following functions in your architecture, as appropriate. */
> >> +
> >> +/**
> >> + * __cpu_pre_starting()
> >> + *
> >> + * Implement whatever you need to do before the CPU_STARTING notifiers are
> >> + * invoked. Note that the CPU_STARTING callbacks run *on* the cpu that is
> >> + * coming up. So that cpu better be prepared! IOW, implement all the early
> >> + * boot/init code for the cpu here. And do NOT enable interrupts.
> >> + */
> >> +#ifndef __cpu_pre_starting
> >> +void __weak __cpu_pre_starting(void *arg) {}
> >> +#endif
> > 
> > I miss the prototype for this in a header?
> 
> 
> Prototype is not really necessary for this. Hence not added.
There is a simple rule:
1) If a function is declared => not static
2) If function not declared => static

With respect to this simple rule your functions shall be defined as static.
And that would not work.

	Sam
