Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab1K0TWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 14:22:33 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:7788 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab1K0TWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 14:22:31 -0500
Date: Sun, 27 Nov 2011 20:22:12 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Jochen Friedrich <jochen@scram.de>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Barry Song <21cnbao@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: convert drivers/i2c/* to use
 module_platform_driver()
Message-ID: <20111127202212.44ebf4c4@endymion.delvare>
In-Reply-To: <1322374332.2226.1.camel@phoenix>
References: <1322374332.2226.1.camel@phoenix>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Sun, 27 Nov 2011 14:12:12 +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/i2c/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Jochen Friedrich <jochen@scram.de>
> Cc: Peter Korsgaard <jacmet@sunsite.dk>
> Cc: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Cc: Manuel Lauss <manuel.lauss@googlemail.com>
> Cc: Barry Song <21cnbao@gmail.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/i2c/busses/i2c-at91.c         |   17 ++---------------
>  drivers/i2c/busses/i2c-au1550.c       |   13 +------------
>  drivers/i2c/busses/i2c-cpm.c          |   13 +------------
>  drivers/i2c/busses/i2c-highlander.c   |   13 +------------
>  drivers/i2c/busses/i2c-ibm_iic.c      |   13 +------------
>  drivers/i2c/busses/i2c-iop3xx.c       |   16 +---------------
>  drivers/i2c/busses/i2c-isch.c         |   13 +------------
>  drivers/i2c/busses/i2c-ixp2000.c      |   13 +------------
>  drivers/i2c/busses/i2c-mpc.c          |   13 +------------
>  drivers/i2c/busses/i2c-mv64xxx.c      |   15 +--------------
>  drivers/i2c/busses/i2c-ocores.c       |   17 ++---------------
>  drivers/i2c/busses/i2c-octeon.c       |   16 +---------------
>  drivers/i2c/busses/i2c-pca-platform.c |   14 +-------------
>  drivers/i2c/busses/i2c-pmcmsp.c       |   17 ++---------------
>  drivers/i2c/busses/i2c-powermac.c     |   19 ++-----------------
>  drivers/i2c/busses/i2c-puv3.c         |   16 ++--------------
>  drivers/i2c/busses/i2c-sh7760.c       |   13 +------------
>  drivers/i2c/busses/i2c-simtec.c       |   20 ++------------------
>  drivers/i2c/busses/i2c-xiic.c         |   18 ++----------------
>  drivers/i2c/muxes/gpio-i2cmux.c       |   13 +------------
>  20 files changed, 27 insertions(+), 275 deletions(-)

Looks overall good. I'd rather let Ben apply it as most affected
drivers are for embedded platforms.

Just two minor comments:

> --- a/drivers/i2c/busses/i2c-simtec.c
> +++ b/drivers/i2c/busses/i2c-simtec.c
> @@ -156,12 +156,6 @@ static int simtec_i2c_remove(struct platform_device *dev)
>  	return 0;
>  }
>  
> -
> -/* device driver */

I see no good reason for removing that comment.

> -
> -/* work with hotplug and coldplug */
> -MODULE_ALIAS("platform:simtec-i2c");
> -
>  static struct platform_driver simtec_i2c_driver = {
>  	.driver		= {
>  		.name		= "simtec-i2c",
> @@ -171,19 +165,9 @@ static struct platform_driver simtec_i2c_driver = {
>  	.remove		= simtec_i2c_remove,
>  };
>  
> -static int __init i2c_adap_simtec_init(void)
> -{
> -	return platform_driver_register(&simtec_i2c_driver);
> -}
> -
> -static void __exit i2c_adap_simtec_exit(void)
> -{
> -	platform_driver_unregister(&simtec_i2c_driver);
> -}
> -
> -module_init(i2c_adap_simtec_init);
> -module_exit(i2c_adap_simtec_exit);
> +module_platform_driver(simtec_i2c_driver);
>  
>  MODULE_DESCRIPTION("Simtec Generic I2C Bus driver");
>  MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
>  MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:simtec-i2c");

> (...)
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

This one would be better as a separate patch, as it touches a different
subdirectory, which I am responsible for.

-- 
Jean Delvare
