Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098Ab2FDKdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:33:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:40644 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab2FDKdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:33:10 -0400
Date: Mon, 4 Jun 2012 12:32:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Sam Ravnborg <sam@ravnborg.org>, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        yong.zhang0@gmail.com, akpm@linux-foundation.org,
        vatsa@linux.vnet.ibm.com, rjw@sisk.pl, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, nikunj@linux.vnet.ibm.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [PATCH 01/27] smpboot: Provide a generic method to boot secondary
 processors
In-Reply-To: <4FC9424E.9060009@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1206041228330.3086@ionos>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091008.31979.93586.stgit@srivatsabhat.in.ibm.com> <20120601165113.GA18870@merkur.ravnborg.org> <4FC9424E.9060009@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2012, Srivatsa S. Bhat wrote:

> On 06/01/2012 10:21 PM, Sam Ravnborg wrote:
> 
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

This wants to be a prototype w/o the __weak prefix and the #ifndef
magic and the weak default implementation should be in kernel/smpboot.c

> > __What __is __the __purpose __of __all __these __underscaores __used
> > __as __function __prefix? __It __does __not __help __readability.
> 
> > 
> 
> 
> We had used "__" as the function prefix to emphasize that these functions are
> implemented/overriden in the depths of architecture-specific code.
> 
> But now that you mention it, I see that we don't really have something like an
> arch-independent variant without the "__" prefix. So adding the "__" prefix
> might not be really necessary, since there is nothing to distinguish name-wise.
> 
> However, I do want to emphasize that this isn't generic code. So how about
> an "arch_" prefix instead? Something like:
> arch_cpu_pre_starting(), arch_cpu_pre_online() and arch_cpu_post_online()?

Yes, please.

Otherwise, thanks for that work! From the first glance, it's not
colliding much with the changes I have in the pipeline, but I will
have a closer look.

Thanks,

	tglx
