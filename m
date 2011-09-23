Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab1IWRoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:44:44 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26106 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1IWRoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:44:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6477"; a="121088953"
Date: Fri, 23 Sep 2011 10:44:42 -0700
From: David Brown <davidb@codeaurora.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, joro@8bytes.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] iommu/msm: Use bus_set_iommu instead of
 register_iommu
Message-ID: <20110923174442.GB6480@huya.qualcomm.com>
References: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com>
 <1316792756-3395-10-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316792756-3395-10-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 05:45:55PM +0200, Joerg Roedel wrote:
> Convert the MSM IOMMU driver for ARM to use the new
> interface for publishing the iommu_ops.
> 
> Cc: David Brown <davidb@codeaurora.org>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/iommu/msm_iommu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
> index d1733f6..5865dd2 100644
> --- a/drivers/iommu/msm_iommu.c
> +++ b/drivers/iommu/msm_iommu.c
> @@ -728,7 +728,7 @@ static void __init setup_iommu_tex_classes(void)
>  static int __init msm_iommu_init(void)
>  {
>  	setup_iommu_tex_classes();
> -	register_iommu(&msm_iommu_ops);
> +	bus_set_iommu(&platform_bus_type, &msm_iommu_ops);
>  	return 0;
>  }

Acked-by: David Brown <davidb@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
