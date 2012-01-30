Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab2A3FYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 00:24:53 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:47228 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751663Ab2A3FYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 00:24:52 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+sS7ATaY+s9/233I2st6C+U+1uvMKKoiCBowKzas
	0J/lH0jpOvkJDZ
Message-ID: <4F262998.4090207@gmx.de>
Date: Mon, 30 Jan 2012 05:24:40 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Imre Deak <imre.deak@nokia.com>,
        Roger Quadros <roger.quadros@nokia.com>,
        Steve Sakoman <steve@sakoman.com>, Erik Gilling <konkers@android.com>,
        Gra Ignotas <notasas@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] video: convert drivers/video/* to use module_spi_driver()
References: <1327651374.7772.1.camel@phoenix>
In-Reply-To: <1327651374.7772.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 08:02 AM, Axel Lin wrote:
> This patch converts the drivers in drivers/video/* to use the
> module_spi_driver() macro which makes the code smaller and a bit simpler.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Imre Deak <imre.deak@nokia.com>
> Cc: Roger Quadros <roger.quadros@nokia.com>
> Cc: Steve Sakoman <steve@sakoman.com>
> Cc: Erik Gilling <konkers@android.com>
> Cc: Gražvydas Ignotas <notasas@gmail.com>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/omap/lcd_mipid.c                     |   14 +-------------
>  drivers/video/omap2/displays/panel-acx565akm.c     |   13 +------------
>  .../omap2/displays/panel-lgphilips-lb035q02.c      |   12 +-----------
>  .../omap2/displays/panel-nec-nl8048hl11-01b.c      |   12 +-----------
>  .../video/omap2/displays/panel-tpo-td043mtea1.c    |   13 +------------
>  5 files changed, 5 insertions(+), 59 deletions(-)
> 
> diff --git a/drivers/video/omap/lcd_mipid.c b/drivers/video/omap/lcd_mipid.c
> index 8d546dd..e3880c4 100644
> --- a/drivers/video/omap/lcd_mipid.c
> +++ b/drivers/video/omap/lcd_mipid.c
> @@ -609,19 +609,7 @@ static struct spi_driver mipid_spi_driver = {
>  	.remove	= __devexit_p(mipid_spi_remove),
>  };
>  
> -static int __init mipid_drv_init(void)
> -{
> -	spi_register_driver(&mipid_spi_driver);
> -
> -	return 0;
> -}
> -module_init(mipid_drv_init);
> -
> -static void __exit mipid_drv_cleanup(void)
> -{
> -	spi_unregister_driver(&mipid_spi_driver);
> -}
> -module_exit(mipid_drv_cleanup);
> +module_spi_driver(mipid_spi_driver);
>  
>  MODULE_DESCRIPTION("MIPI display driver");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/video/omap2/displays/panel-acx565akm.c b/drivers/video/omap2/displays/panel-acx565akm.c
> index 51a87e1..d26f37a 100644
> --- a/drivers/video/omap2/displays/panel-acx565akm.c
> +++ b/drivers/video/omap2/displays/panel-acx565akm.c
> @@ -809,18 +809,7 @@ static struct spi_driver acx565akm_spi_driver = {
>  	.remove	= __devexit_p(acx565akm_spi_remove),
>  };
>  
> -static int __init acx565akm_init(void)
> -{
> -	return spi_register_driver(&acx565akm_spi_driver);
> -}
> -
> -static void __exit acx565akm_exit(void)
> -{
> -	spi_unregister_driver(&acx565akm_spi_driver);
> -}
> -
> -module_init(acx565akm_init);
> -module_exit(acx565akm_exit);
> +module_spi_driver(acx565akm_spi_driver);
>  
>  MODULE_AUTHOR("Nokia Corporation");
>  MODULE_DESCRIPTION("acx565akm LCD Driver");
> diff --git a/drivers/video/omap2/displays/panel-lgphilips-lb035q02.c b/drivers/video/omap2/displays/panel-lgphilips-lb035q02.c
> index e0eb35b..0841cc2 100644
> --- a/drivers/video/omap2/displays/panel-lgphilips-lb035q02.c
> +++ b/drivers/video/omap2/displays/panel-lgphilips-lb035q02.c
> @@ -264,16 +264,6 @@ static struct spi_driver lb035q02_spi_driver = {
>  	.remove		= __devexit_p(lb035q02_panel_spi_remove),
>  };
>  
> -static int __init lb035q02_panel_drv_init(void)
> -{
> -	return spi_register_driver(&lb035q02_spi_driver);
> -}
> -
> -static void __exit lb035q02_panel_drv_exit(void)
> -{
> -	spi_unregister_driver(&lb035q02_spi_driver);
> -}
> +module_spi_driver(lb035q02_spi_driver);
>  
> -module_init(lb035q02_panel_drv_init);
> -module_exit(lb035q02_panel_drv_exit);
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c b/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c
> index 0eb31ca..8b38b39 100644
> --- a/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c
> +++ b/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c
> @@ -350,18 +350,8 @@ static struct spi_driver nec_8048_spi_driver = {
>  	},
>  };
>  
> -static int __init nec_8048_lcd_init(void)
> -{
> -	return spi_register_driver(&nec_8048_spi_driver);
> -}
> -
> -static void __exit nec_8048_lcd_exit(void)
> -{
> -	return spi_unregister_driver(&nec_8048_spi_driver);
> -}
> +module_spi_driver(nec_8048_spi_driver);
>  
> -module_init(nec_8048_lcd_init);
> -module_exit(nec_8048_lcd_exit);
>  MODULE_AUTHOR("Erik Gilling <konkers@android.com>");
>  MODULE_DESCRIPTION("NEC-nl8048hl11-01b Driver");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/video/omap2/displays/panel-tpo-td043mtea1.c b/drivers/video/omap2/displays/panel-tpo-td043mtea1.c
> index e6649aa..1d6b7fb 100644
> --- a/drivers/video/omap2/displays/panel-tpo-td043mtea1.c
> +++ b/drivers/video/omap2/displays/panel-tpo-td043mtea1.c
> @@ -518,18 +518,7 @@ static struct spi_driver tpo_td043_spi_driver = {
>  	.remove	= __devexit_p(tpo_td043_spi_remove),
>  };
>  
> -static int __init tpo_td043_init(void)
> -{
> -	return spi_register_driver(&tpo_td043_spi_driver);
> -}
> -
> -static void __exit tpo_td043_exit(void)
> -{
> -	spi_unregister_driver(&tpo_td043_spi_driver);
> -}
> -
> -module_init(tpo_td043_init);
> -module_exit(tpo_td043_exit);
> +module_spi_driver(tpo_td043_spi_driver);
>  
>  MODULE_AUTHOR("Gražvydas Ignotas <notasas@gmail.com>");
>  MODULE_DESCRIPTION("TPO TD043MTEA1 LCD Driver");

