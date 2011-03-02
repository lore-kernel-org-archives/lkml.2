Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab1CBTE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:04:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:15319 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab1CBTE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:04:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,254,1297065600"; 
   d="scan'208";a="396500689"
Subject: Re: [PATCH 7/8 resend] dw_dmac.c: Pass Channel Allocation Order
 from platform_data
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: dan.j.williams@intel.com, linus.walleij@stericsson.com, amit.goel@st.com,
        linux-kernel@vger.kernel.org, armando.visconti@st.com,
        shiraz.hashim@st.com, linux-arm-kernel@lists.infradead.org
In-Reply-To: <ffc35e090243231bf0b3808f2b722c69be2ce36f.1298889267.git.viresh.kumar@st.com>
References: <cover.1298889267.git.viresh.kumar@st.com>
	 <ffc35e090243231bf0b3808f2b722c69be2ce36f.1298889267.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 00:07:54 +0530
Message-ID: <1299091074.6974.96.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 16:11 +0530, Viresh Kumar wrote:
> In SPEAr Platform channels 4-7 have more Fifo depth. So we must get better
> channel first. This patch introduces concept of channel allocation order in
> dw_dmac. If user doesn't paas anything or 0, than normal (ascending) channel
pass?
> allocation will follow, else channels will be allocated in descending order.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/dma/dw_dmac.c   |    6 +++++-
>  include/linux/dw_dmac.h |    3 +++
>  2 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 01f783d..37ffd2c 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1314,7 +1314,11 @@ static int __init dw_probe(struct platform_device *pdev)
>  		dwc->chan.device = &dw->dma;
>  		dwc->chan.cookie = dwc->completed = 1;
>  		dwc->chan.chan_id = i;
> -		list_add_tail(&dwc->chan.device_node, &dw->dma.channels);
> +		if (pdata->chan_allocation_order == CHAN_ALLOCATION_ASCENDING)
> +			list_add_tail(&dwc->chan.device_node,
> +					&dw->dma.channels);
> +		else
> +			list_add(&dwc->chan.device_node, &dw->dma.channels);
>  
>  		dwc->ch_regs = &__dw_regs(dw)->CHAN[i];
>  		spin_lock_init(&dwc->lock);
> diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
> index c8aad71..057e883 100644
> --- a/include/linux/dw_dmac.h
> +++ b/include/linux/dw_dmac.h
> @@ -19,6 +19,9 @@
>   */
>  struct dw_dma_platform_data {
>  	unsigned int	nr_channels;
> +#define CHAN_ALLOCATION_ASCENDING	0	/* zero to seven */
> +#define CHAN_ALLOCATION_DESCENDING	1	/* seven to zero */
Can you add these defines outside of this struct?
> +	unsigned int	chan_allocation_order;
>  };
>  
>  /**


-- 
~Vinod

