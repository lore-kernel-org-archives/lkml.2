Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab0JGQc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 12:32:26 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:34044 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750952Ab0JGQcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 12:32:25 -0400
Message-ID: <4CADF606.70001@metafoo.de>
Date: Thu, 07 Oct 2010 18:32:06 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: jz4740-adc - fix jz4740_adc_set_enabled
References: <1286437880.18303.2.camel@mola>
In-Reply-To: <1286437880.18303.2.camel@mola>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:
> When enabled is false, clear BIT(engine) of JZ_REG_ADC_ENABLE register.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks
- Lars

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

