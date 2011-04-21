Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1DUOdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:33:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab1DUOdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:33:32 -0400
Subject: Re: [PATCH v2] intel-iommu: Fix use after release during device
 attach
From: Alex Williamson <alex.williamson@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
        David Woodhouse <David.Woodhouse@intel.com>, kvm <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, Avi Kivity <avi@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <4DB023C7.5070007@siemens.com>
References: <4CCFB84F.6050102@web.de>
	 <201011021531.22886.sheng@linux.intel.com> <4CDFA96D.1060301@web.de>
	 <4D01E677.5070702@siemens.com> <20101210184402.GE4040@sequoia.sous-sol.org>
	 <4D22F9A4.3050807@web.de>  <4DB023C7.5070007@siemens.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 08:28:17 -0600
Message-ID: <1303396097.3050.4.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 14:32 +0200, Jan Kiszka wrote:
> On 2011-01-04 11:42, Jan Kiszka wrote:
> > Am 10.12.2010 19:44, Chris Wright wrote:
> >> * Jan Kiszka (jan.kiszka@siemens.com) wrote:
> >>>>>> --- a/drivers/pci/intel-iommu.c
> >>>>>> +++ b/drivers/pci/intel-iommu.c
> >>>>>> @@ -3627,9 +3627,9 @@ static int intel_iommu_attach_device(struct
> >>>>>> iommu_domain *domain,
> >>>>>>
> >>>>>>  		pte = dmar_domain->pgd;
> >>>>>>  		if (dma_pte_present(pte)) {
> >>>>>> -			free_pgtable_page(dmar_domain->pgd);
> >>>>>>  			dmar_domain->pgd = (struct dma_pte *)
> >>>>>>  				phys_to_virt(dma_pte_addr(pte));
> >>
> >> While here, might as well remove the unnecessary cast.
> >>
> >>>>>> +			free_pgtable_page(pte);
> >>>>>>  		}
> >>>>>>  		dmar_domain->agaw--;
> >>>>>>  	}
> >>>>>
> >>>>> Reviewed-by: Sheng Yang <sheng@linux.intel.com>
> >>
> >> Acked-by: Chris Wright <chrisw@sous-sol.org>
> >>
> >>>>> CC iommu mailing list and David.
> >>>>
> >>>> Ping...
> >>>>
> >>>> I think this fix also qualifies for stable (.35 and .36).
> >>>>
> >>>
> >>> Still not merged?
> >>
> >> David, do you plan to pick this one up?
> >>
> >> thanks,
> >> -chris
> > 
> > Hmm, still no reaction. Trying David's Intel address now...
> > 
> > Jan
> > 
> 
> Walking through my old queues, I came across this one again.
> 
> Given the still lacking reaction from the official maintainer, I'm a
> bit confused about the state of intel-iommu. Is it unmaintained? Should
> this bug fix better be routed through the KVM tree as its only in-tree
> user? Please enlighten me.

I've been wondering the exact same thing.  My last patch took weeks of
prodding, finally went into the maintainer's tree without
acknowledgment, and there's hardly been any activity there to suggest a
pull request for 2.6.39 is going to happen.  David, are you still
interested in maintaining this code?  Thanks,

Alex


