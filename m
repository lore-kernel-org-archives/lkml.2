Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab1JHAdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 20:33:44 -0400
Received: from peace.netnation.com ([204.174.223.2]:60585 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab1JHAdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 20:33:42 -0400
Date: Fri, 7 Oct 2011 17:33:37 -0700
From: Simon Kirby <sim@hostway.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111008003337.GB22843@hostway.ca>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com> <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca> <1318010515.398.8.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318010515.398.8.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 08:01:55PM +0200, Peter Zijlstra wrote:

> On Fri, 2011-10-07 at 10:48 -0700, Simon Kirby wrote:
> 
> > Yes, they stopped locking up with d670ec13 reverted.
> 
> > > [ 1717.560005]  [<ffffffff8104b8d4>] task_sched_runtime+0x24/0x90
> > > [ 1717.560005]  [<ffffffff8107c924>] thread_group_cputime+0x74/0xb0
> > > [ 1717.560005]  [<ffffffff8107d126>] thread_group_cputimer+0xa6/0xf0
> > > [ 1717.560005]  [<ffffffff8107d198>] cpu_timer_sample_group+0x28/0x90
> > > [ 1717.560005]  [<ffffffff8107d3c3>] set_process_cpu_timer+0x33/0x110
> > > [ 1717.560005]  [<ffffffff8107d4da>] update_rlimit_cpu+0x3a/0x60
> > > [ 1717.560005]  [<ffffffff8106fe9e>] do_prlimit+0xfe/0x1f0
> > > [ 1717.560005]  [<ffffffff8106ffd6>] sys_setrlimit+0x46/0x60
> > > [ 1717.560005]  [<ffffffff816be292>] system_call_fastpath+0x16/0x1b
> 
> OK so that cputimer stuff is horrid and the worst part is that I cannot
> seem to trigger this. You guys must have some weird userspace stuff that
> I simply don't have.

I haven't tried your patch yet, but it might help to mention that on
this particular cluster, we are using CONFIG_TASK_IO_ACCOUNTING under
CONFIG_TASKSTATS, and we have process accounting enabled (w/"accton").
Perhaps that enables some other path that makes it difficult to hit
otherwise.

You can't have clouds without weather reporting, of course. :)

Other than that, it's just a typical shared web environment.

Simon-
