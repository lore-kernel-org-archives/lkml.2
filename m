Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab0I2GaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 02:30:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53451 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab0I2GaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 02:30:14 -0400
Date: Wed, 29 Sep 2010 15:30:11 +0900
From: Grant Likely <grant.likely@secretlab.ca>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
        edgar.iglesias@gmail.com, duyl@xilinx.com, linnj@xilinx.com,
        microblaze-uclinux@itee.uq.edu.au, Tejun Heo <tj@kernel.org>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/7] of: GPIO: Fix OF probing on little-endian systems
Message-ID: <20100929063011.GF2439@angua.secretlab.ca>
References: <1285739538-29058-1-git-send-email-monstr@monstr.eu>
 <1285739538-29058-2-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285739538-29058-2-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 03:52:12PM +1000, Michal Simek wrote:
> DTB is always big-endian that's why is necessary
> to convert it.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> CC: Grant Likely <grant.likely@secretlab.ca>
> CC: Tejun Heo <tj@kernel.org>
> CC: Anton Vorontsov <avorontsov@ru.mvista.com>
> CC: linux-kernel@vger.kernel.org
> CC: devicetree-discuss@lists.ozlabs.org

Applied, thanks.

g.

> ---
>  drivers/gpio/xilinx_gpio.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpio/xilinx_gpio.c b/drivers/gpio/xilinx_gpio.c
> index 7096909..846fbd5 100644
> --- a/drivers/gpio/xilinx_gpio.c
> +++ b/drivers/gpio/xilinx_gpio.c
> @@ -171,13 +171,13 @@ static int __devinit xgpio_of_probe(struct device_node *np)
>  	/* Update GPIO state shadow register with default value */
>  	tree_info = of_get_property(np, "xlnx,dout-default", NULL);
>  	if (tree_info)
> -		chip->gpio_state = *tree_info;
> +		chip->gpio_state = be32_to_cpup(tree_info);
>  
>  	/* Update GPIO direction shadow register with default value */
>  	chip->gpio_dir = 0xFFFFFFFF; /* By default, all pins are inputs */
>  	tree_info = of_get_property(np, "xlnx,tri-default", NULL);
>  	if (tree_info)
> -		chip->gpio_dir = *tree_info;
> +		chip->gpio_dir = be32_to_cpup(tree_info);
>  
>  	/* Check device node and parent device node for device width */
>  	chip->mmchip.gc.ngpio = 32; /* By default assume full GPIO controller */
> @@ -186,7 +186,7 @@ static int __devinit xgpio_of_probe(struct device_node *np)
>  		tree_info = of_get_property(np->parent,
>  					    "xlnx,gpio-width", NULL);
>  	if (tree_info)
> -		chip->mmchip.gc.ngpio = *tree_info;
> +		chip->mmchip.gc.ngpio = be32_to_cpup(tree_info);
>  
>  	spin_lock_init(&chip->gpio_lock);
>  
> -- 
> 1.5.5.1
> 
