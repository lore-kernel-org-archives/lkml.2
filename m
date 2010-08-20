Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab0HTVtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 17:49:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:30772 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab0HTVtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 17:49:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,242,1280732400"; 
   d="scan'208";a="315202340"
Date: Fri, 20 Aug 2010 23:49:16 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 2.6.36] mfd: Ignore non-GPIO IRQs when setting wm831x
 IRQ types
Message-ID: <20100820214916.GH3650@sortiz-mobl>
References: <1281986811-2023-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281986811-2023-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Aug 16, 2010 at 08:26:51PM +0100, Mark Brown wrote:
> The driver was originally tested with an additional patch which
> made this unneeded but that patch had issuges and got lost on the
> way to mainline, causing problems when the errors are reported.
Thanks, applied to my for-linus branch.
I'll send it with my next 2.6.36 mfd fixes pull request.

Cheers,
Samuel.


> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: stable@kernel.org
> ---
>  drivers/mfd/wm831x-irq.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
> index 7dabe4d..294183b 100644
> --- a/drivers/mfd/wm831x-irq.c
> +++ b/drivers/mfd/wm831x-irq.c
> @@ -394,8 +394,13 @@ static int wm831x_irq_set_type(unsigned int irq, unsigned int type)
>  
>  	irq = irq - wm831x->irq_base;
>  
> -	if (irq < WM831X_IRQ_GPIO_1 || irq > WM831X_IRQ_GPIO_11)
> -		return -EINVAL;
> +	if (irq < WM831X_IRQ_GPIO_1 || irq > WM831X_IRQ_GPIO_11) {
> +		/* Ignore internal-only IRQs */
> +		if (irq >= 0 && irq < WM831X_NUM_IRQS)
> +			return 0;
> +		else
> +			return -EINVAL;
> +	}
>  
>  	switch (type) {
>  	case IRQ_TYPE_EDGE_BOTH:
> -- 
> 1.7.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
