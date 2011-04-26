Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab1DZJ0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:26:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:49892 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1DZJ0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:26:20 -0400
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
	 <1303407662-15564-2-git-send-email-acme@infradead.org>
	 <20110422063429.GA16643@elte.hu> <20110422080604.GA22611@elte.hu>
	 <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Apr 2011 11:25:58 +0200
Message-ID: <1303809958.20212.219.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 13:12 -0400, Vince Weaver wrote:
> On Fri, 22 Apr 2011, Ingo Molnar wrote:
> 
> > But this kind of usability is absolutely unacceptable - users should not
> > be expected to type in magic, CPU and model specific incantations to get
> > access to useful hardware functionality.
> 
> That's why people use libpfm4.  or PAPI.  And they do.

And how is typing in hex numbers different from typing in model specific
event names? All the same to me, you still need to understand your micro
architecture very thoroughly and read the SDMs.

PAPI actually has 'generalized' events, but I guess you're going to tell
me nobody uses those since they're not useful.

> Current PAPI snapshots support offcore response on recent git kernels.
> With full names, no hex values, thanks to libpfm4.
> 
> All the world is not perf.

I know, all the world is interested in investing tons of time learning
about their one architecture and extract the last few percent of
performance.

And that is fine for those few people who can afford it, but generally
optimizing for a single specific platform isn't cost effective.

I looks like you're all so stuck in your HPC/lowlevel way of things
you're not even realizing there's much more to be gained by providing
easy and useful tools to the general public, stuff that works similarly
across architectures.

> > The proper solution is to expose useful offcore functionality via
> > generalized events - that way users do not have to care which specific
> > CPU model they are using, they can use the conceptual event and not some
> > model specific quirky hexa number.
> 
> No no no no.
> 
> Blocking access to raw events is the wrong idea.  If anything, the whole 
> "generic events" thing in the kernel should be ditched.  Wrong events are 
> used at times (see AMD branch events a few releases back, now Nehalem 
> cache events).  This all belongs in userspace, as was pointed out at the 
> start.  The kernel has no business telling users which perf events are 
> interesting, or limiting them!  What is this, windows?

The kernel has no place scheduling pmcs either I expect, or scheduling
tasks for that matter.

We all know you don't believe in upgrading kernels or in kernels very
much at all.

> If you do block access to any raw events, we're going to have to start 
> recommending people ditch perf_events and start patching the kernel with 
> perfctr again.  We already do for P4/netburst users, as Pentium 4 support 
> is currently hosed due to NMI event conflicts.

Very constructive attitude, instead of helping you simply subvert and
route around, thanks man! 

You could of course a) simply disable the NMI watchdog, or b) improve
the space-heater (aka. P4) PMU implementation to use alternative
encodings -- from what I understood the problem with P4 is that there's
multiple ways to encode the same event and currently if you take one it
doesn't try others.

> Also with perfctr it's much easier to get low-latency access to the 
> counters.  See:
>   http://web.eecs.utk.edu/~vweaver1/projects/papi-cost/

And why is that? is that the lack of userspace rdpmc? That should be
possible with perf, powerpc actually does that already. Various people
mentioned wanting to make this work on x86 but I've yet to see a patch.
