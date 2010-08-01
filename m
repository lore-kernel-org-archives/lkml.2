Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab0HAWnJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 18:43:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:10123 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0HAWnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 18:43:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,299,1278313200"; 
   d="scan'208";a="540980485"
Date: Mon, 2 Aug 2010 00:43:09 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 2/2] jz4740-adc: fix resource reclaim in
 jz4740_adc_probe error path
Message-ID: <20100801224308.GC3052@sortiz-mobl>
References: <1280392105.21676.6.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280392105.21676.6.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Thu, Jul 29, 2010 at 04:28:25PM +0800, Axel Lin wrote:
> If mfd_add_devices() fail, we need to relese allocated resources.
Patch applied, thanks a lot.

Cheers,
Samuel.


> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> This patch is against linux-next.
>  drivers/mfd/jz4740-adc.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
> index 2846d24..3ad492c 100644
> --- a/drivers/mfd/jz4740-adc.c
> +++ b/drivers/mfd/jz4740-adc.c
> @@ -326,9 +326,15 @@ static int __devinit jz4740_adc_probe(struct platform_device *pdev)
>  	writeb(0x00, adc->base + JZ_REG_ADC_ENABLE);
>  	writeb(0xff, adc->base + JZ_REG_ADC_CTRL);
>  
> -	return mfd_add_devices(&pdev->dev, 0, jz4740_adc_cells,
> +	ret = mfd_add_devices(&pdev->dev, 0, jz4740_adc_cells,
>  		ARRAY_SIZE(jz4740_adc_cells), mem_base, adc->irq_base);
> +	if (ret < 0)
> +		goto err_clk_put;
>  
> +	return 0;
> +
> +err_clk_put:
> +	clk_put(adc->clk);
>  err_iounmap:
>  	platform_set_drvdata(pdev, NULL);
>  	iounmap(adc->base);
> -- 
> 1.5.4.3
> 
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
