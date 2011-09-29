Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab1I2UJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:09:57 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46026 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755709Ab1I2UJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:09:55 -0400
X-Sasl-enc: pEB9rnqNdx+SCd2s/qI3D2P7rwqekF0aADX44Cj6r0NX 1317326994
Date: Thu, 29 Sep 2011 13:04:23 -0700
From: Greg KH <greg@kroah.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, joro@8bytes.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] iommu/omap: Use bus_set_iommu instead of
 register_iommu
Message-ID: <20110929200423.GB26760@kroah.com>
References: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com>
 <1316792756-3395-9-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316792756-3395-9-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 05:45:54PM +0200, Joerg Roedel wrote:
> Convert the OMAP IOMMU driver on ARM to use the new
> interface for publishing the iommu_ops.
> 
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/iommu/omap-iommu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
> index bd5f606..16d5b76 100644
> --- a/drivers/iommu/omap-iommu.c
> +++ b/drivers/iommu/omap-iommu.c
> @@ -1250,7 +1250,7 @@ static int __init omap_iommu_init(void)
>  		return -ENOMEM;
>  	iopte_cachep = p;
>  
> -	register_iommu(&omap_iommu_ops);
> +	bus_set_iommu(&platform_bus_type, &omap_iommu_ops);

I too worry about this.

It kind of looks like the omap code should not be using the platform bus
code for this, but instead, use their own bus code, as I'm sure that not
all platform devices really work properly with this iommu controller,
right?

thanks,

greg k-h
