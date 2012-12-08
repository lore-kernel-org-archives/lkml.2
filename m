Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab2LHLQi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 06:16:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44762 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab2LHLQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 06:16:36 -0500
Date: Sat, 8 Dec 2012 12:16:29 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric =?iso-8859-15?Q?B=E9nard?= <ebenard@eukrea.com>
Subject: Re: [PATCH v2] ARM: eukrea_mbimx27-baseboard - use stock
 get_pendown_state() in ads7846
Message-ID: <20121208111629.GG10369@pengutronix.de>
References: <20121124082529.GA7687@core.coreip.homeip.net>
 <20121127074209.GL10369@pengutronix.de>
 <20121127090356.GA25658@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127090356.GA25658@core.coreip.homeip.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:16:21 up 168 days,  2:28, 21 users,  load average: 1.74, 1.70,
 3.37
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 01:03:56AM -0800, Dmitry Torokhov wrote:
> The default implementation matches exactly our custom one so we can switch
> to using the default one. As a bonus the driver will take care of setting
> GPIO line for us.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Applied, thanks

Sascha

> ---
> 
> Adjusted to use IMX_GPIO_NR() macro.
> 
>  arch/arm/mach-imx/eukrea_mbimx27-baseboard.c |   19 +------------------
>  1 file changed, 1 insertion(+), 18 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c b/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c
> index 98aef57..f361143 100644
> --- a/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c
> +++ b/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c
> @@ -238,24 +238,8 @@ static const struct imxuart_platform_data uart_pdata __initconst = {
>  	.flags = IMXUART_HAVE_RTSCTS,
>  };
>  
> -#define ADS7846_PENDOWN (GPIO_PORTD | 25)
> -
> -static void __maybe_unused ads7846_dev_init(void)
> -{
> -	if (gpio_request(ADS7846_PENDOWN, "ADS7846 pendown") < 0) {
> -		printk(KERN_ERR "can't get ads7846 pen down GPIO\n");
> -		return;
> -	}
> -	gpio_direction_input(ADS7846_PENDOWN);
> -}
> -
> -static int ads7846_get_pendown_state(void)
> -{
> -	return !gpio_get_value(ADS7846_PENDOWN);
> -}
> -
>  static struct ads7846_platform_data ads7846_config __initdata = {
> -	.get_pendown_state	= ads7846_get_pendown_state,
> +	.gpio_pendown		= IMX_GPIO_NR(4, 25),
>  	.keep_vref_on		= 1,
>  };
>  
> @@ -323,7 +307,6 @@ void __init eukrea_mbimx27_baseboard_init(void)
>  	|| defined(CONFIG_TOUCHSCREEN_ADS7846_MODULE)
>  	/* ADS7846 Touchscreen controller init */
>  	mxc_gpio_mode(GPIO_PORTD | 25 | GPIO_GPIO | GPIO_IN);
> -	ads7846_dev_init();
>  #endif
>  
>  	/* SPI_CS0 init */
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
