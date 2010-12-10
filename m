Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab0LJSoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 13:44:37 -0500
Received: from sous-sol.org ([216.99.217.87]:44523 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752114Ab0LJSog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 13:44:36 -0500
Date: Fri, 10 Dec 2010 10:44:02 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Sheng Yang <sheng@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] intel-iommu: Fix use after release during device attach
Message-ID: <20101210184402.GE4040@sequoia.sous-sol.org>
References: <4CCFB84F.6050102@web.de>
 <201011021531.22886.sheng@linux.intel.com>
 <4CDFA96D.1060301@web.de>
 <4D01E677.5070702@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D01E677.5070702@siemens.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jan Kiszka (jan.kiszka@siemens.com) wrote:
> >>> --- a/drivers/pci/intel-iommu.c
> >>> +++ b/drivers/pci/intel-iommu.c
> >>> @@ -3627,9 +3627,9 @@ static int intel_iommu_attach_device(struct
> >>> iommu_domain *domain,
> >>>
> >>>  		pte = dmar_domain->pgd;
> >>>  		if (dma_pte_present(pte)) {
> >>> -			free_pgtable_page(dmar_domain->pgd);
> >>>  			dmar_domain->pgd = (struct dma_pte *)
> >>>  				phys_to_virt(dma_pte_addr(pte));

While here, might as well remove the unnecessary cast.

> >>> +			free_pgtable_page(pte);
> >>>  		}
> >>>  		dmar_domain->agaw--;
> >>>  	}
> >>
> >> Reviewed-by: Sheng Yang <sheng@linux.intel.com>

Acked-by: Chris Wright <chrisw@sous-sol.org>

> >> CC iommu mailing list and David.
> > 
> > Ping...
> > 
> > I think this fix also qualifies for stable (.35 and .36).
> > 
> 
> Still not merged?

David, do you plan to pick this one up?

thanks,
-chris
