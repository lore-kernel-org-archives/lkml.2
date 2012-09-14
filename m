Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab2INDEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:04:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:28108 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648Ab2INDDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:03:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,420,1344236400"; 
   d="scan'208";a="203521770"
Subject: Re: [PATCH] dw_dmac: utilize slave_id to pass request line
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
In-Reply-To: <1346669179-21024-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1346669179-21024-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Sep 2012 08:30:07 +0530
Message-ID: <1347591607.1943.8.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-03 at 13:46 +0300, Andy Shevchenko wrote:
> There is slave_id field in the generic slave config structure that is dedicated
> for the uniq slave number. In our case we have the request lines wired to the
> certain hardware. Therefore the number of the request line is uniq and could be
> used as slave_id. It allows us in some cases to drop out the usage of the
> custom slave config structure.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Applied thanks
> ---
>  drivers/dma/dw_dmac.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index f0c9403..7a67673 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -187,6 +187,11 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
>  
>  		cfghi = dws->cfg_hi;
>  		cfglo |= dws->cfg_lo & ~DWC_CFGL_CH_PRIOR_MASK;
> +	} else {
> +		if (dwc->dma_sconfig.direction == DMA_MEM_TO_DEV)
> +			cfghi = DWC_CFGH_DST_PER(dwc->dma_sconfig.slave_id);
> +		else if (dwc->dma_sconfig.direction == DMA_DEV_TO_MEM)
> +			cfghi = DWC_CFGH_SRC_PER(dwc->dma_sconfig.slave_id);
>  	}
>  
>  	channel_writel(dwc, CFG_LO, cfglo);


-- 
~Vinod

