Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab0HAWlG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 18:41:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:16145 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0HAWlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 18:41:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,299,1278313200"; 
   d="scan'208";a="823743795"
Date: Mon, 2 Aug 2010 00:41:06 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 1/2] jz4740-adc/jz4740-hwmon: check kmalloc() result
Message-ID: <20100801224105.GB3052@sortiz-mobl>
References: <1280391953.21676.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280391953.21676.2.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Thu, Jul 29, 2010 at 04:25:53PM +0800, Axel Lin wrote:
> If kmalloc() fails, exit with -ENOMEM.
Could you please separate this patch in 2, as the 2 drivers live in different
trees for now ?

Cheers,
Samuel.


> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> This patch is against linux-next.
>  drivers/hwmon/jz4740-hwmon.c |    4 ++++
>  drivers/mfd/jz4740-adc.c     |    4 ++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/jz4740-hwmon.c b/drivers/hwmon/jz4740-hwmon.c
> index 72a4335..1c8b3d9 100644
> --- a/drivers/hwmon/jz4740-hwmon.c
> +++ b/drivers/hwmon/jz4740-hwmon.c
> @@ -107,6 +107,10 @@ static int __devinit jz4740_hwmon_probe(struct platform_device *pdev)
>  	struct jz4740_hwmon *hwmon;
>  
>  	hwmon = kmalloc(sizeof(*hwmon), GFP_KERNEL);
> +	if (!hwmon) {
> +		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
> +		return -ENOMEM;
> +	}
>  
>  	hwmon->cell = pdev->dev.platform_data;
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
