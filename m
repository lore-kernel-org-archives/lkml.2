Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab2AHKFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 05:05:20 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:6861 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab2AHKFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 05:05:17 -0500
Date: Sun, 8 Jan 2012 11:05:00 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Korsgaard <peter.korsgaard@barco.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: convert gpio-i2cmux to use
 module_platform_driver()
Message-ID: <20120108110500.34845281@endymion.delvare>
In-Reply-To: <1325986552.4442.0.camel@phoenix>
References: <1325986552.4442.0.camel@phoenix>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Jan 2012 09:35:52 +0800, Axel Lin wrote:
> This patch converts gpio-i2cmux to use the module_platform_driver() macro which
> makes the code smaller and a bit simpler.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/i2c/muxes/gpio-i2cmux.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/i2c/muxes/gpio-i2cmux.c b/drivers/i2c/muxes/gpio-i2cmux.c
> index 7b6ce62..e5fa695 100644
> --- a/drivers/i2c/muxes/gpio-i2cmux.c
> +++ b/drivers/i2c/muxes/gpio-i2cmux.c
> @@ -165,18 +165,7 @@ static struct platform_driver gpiomux_driver = {
>  	},
>  };
>  
> -static int __init gpiomux_init(void)
> -{
> -	return platform_driver_register(&gpiomux_driver);
> -}
> -
> -static void __exit gpiomux_exit(void)
> -{
> -	platform_driver_unregister(&gpiomux_driver);
> -}
> -
> -module_init(gpiomux_init);
> -module_exit(gpiomux_exit);
> +module_platform_driver(gpiomux_driver);
>  
>  MODULE_DESCRIPTION("GPIO-based I2C multiplexer driver");
>  MODULE_AUTHOR("Peter Korsgaard <peter.korsgaard@barco.com>");

Applied, thanks!

-- 
Jean Delvare
