Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab2KPP36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:29:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:14579 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab2KPP35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:29:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,265,1352102400"; 
   d="scan'208";a="169223808"
Date: Fri, 16 Nov 2012 17:33:09 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 4/6] dma: ep93xx_dma: reuse is_slave_xfer helper
Message-ID: <20121116153309.GX17774@intel.com>
References: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1353074360-1903-5-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353074360-1903-5-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 03:59:17PM +0200, Andy Shevchenko wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

> ---
>  drivers/dma/ep93xx_dma.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
> index bcfde40..7c26354 100644
> --- a/drivers/dma/ep93xx_dma.c
> +++ b/drivers/dma/ep93xx_dma.c
> @@ -903,8 +903,7 @@ static int ep93xx_dma_alloc_chan_resources(struct dma_chan *chan)
>  			switch (data->port) {
>  			case EP93XX_DMA_SSP:
>  			case EP93XX_DMA_IDE:
> -				if (data->direction != DMA_MEM_TO_DEV &&
> -				    data->direction != DMA_DEV_TO_MEM)
> +				if (!is_slave_xfter(data->direction))
>  					return -EINVAL;
>  				break;
>  			default:
> -- 
> 1.7.10.4
