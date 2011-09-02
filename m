Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab1IBSgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 14:36:40 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23992 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab1IBSgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 14:36:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6457"; a="115025454"
Date: Fri, 2 Sep 2011 11:36:34 -0700
From: David Brown <davidb@codeaurora.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: iommu@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH 5/7] iommu/msm: ->unmap() should return order of unmapped
 page
Message-ID: <20110902183634.GA25775@huya.qualcomm.com>
References: <1314984756-4400-1-git-send-email-ohad@wizery.com>
 <1314984756-4400-6-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314984756-4400-6-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 08:32:34PM +0300, Ohad Ben-Cohen wrote:
> Users of the IOMMU API (kvm specifically) assume that iommu_unmap()
> returns the order of the unmapped page (on success).
> 
> Fix msm_iommu_unmap() accordingly.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
> Cc: David Brown <davidb@codeaurora.org>
> ---
>  drivers/iommu/msm_iommu.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
> index 1a584e0..d1733f6 100644
> --- a/drivers/iommu/msm_iommu.c
> +++ b/drivers/iommu/msm_iommu.c
> @@ -543,6 +543,13 @@ static int msm_iommu_unmap(struct iommu_domain *domain, unsigned long va,
>  	}
>  
>  	ret = __flush_iotlb(domain);
> +
> +	/*
> +	 * the IOMMU API requires us to return the order of the unmapped
> +	 * page (on success).
> +	 */
> +	if (!ret)
> +		ret = order;
>  fail:
>  	spin_unlock_irqrestore(&msm_iommu_lock, flags);
>  	return ret;

Acked-by: David Brown <davidb@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
