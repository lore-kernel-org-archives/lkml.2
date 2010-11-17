Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935400Ab0KQUiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 15:38:46 -0500
Received: from www.tglx.de ([62.245.132.106]:41133 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589Ab0KQUip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 15:38:45 -0500
Date: Wed, 17 Nov 2010 21:37:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Marcus Meissner <meissner@suse.de>, mingo@elte.hu,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/time: Make /proc/timer_list mode 0400
In-Reply-To: <20101117123039.d975aa70.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1011172137040.2900@localhost6.localdomain6>
References: <20101117170822.GW20727@suse.de> <1290014312.2109.1065.camel@laptop> <20101117123039.d975aa70.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010, Andrew Morton wrote:

> On Wed, 17 Nov 2010 18:18:32 +0100
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Wed, 2010-11-17 at 18:08 +0100, Marcus Meissner wrote:
> > > Hi,
> > > 
> > > /proc/timer_list contains kernel addresses, like e.g.:
> > >  #0: <c000000001404158>, tick_sched_timer, S:01, .tick_nohz_restart_sched_tick, swapper/0
> > >  ...
> > > 
> > > Avoid leaking them to user space to make writing kernel exploits a bit harder.
> > > 
> > > (I currently cannot think of a userland tool that uses this, this is
> > > likely pretty much root-only.)
> > 
> > iirc powertop parses this..
> 
> I bet it doesn't look at the kernel address (why was that added in the
> first place, anyway?)
> 
> I'd suggest that the risk of breakage would be much less if we left the
> file permissions alone and arranged for those addresses to be
> 0000000000000000 for non-root readers.

You beat me to it. Having the full information is quite helpful at
times.

Thanks,

	tglx

