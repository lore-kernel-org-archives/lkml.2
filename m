Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab0HBItj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:49:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:32287 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264Ab0HBIti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:49:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,302,1278313200"; 
   d="scan'208";a="307059289"
Date: Mon, 2 Aug 2010 10:49:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH RESEND] jz4740-adc: check kmalloc() result
Message-ID: <20100802084940.GA3334@sortiz-mobl>
References: <1280711524.6538.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280711524.6538.3.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Mon, Aug 02, 2010 at 09:12:04AM +0800, Axel Lin wrote:
> >From 40f965e63c4aefb402d85cf8392681565e172d2d Mon Sep 17 00:00:00 2001
> From: Axel Lin <axel.lin@gmail.com>
> Date: Mon, 2 Aug 2010 09:02:02 +0800
> Subject: [PATCH] jz4740-adc: check kmalloc() result
> 
> If kmalloc() fails exit with -ENOMEM.
Thanks a lot, patch applied against my for-next branch.

Cheers,
Samuel.


> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> This patch is against linux-next.
> This resend separates the fix for jz4740-hwmon and jz474-adc in 2 patches.
>  drivers/mfd/jz4740-adc.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
> index 7a844ae..2846d24 100644
> --- a/drivers/mfd/jz4740-adc.c
> +++ b/drivers/mfd/jz4740-adc.c
> @@ -260,6 +260,10 @@ static int __devinit jz4740_adc_probe(struct platform_device *pdev)
>  	int irq;
>  
>  	adc = kmalloc(sizeof(*adc), GFP_KERNEL);
> +	if (!adc) {
> +		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
> +		return -ENOMEM;
> +	}
>  
>  	adc->irq = platform_get_irq(pdev, 0);
>  	if (adc->irq < 0) {
> -- 
> 1.5.4.3
> 
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
