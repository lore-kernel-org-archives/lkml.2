Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab2LMPtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:49:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab2LMPtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:49:07 -0500
Message-ID: <1355413735.2229.1.camel@ul30vt.home>
Subject: Re: [PATCH] iommu: moving initialization earlier
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, iommu <iommu@lists.linux-foundation.org>,
        joro@8bytes.org
Date: Thu, 13 Dec 2012 08:48:55 -0700
In-Reply-To: <1355380115-4518-1-git-send-email-aik@ozlabs.ru>
References: <1355365763.19932.75.camel@pasglop>
	 <1355380115-4518-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probably a good idea to CC the iommu list and maintainer...

On Thu, 2012-12-13 at 17:28 +1100, Alexey Kardashevskiy wrote:
> The iommu_init() call initializes IOMMU internal structures and data
> required for the API to function such as iommu_group_alloc().
> It is registered as a subsys_initcall.
> 
> One of the IOMMU users is a PCI subsystem on POWER which discovers new
> IOMMU tables during the PCI scan so the most logical place to call
> iommu_group_alloc() is when a new group is just discovered. However
> PCI scan is done from subsys_initcall hook as well what makes
> using of the IOMMU API impossible.
> 
> The patch moves IOMMU subsystem initialization one step earlier.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  drivers/iommu/iommu.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index de857bb..b0afd3d 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -865,7 +865,7 @@ printk("%s %u\n", __func__, __LINE__);
>  
>  	return 0;
>  }
> -subsys_initcall(iommu_init);
> +arch_initcall(iommu_init);
>  
>  int iommu_domain_get_attr(struct iommu_domain *domain,
>  			  enum iommu_attr attr, void *data)



