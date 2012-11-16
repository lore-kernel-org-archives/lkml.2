Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab2KPORy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:17:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:57745 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab2KPORx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:17:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,265,1352102400"; 
   d="scan'208";a="250268767"
Date: Fri, 16 Nov 2012 16:21:04 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/6] dmaengine: introduce is_slave_xfer function
Message-ID: <20121116142104.GT17774@intel.com>
References: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1353074360-1903-2-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353074360-1903-2-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 03:59:14PM +0200, Andy Shevchenko wrote:
> This function helps to distinguish the slave type of transfer by checking the
> direction parameter.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> ---
>  include/linux/dmaengine.h |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 6402b18..3e1a9026 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -618,6 +618,11 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
>  			(unsigned long)config);
>  }
>  
> +static inline bool is_slave_xfer(enum dma_transfer_direction direction)
> +{
> +	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
> +}

I wonder if the above function need some prefix like
dmaengine_is_slave_xfer()?

Otherwise looks fine to me.
