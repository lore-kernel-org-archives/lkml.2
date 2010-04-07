Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab0DGIuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 04:50:08 -0400
Received: from mga10.intel.com ([192.55.52.92]:52151 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751229Ab0DGIuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 04:50:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,377,1267430400"; 
   d="scan'208";a="787086856"
Date: Wed, 7 Apr 2010 10:50:36 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Initialise WM831x IRQ masks on chip even if
 interrupts not in use
Message-ID: <20100407085035.GC2962@sortiz.org>
References: <1270480458-2346-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270480458-2346-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Apr 05, 2010 at 04:14:17PM +0100, Mark Brown wrote:
> Ensure that the hardware has interrupts masked if we are not using
> the interrupt controller on the WM831x by initialising the masks
> before we check for the setup data required for the IRQ line. This
> avoids signalling an unused IRQ line and improves the robustness
> of checks that the IRQ is in use.
Patch applied, thanks.

Cheers,
Samuel.


> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm831x-irq.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
> index b1d66b8..f8b51be 100644
> --- a/drivers/mfd/wm831x-irq.c
> +++ b/drivers/mfd/wm831x-irq.c
> @@ -460,6 +460,14 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
>  
>  	mutex_init(&wm831x->irq_lock);
>  
> +	/* Mask the individual interrupt sources */
> +	for (i = 0; i < ARRAY_SIZE(wm831x->irq_masks_cur); i++) {
> +		wm831x->irq_masks_cur[i] = 0xffff;
> +		wm831x->irq_masks_cache[i] = 0xffff;
> +		wm831x_reg_write(wm831x, WM831X_INTERRUPT_STATUS_1_MASK + i,
> +				 0xffff);
> +	}
> +
>  	if (!irq) {
>  		dev_warn(wm831x->dev,
>  			 "No interrupt specified - functionality limited\n");
> @@ -475,14 +483,6 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
>  	wm831x->irq = irq;
>  	wm831x->irq_base = pdata->irq_base;
>  
> -	/* Mask the individual interrupt sources */
> -	for (i = 0; i < ARRAY_SIZE(wm831x->irq_masks_cur); i++) {
> -		wm831x->irq_masks_cur[i] = 0xffff;
> -		wm831x->irq_masks_cache[i] = 0xffff;
> -		wm831x_reg_write(wm831x, WM831X_INTERRUPT_STATUS_1_MASK + i,
> -				 0xffff);
> -	}
> -
>  	/* Register them with genirq */
>  	for (cur_irq = wm831x->irq_base;
>  	     cur_irq < ARRAY_SIZE(wm831x_irqs) + wm831x->irq_base;
> -- 
> 1.7.0.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
