Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835Ab2JWMxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 08:53:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757008Ab2JWMxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 08:53:17 -0400
Date: Tue, 23 Oct 2012 14:53:04 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>, avi@redhat.com
Subject: Re: [PATCH 06/34] perf, kvm: Support the intx/intx_cp modifiers in
 KVM arch perfmon emulation v2
Message-ID: <20121023125304.GA3654@redhat.com>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
 <1350602382-12771-7-git-send-email-andi@firstfloor.org>
 <1350995765.13456.15.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350995765.13456.15.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 02:36:05PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-10-18 at 16:19 -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > This is not arch perfmon, but older CPUs will just ignore it. This makes
> > it possible to do at least some TSX measurements from a KVM guest
> 
> Please, always CC people who wrote the code as well, in this case that's
> Gleb.
> 
Yes, I missed the v2. Thanks Peter.

> > Cc: avi@redhat.com
> > v2: Various fixes to address review feedback
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > ---
> >  arch/x86/kvm/pmu.c |   15 +++++++++++----
> >  1 files changed, 11 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index cfc258a..81c1632 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> 
> > @@ -173,6 +173,11 @@ static void reprogram_counter(struct kvm_pmc *pmc, u32 type,
> >  		.exclude_kernel = exclude_kernel,
> >  		.config = config,
> >  	};
> > +	/* Will be ignored on CPUs that don't support this. */
> > +	if (intx)
> > +		attr.config |= HSW_INTX;
> > +	if (intx_cp)
> > +		attr.config |= HSW_INTX_CHECKPOINTED;
> >  
> >  	attr.sample_period = (-pmc->counter) & pmc_bitmask(pmc);
> >  
> 
> So I forgot how all this worked, but will the KVM emulation not pass
> this straight down to the hardware?
KVM PMU emulation does not talk to HW directly. It creates perf_event to
emulate PMU counter. As far as I see those two will be dropped by
hsw_hw_config() if host HW does not support them.


> 
> Don't we have a problem where we're emulating arch perfmon v1 on AMD
> hardware? On AMD hardware those bits do have meaning.
PMU emulation does not support AMD yet.

--
			Gleb.
