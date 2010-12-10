Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab0LJIgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 03:36:36 -0500
Received: from thoth.sbs.de ([192.35.17.2]:20446 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab0LJIgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 03:36:35 -0500
Message-ID: <4D01E677.5070702@siemens.com>
Date: Fri, 10 Dec 2010 09:36:07 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH] intel-iommu: Fix use after release during device attach
References: <4CCFB84F.6050102@web.de> <201011021531.22886.sheng@linux.intel.com> <4CDFA96D.1060301@web.de>
In-Reply-To: <4CDFA96D.1060301@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.11.2010 10:18, Jan Kiszka wrote:
> Am 02.11.2010 08:31, Sheng Yang wrote:
>> On Tuesday 02 November 2010 15:05:51 Jan Kiszka wrote:
>>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>>
>>> Obtail the new pgd pointer before releasing the page containing this
>>> value.
>>>
>>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>>> ---
>>>
>>> Who is taking care of this? The kvm tree?
>>>
>>>  drivers/pci/intel-iommu.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
>>> index 4789f8e..35463dd 100644
>>> --- a/drivers/pci/intel-iommu.c
>>> +++ b/drivers/pci/intel-iommu.c
>>> @@ -3627,9 +3627,9 @@ static int intel_iommu_attach_device(struct
>>> iommu_domain *domain,
>>>
>>>  		pte = dmar_domain->pgd;
>>>  		if (dma_pte_present(pte)) {
>>> -			free_pgtable_page(dmar_domain->pgd);
>>>  			dmar_domain->pgd = (struct dma_pte *)
>>>  				phys_to_virt(dma_pte_addr(pte));
>>> +			free_pgtable_page(pte);
>>>  		}
>>>  		dmar_domain->agaw--;
>>>  	}
>>
>> Reviewed-by: Sheng Yang <sheng@linux.intel.com>
>>
>> CC iommu mailing list and David.
> 
> Ping...
> 
> I think this fix also qualifies for stable (.35 and .36).
> 

Still not merged?

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
