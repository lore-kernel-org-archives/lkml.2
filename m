Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab2ISJfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 05:35:06 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:58724 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab2ISJfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 05:35:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Russell King <linux@arm.linux.org.uk>, Rajendra Nayak <rnayak@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 1/9] ARM: OMAP: iommu: fix including iommu.h without IOMMU_API selected
Date: Wed, 19 Sep 2012 11:35:36 +0200
Message-ID: <2682570.BmY78BED3q@avalon>
User-Agent: KMail/4.9.1 (Linux/3.3.8-gentoo; KDE/4.9.1; x86_64; ; )
In-Reply-To: <1347479152-588-2-git-send-email-omar.luna@linaro.org>
References: <1347479152-588-1-git-send-email-omar.luna@linaro.org> <1347479152-588-2-git-send-email-omar.luna@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2012 14:45:44 Omar Ramirez Luna wrote:
> If included without IOMMU_API being selected it will break
> compilation:
> 
> arch/arm/plat-omap/include/plat/iommu.h:
> 	In function 'dev_to_omap_iommu':
> arch/arm/plat-omap/include/plat/iommu.h:148:
> 	error: 'struct dev_archdata' has no member named 'iommu'
> 
> This will be seen when hwmod includes iommu.h to get the
> structure for attributes. Also needed for tidspbridge
> incremental migration to use iommu code.
> 
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I had the same patch in my tree already :-)

> ---
>  arch/arm/plat-omap/include/plat/iommu.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/plat-omap/include/plat/iommu.h
> b/arch/arm/plat-omap/include/plat/iommu.h index 88be3e6..e58d571 100644
> --- a/arch/arm/plat-omap/include/plat/iommu.h
> +++ b/arch/arm/plat-omap/include/plat/iommu.h
> @@ -126,6 +126,7 @@ struct omap_iommu_arch_data {
>  	struct omap_iommu *iommu_dev;
>  };
> 
> +#ifdef CONFIG_IOMMU_API
>  /**
>   * dev_to_omap_iommu() - retrieves an omap iommu object from a user device
>   * @dev: iommu client device
> @@ -136,6 +137,7 @@ static inline struct omap_iommu
> *dev_to_omap_iommu(struct device *dev)
> 
>  	return arch_data->iommu_dev;
>  }
> +#endif
> 
>  /* IOMMU errors */
>  #define OMAP_IOMMU_ERR_TLB_MISS		(1 << 0)

-- 
Regards,

Laurent Pinchart

