Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123Ab2EIJaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:30:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35004 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758801Ab2EIJaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:30:07 -0400
Date: Wed, 9 May 2012 11:30:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: joro@8bytes.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/3] irq_remap: fix the UP build failure
Message-ID: <20120509093001.GD8585@gmail.com>
References: <20120508035153.GA30652@gmail.com>
 <1336460934-23592-2-git-send-email-suresh.b.siddha@intel.com>
 <20120508090945.GC27323@gmail.com>
 <1336531035.22618.23.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1336531035.22618.23.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Tue, 2012-05-08 at 11:09 +0200, Ingo Molnar wrote:
> > * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > 
> > > Fix the below UP build failure with CONFIG_IRQ_REMAP enabled.
> > > 
> > >  drivers/iommu/intel_irq_remapping.c:955:19: error: ‘struct irq_data’ has no member named ‘affinity’
> > 
> > hm:
> > 
> > > +++ b/drivers/iommu/intel_irq_remapping.c
> > > +#ifdef CONFIG_SMP
> > > +#endif
> > > +#ifdef CONFIG_SMP
> > > +#endif
> > > +#ifdef CONFIG_SMP
> > > +#endif
> > > +#ifdef CONFIG_SMP
> > > +#endif
> > 
> > Adding this many #ifdefs is a bit sad. Could we not make the UP 
> > side have the (supposedly zero length!) affinity cpumask 
> > instead, or so, and make sure that the SMP functions compile to 
> > something sensible on UP?
> > 
> 
> How about using config_enabled() to clean this up? Something 
> like the appended?
> 
> I first tried config_enabled(SMP) with out closely looking at 
> the macro definition and didn't work. I had to use 
> config_enabled(CONFIG_SMP) to really get this working. So in 
> the appended patch I fixed config_enabled macro to accept 
> config_enabled(SMP). If this all sounds ok, then I can split 
> the appended patch into multiple patches.

Looks a lot cleaner!

Please split out the config_enabled() change into a separate 
patch and Cc: Linus on the resend.

I like your idea of allowing config_enabled(SMP) as well, 
there's no reason to say 'config' twice. It's too easy to get 
this wrong and AFAICS there's no build error if we are using a 
non-existent config flag, right?

Thanks,

	Ingo
