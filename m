Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab2HZSKP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 14:10:15 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60832 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376Ab2HZSKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 14:10:12 -0400
Date: Sun, 26 Aug 2012 20:10:10 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 06/19] x86, msi: Use IRQ remapping specific
 setup_msi_irqs routine
Message-ID: <20120826181010.GB3690@breakpoint.cc>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-7-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345470965-24410-7-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 03:55:52PM +0200, Joerg Roedel wrote:
> diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
> index f439151..984104b 100644
> --- a/drivers/iommu/irq_remapping.c
> +++ b/drivers/iommu/irq_remapping.c
> @@ -181,7 +232,7 @@ void compose_remapped_msi_msg(struct pci_dev *pdev,
>  	remap_ops->compose_msi_msg(pdev, irq, dest, msg, hpet_id);
>  }
>  
> -int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
> +static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
>  {
>  	if (!remap_ops || !remap_ops->msi_alloc_irq)
>  		return -ENODEV;
> @@ -189,8 +240,8 @@ int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
>  	return remap_ops->msi_alloc_irq(pdev, irq, nvec);
>  }
>  
> -int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
> -			   int index, int sub_handle)
> +static int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
> +				  int index, int sub_handle)
>  {
>  	if (!remap_ops || !remap_ops->msi_setup_irq)
>  		return -ENODEV;

Both functions, that is msi_alloc_remapped_irq() and msi_setup_remapped_irq()
and are now called only from irq_remapping_setup_msi_irqs() which can only be
called once remap_ops are set.

Sebastian
