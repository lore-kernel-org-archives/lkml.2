Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab1DZUdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:33:46 -0400
Received: from jaguar.mail.utk.edu ([160.36.0.84]:37631 "EHLO
	jaguar.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab1DZUdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:33:44 -0400
Date: Tue, 26 Apr 2011 16:33:12 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
In-Reply-To: <1303809958.20212.219.camel@twins>
Message-ID: <alpine.DEB.2.00.1104261617320.32482@cl320.eecs.utk.edu>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>  <1303407662-15564-2-git-send-email-acme@infradead.org>  <20110422063429.GA16643@elte.hu> <20110422080604.GA22611@elte.hu>  <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu>
 <1303809958.20212.219.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011, Peter Zijlstra wrote:

> > That's why people use libpfm4.  or PAPI.  And they do.
> 
> And how is typing in hex numbers different from typing in model specific
> event names? 

Reall... quick, tell me what event 0x53cf28 corresponds to on a core2.

Now if I said L2_IFETCH:BOTH_CORES you know several things about what it 
is.

Plus, you can do a quick search in the Intel Arch manual and find more 
info.  With the hex value you have to do some shifting and masking by hand 
before looking up.

An even worse problem:

Quick... tell me what actual hardware event L1-dcache-loads corresponds
to on an L2.  Can you tell without digging through kernel source code?

Does that event include prefetches?  Does it include speculative events?
Does it count page walks?  Does it overcount by an amount equal to the 
number of hardware interrupts?   If I use the equivelent event on an 
AMD64, will all the same hold?

> PAPI actually has 'generalized' events, but I guess you're going to tell
> me nobody uses those since they're not useful.

Of course people use them.  But we don't _force_ people to use them.  We 
don't disable access to raw events.  Although alarmingly it seems like the 
kernel is going to start to, possibly meaning even our users can't use our
'generalized' events if for example they incorporate OFFCORE_RESPONSE.

Another issue:  if a problem is found with one of the PAPI events, they 
can update and recompile and run out of their own account at will.

If there's a problem with a kernel generalized events, you have to 
reinstall a kernel.  Something many users can't do.  For example, your 
Nehalem cache fixes will be in 2.6.39.  How long until that appears in a 
stock distro?  How long until that appears in an RHEL release?

> > All the world is not perf.
> 
> I know, all the world is interested in investing tons of time learning
> about their one architecture and extract the last few percent of
> performance.

There are people out there who have been using perf counters on UNIX/Linux 
machines for decades.  They know what events they want to measure.  They 
are not interested in having the kernel tell them they can't do it.

> I looks like you're all so stuck in your HPC/lowlevel way of things
> you're not even realizing there's much more to be gained by providing
> easy and useful tools to the general public, stuff that works similarly
> across architectures.

We're not saying people can't use perf.  Who knows, maybe PAPI will go 
away becayse perf is so good.  It's just silly to block out access to RAW 
events on the argument that "it's too hard".  Again, are we Microsoft 
here?

> Very constructive attitude, instead of helping you simply subvert and
> route around, thanks man! 

I spent a lot of time trying to fix P4 support back in the 2.6.35 days.
I only have so much time to spend on this stuff. 

When people complain about p4 support, I direct them to Cyrill et al.  I 
can't force them to become kernel developers.  Usually they want immediate 
results, which they can get with perfctr.

People want offcore response.  People want uncore access.  People want raw 
event access.  I can tell them "send a patch to the kernel, it'll
languish in obscurity for years and maybe in 2.6.4x you'll see it".  Or 
they can have support today with an outside patch.  Which do you think 
they choose?

> And why is that? is that the lack of userspace rdpmc? That should be
> possible with perf, powerpc actually does that already. Various people
> mentioned wanting to make this work on x86 but I've yet to see a patch.

We at the PAPI project welcome any patches you'd care to contribute to our 
project too, to make things better.  It goes both ways you know.

Vince
