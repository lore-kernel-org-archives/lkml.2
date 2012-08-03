Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab2HCWI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 18:08:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65003 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2HCWIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 18:08:14 -0400
Message-ID: <501C4BCA.1080804@gmail.com>
Date: Fri, 03 Aug 2012 16:08:10 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: oops in pci_acs_path_enabled
References: <501C0CDF.7010804@gmail.com> <1344025273.8003.40.camel@ul30vt>  <501C3EB7.4000900@gmail.com> <1344030733.8003.43.camel@ul30vt>
In-Reply-To: <1344030733.8003.43.camel@ul30vt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/3/12 3:52 PM, Alex Williamson wrote:
> Is this the chunk that's causing the oops?

Yes. And taking it out fixes passthrough as well.

David


>
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 7469b53..27d8c97 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -4133,6 +4133,7 @@ static int intel_iommu_add_device(struct device *dev)
>                                            PCI_DEVFN(PCI_SLOT(dma_pdev->devfn),
>                                            0)));
>
> +#if 0
>          while (!pci_is_root_bus(dma_pdev->bus)) {
>                  if (pci_acs_path_enabled(dma_pdev->bus->self,
>                                           NULL, REQ_ACS_FLAGS))
> @@ -4140,6 +4141,7 @@ static int intel_iommu_add_device(struct device *dev)
>
>                  swap_pci_ref(&dma_pdev, pci_dev_get(dma_pdev->bus->self));
>          }
> +#endif
>
>          group = iommu_group_get(&dma_pdev->dev);
>          pci_dev_put(dma_pdev);
>
>

