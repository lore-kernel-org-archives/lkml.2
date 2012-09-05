Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab2IEJIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:08:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64623 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab2IEJIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:08:44 -0400
Date: Wed, 5 Sep 2012 11:08:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, eranian@google.com, mingo@elte.hu,
        andi@firstfloor.org, avi@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/x86: Disable uncore on virtualized CPU.
Message-ID: <20120905090839.GA31992@gmail.com>
References: <1345540117-14164-1-git-send-email-zheng.z.yan@intel.com>
 <20120905063524.GA20710@gmail.com>
 <1346834836.2600.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346834836.2600.3.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2012-09-05 at 08:35 +0200, Ingo Molnar wrote:
> > * Yan, Zheng <zheng.z.yan@intel.com> wrote:
> > 
> > > From: "Yan, Zheng" <zheng.z.yan@intel.com>
> > > 
> > > Initializing uncore PMU on virtualized CPU may hang the kernel.
> > > This is because kvm does not emulate the entire hardware. Thers
> > > are lots of uncore related MSRs, making kvm enumerate them all
> > > is a non-trival task. So just disable uncore on virtualized CPU.
> > > 
> > > Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> > > ---
> > >  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > > index 0a55710..2f005ba 100644
> > > --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > > +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > > @@ -2898,6 +2898,9 @@ static int __init intel_uncore_init(void)
> > >  	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> > >  		return -ENODEV;
> > >  
> > > +	if (cpu_has_hypervisor)
> > > +		return -ENODEV;
> > > +
> > >  	ret = uncore_pci_init();
> > >  	if (ret)
> > >  		goto fail;
> > 
> > Cannot the presence of the uncore hardware be detected in a 
> > cleaner fashion, via the PCI config space and such?
> 
> No, part of the uncore PMUs are in MSR space and aren't 
> discoverable. CPUID model checks + hard assumptions of 
> presence are all that we are left with.
>
> Now Avi suggested we teach KVM about these MSRs and then 
> modify the uncore driver to test if the MSRs actually work -- 
> as in retain values written to them and aren't always 0.
> 
> That's a larger patch though, partly because enumerating the 
> gazillion MSRs consumed by the various uncore PMUs is a 
> tedious job, and we can always do this later.
> 
> This patch is a minimal patch to at least make things 'work' 
> for now.

Ok, no objections.

Thanks,

	Ingo
