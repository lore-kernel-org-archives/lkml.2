Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab0JSJMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:12:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:29613 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756596Ab0JSJMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:12:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,349,1283756400"; 
   d="scan'208";a="668733510"
Date: Tue, 19 Oct 2010 11:12:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH] mfd: jz4740-adc - fix jz4740_adc_set_enabled
Message-ID: <20101019091241.GC2736@sortiz-mobl>
References: <1286437880.18303.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286437880.18303.2.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Thu, Oct 07, 2010 at 03:51:20PM +0800, Axel Lin wrote:
> When enabled is false, clear BIT(engine) of JZ_REG_ADC_ENABLE register.
Patch applied, thanks.

Cheers,
Samuel.


> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/jz4740-adc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
> index 3ad492c..9dd1b33 100644
> --- a/drivers/mfd/jz4740-adc.c
> +++ b/drivers/mfd/jz4740-adc.c
> @@ -153,7 +153,7 @@ static inline void jz4740_adc_set_enabled(struct jz4740_adc *adc, int engine,
>  	if (enabled)
>  		val |= BIT(engine);
>  	else
> -		val &= BIT(engine);
> +		val &= ~BIT(engine);
>  	writeb(val, adc->base + JZ_REG_ADC_ENABLE);
>  
>  	spin_unlock_irqrestore(&adc->lock, flags);
> -- 
> 1.7.2
> 
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
