Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab2GYIrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 04:47:53 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56969 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932748Ab2GYIrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 04:47:52 -0400
Date: Wed, 25 Jul 2012 09:47:31 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [08/36] AArch64: Kernel booting and initialisation
Message-ID: <20120725084731.GB11389@arm.com>
References: <1341608777-12982-9-git-send-email-catalin.marinas@arm.com>
 <500EFAA4.40600@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500EFAA4.40600@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 08:42:28PM +0100, Christopher Covington wrote:
> On 01/-10/-28163 02:59 PM, Catalin Marinas wrote:
> > +- Architected timers
> > +  CNTFRQ must be programmed with the timer frequency.
> > +  If entering the kernel at EL1, CNTHCTL_EL2 must have EL1PCTEN (bit 0)
> > +  set where available.
> 
> After Marc Zyngier's virtual timer patches come in, will the latter
> requirement only be strictly necessary for kernels wanting to do
> virtualization?

A kernel is usually entered at EL1 (rather than EL2) if it is a guest.
In this case, the EL1PCTEN bit should have been enabled from the higher
level to give access to the physical counter.

We assume that the generic timers are present on any AArch64 platform.

> > +/*
> > + * cpu_init - initialise one CPU.
> > + *
> > + * cpu_init sets up the per-CPU stacks.
> > + */
> > +void cpu_init(void)
> > +{
> > +}
> 
> It looks like the comment above is a holdover from the 32-bit code and
> no longer applies. Perhaps you could replace it with a comment on where
> stack pointer initialization is actually handled. Searching briefly, it
> looks like it's done in __mmap_switched and __secondary_switched.

I removed this function entirely. On AArch64 we only have a stack per
exception level, so no need for additional initialisation.

Thanks.

-- 
Catalin
