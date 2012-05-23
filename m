Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562Ab2EWPuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:50:12 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36326 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab2EWPuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:50:09 -0400
Date: Wed, 23 May 2012 17:50:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Chen <hi3766691@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
Message-ID: <20120523155003.GA8202@gmail.com>
References: <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
 <1337086834.27020.162.camel@laptop>
 <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
 <1337096141.27694.82.camel@twins>
 <1337193010.27694.146.camel@twins>
 <CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
 <1337468148.573.139.camel@twins>
 <CANQmPXhN92i9E8HqxE7pqz=kOwtn5Mz0crW37H6qs+XD420Yuw@mail.gmail.com>
 <20120523150359.GB26974@gmail.com>
 <1337787838.1734.15.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337787838.1734.15.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> On Wed, 2012-05-23 at 17:03 +0200, Ingo Molnar wrote:
> > * Chen <hi3766691@gmail.com> wrote:
> > 
> > > Still you are just trying to said that your code is not bloated?
> > > Up to over 500K for a cpu scheduler. Laughing
> > 
> > Where did you get that 500K from? You are off from the truth 
> > almost by an order of magnitude.
> > 
> > Here's the scheduler size on Linus's latest tree, on 64-bit 
> > defconfig's:
> > 
> >  $ size kernel/sched/built-in.o 
> >    text	   data	    bss	    dec	    hex	filename
> >   83611	  10404	   2524	  96539	  1791b	kernel/sched/built-in.o
> > 
> > That's SMP+NUMA, i.e. everything included.
> > 
> > The !NUMA !SMP UP scheduler, if you are on a size starved 
> > ultra-embedded device, is even smaller, just 22K:
> > 
> >  $ size kernel/sched/built-in.o 
> >    text	   data	    bss	    dec	    hex	filename
> >   19882	   2218	    148	  22248	   56e8	kernel/sched/built-in.o
> 
> Here's an allyesconfig x86-32

allyesconfig includes a whole lot of debugging code so it's a 
pretty meaningless size test.

> $ size kernel/sched/built-in.o
>    text	   data	    bss	    dec	    hex	filename
>  213892	  10856	  65832	 290580	  46f14	kernel/sched/built-in.o
> 
> But that's not the only sched related code.
> 
> In a 1000 cpu config, there also an extra 500+ bytes per cpu
> in printk (I don't think that's particularly important btw)

A 1000 cpu piece of hardware will have a terabyte of RAM or 
more. 0.5K per CPU is reasonable.

> kernel/printk.c adds:
> 
> static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
> 
> Maybe #ifdefing this when !CONFIG_PRINTK would reduce size
> a little in a few cases.  I've attached a trivial suggested patch.

That might make sense for the ultra-embedded.

Still 500K is an obviously nonsensical number.

Thanks,

	Ingo
