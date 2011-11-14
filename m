Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab1KNVBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 16:01:20 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:37456 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab1KNVBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 16:01:18 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19xzQxcxLtSWIf0YFL08zbn
Date: Mon, 14 Nov 2011 13:01:13 -0800
From: Tony Lindgren <tony@atomide.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>, iommu@lists.linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Cousson Benoit <b-cousson@ti.com>, Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC 3/5] ARM: OMAP: iommu: declare a private iommu binding
 struct
Message-ID: <20111114210113.GM31337@atomide.com>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com>
 <1316948337-7924-4-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316948337-7924-4-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ohad Ben-Cohen <ohad@wizery.com> [110925 03:27]:
> Declare an omap iommu private struct, which binds an iommu user
> to its iommu device. This struct should be placed at the iommu user's
> dev_archdata so generic IOMMU API can be used without having to
> utilize omap-specific plumbing anymore.
> 
> While at it, provide an accessor method to ease the retrieval of the
> omap_iommu handle from a user device.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>

Acked-by: Tony Lindgren <tony@atomide.com>


> ---
>  arch/arm/plat-omap/include/plat/iommu.h |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/include/plat/iommu.h b/arch/arm/plat-omap/include/plat/iommu.h
> index a1d79ee..fa11ee2 100644
> --- a/arch/arm/plat-omap/include/plat/iommu.h
> +++ b/arch/arm/plat-omap/include/plat/iommu.h
> @@ -111,6 +111,32 @@ struct iommu_platform_data {
>  	u32 da_end;
>  };
>  
> +/**
> + * struct iommu_arch_data - omap iommu private data
> + * @name: name of the iommu device
> + * @iommu_dev: handle of the iommu device
> + *
> + * This is an omap iommu private data object, which binds an iommu user
> + * to its iommu device. This object should be placed at the iommu user's
> + * dev_archdata so generic IOMMU API can be used without having to
> + * utilize omap-specific plumbing anymore.
> + */
> +struct omap_iommu_arch_data {
> +	const char *name;
> +	struct omap_iommu *iommu_dev;
> +};
> +
> +/**
> + * dev_to_omap_iommu() - retrieves an omap iommu object from a user device
> + * @dev: iommu client device
> + */
> +static inline struct omap_iommu *dev_to_omap_iommu(struct device *dev)
> +{
> +	struct omap_iommu_arch_data *arch_data = dev->archdata.iommu;
> +
> +	return arch_data->iommu_dev;
> +}
> +
>  /* IOMMU errors */
>  #define OMAP_IOMMU_ERR_TLB_MISS		(1 << 0)
>  #define OMAP_IOMMU_ERR_TRANS_FAULT	(1 << 1)
> -- 
> 1.7.4.1
> 
