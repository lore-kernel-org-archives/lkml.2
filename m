Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1ATLho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:37:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:55100 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab1ATLhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:37:42 -0500
Subject: Re: [PATCH 1/2] lockdep: move early boot local IRQ enable/disable
 status to init/main.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20110120112606.GF6036@htj.dyndns.org>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
	 <20110119120200.GA1057@elte.hu> <20110120110635.GB6036@htj.dyndns.org>
	 <20110120111149.GD6036@htj.dyndns.org> <1295522631.28776.155.camel@laptop>
	 <20110120112606.GF6036@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 20 Jan 2011 12:38:12 +0100
Message-ID: <1295523492.28776.165.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 12:26 +0100, Tejun Heo wrote:
> On Thu, Jan 20, 2011 at 12:23:51PM +0100, Peter Zijlstra wrote:
> > On Thu, 2011-01-20 at 12:11 +0100, Tejun Heo wrote:
> > > Hello, guys.
> > > 
> > > These two patches remove both warnings.  The first warning was
> > > completely spurious.  The second lockdep one was triggered by
> > > on_each_cpu() enabling local IRQ too early.
> > > 
> > > I don't think percpu allocator itself malfunctioned.  There was no
> > > allocation failure.  It whines when percpu allocation fails but didn't
> > > in the log.  Other than calling vfree() early triggering the above
> > > condition, it worked okay.
> > > 
> > > So, it's either the early enabling of local IRQ by on_each_cpu()
> > > breaking something in the IRQ subsystem or something different.  Ingo,
> > > can you please see whether these two patches cure the panic too?
> > 
> > Why not use something like: system_state != SYSTEM_RUNNING ?
> 
> Cuz, it's finer grained than that.  We can add a SYSTEM_* flag but I
> wasn't sure whether that would be just creating more noise.  If we try
> to consolidate these things, we probably should consider
> oops_in_progress too.  It probably is a good idea but let's first fix
> the problem at hand.

Right, no problem with that, I was just wondering why you'd add an extra
variable instead of using the system states.
