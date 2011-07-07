Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab1GGSnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:43:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55520 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab1GGSnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:43:24 -0400
Date: Thu, 7 Jul 2011 12:43:21 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] plat-mxc: add missing initialisation of basic_mmio_gpio
 shadow variables
Message-ID: <20110707184321.GG2824@ponder.secretlab.ca>
References: <1310043016-1121-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1310043016-1121-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 02:50:16PM +0200, Lothar Waﬂmann wrote:
> The bgpio_init() function does not initialise the shadow register for
> the GPIO direction register. Thus, when configuring the first GPIO with
> gpio_set_direction() all other GPIOs of the same bank will be
> configured as inputs. Since the bgpio layer cannot know whether the
> register is readable, the initialisation should be done by the caller
> of bgpio_init().
> 
> Also, the 'data' shadow variable that is used inside basic_mmio_gpio
> to cache the current value of the GPIO_DR register is initialised from
> the GPIO_PSR register within bgpio_init(). Thus when setting the
> output value of a certain GPIO, the other GPIO outputs of the same
> bank will be set or cleared depending on the pin state of the GPIO
> inputs during bgpio_init().
> 
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>

Applied, thanks.

g.

> ---
>  drivers/gpio/gpio-mxc.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
> index b351952..f7944ca 100644
> --- a/drivers/gpio/gpio-mxc.c
> +++ b/drivers/gpio/gpio-mxc.c
> @@ -337,6 +337,8 @@ static int __devinit mxc_gpio_probe(struct platform_device *pdev)
>  		goto out_iounmap;
>  
>  	port->bgc.gc.base = pdev->id * 32;
> +	port->bgc.dir = port->bgc.read_reg(port->bgc.reg_dir);
> +	port->bgc.data = port->bgc.read_reg(port->bgc.reg_set);
>  
>  	err = gpiochip_add(&port->bgc.gc);
>  	if (err)
> -- 
> 1.5.6.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
