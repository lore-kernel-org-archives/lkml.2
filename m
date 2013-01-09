Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab3AIOO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:14:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:37217 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757811Ab3AIOO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:14:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,438,1355126400"; 
   d="scan'208";a="189328595"
Date: Wed, 9 Jan 2013 05:50:06 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [resend][PATCH 03/16] dmaengine: introduce is_slave_xfer
 function
Message-ID: <20130109135006.GO19691@intel.com>
References: <20130108155423.GJ19691@intel.com>
 <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1357719435-29955-4-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357719435-29955-4-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 10:17:02AM +0200, Andy Shevchenko wrote:
> This function helps to distinguish the slave type of transfer by checking the
> direction parameter.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  include/linux/dmaengine.h |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 4ca9cf7..b196ea3 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -621,6 +621,11 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
>  			(unsigned long)config);
>  }
>  
> +static inline bool is_slave_xfer(enum dma_transfer_direction direction)
> +{
> +	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
> +}
After reading the subsequent patch I understand what is intent here. Perhaps
is_slave_dirn() would have been a beter one...

> +
>  static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
>  	struct dma_chan *chan, dma_addr_t buf, size_t len,
>  	enum dma_transfer_direction dir, unsigned long flags)
> -- 
> 1.7.10.4
> 
