Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab2IESwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:52:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46411 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab2IESwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:52:34 -0400
Date: Wed, 5 Sep 2012 20:52:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, a.p.zijlstra@chello.nl,
        eranian@google.com, mingo@elte.hu, andi@firstfloor.org, avi@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/x86: Disable uncore on virtualized CPU.
Message-ID: <20120905185233.GD16230@one.firstfloor.org>
References: <1345540117-14164-1-git-send-email-zheng.z.yan@intel.com> <20120905063524.GA20710@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905063524.GA20710@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 08:35:24AM +0200, Ingo Molnar wrote:
> 
> * Yan, Zheng <zheng.z.yan@intel.com> wrote:
> 
> > From: "Yan, Zheng" <zheng.z.yan@intel.com>
> > 
> > Initializing uncore PMU on virtualized CPU may hang the kernel.
> > This is because kvm does not emulate the entire hardware. Thers
> > are lots of uncore related MSRs, making kvm enumerate them all
> > is a non-trival task. So just disable uncore on virtualized CPU.
> > 
> > Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> > ---
> >  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > index 0a55710..2f005ba 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > @@ -2898,6 +2898,9 @@ static int __init intel_uncore_init(void)
> >  	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> >  		return -ENODEV;
> >  
> > +	if (cpu_has_hypervisor)
> > +		return -ENODEV;
> > +
> >  	ret = uncore_pci_init();
> >  	if (ret)
> >  		goto fail;
> 
> Cannot the presence of the uncore hardware be detected in a 
> cleaner fashion, via the PCI config space and such?

Probably just by reading the registers and see that they are 0 and 
when writing read back and check.

And the code should not hang when that happens, then this check wouldn't
be needed.

-Andi
