Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1LDAie (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 19:38:34 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:57414 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752767Ab1LDAic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 19:38:32 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19d+YUpHQldTT/7oQHXA9YDLxt0JlzV1MZfwzGBhf
	REH9goEVm/xwyF
Message-ID: <4EDAC103.7060503@gmx.de>
Date: Sun, 04 Dec 2011 00:38:27 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Wan ZongShun <mcuos.com@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lennert Buytenhek <buytenh@marvell.com>, Ben Dooks <ben@simtec.co.uk>,
        Alexey Charkov <alchark@gmail.com>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>,
        Manuel Lauss <mano@roarinelk.homelinux.net>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] video: convert drivers/video/* to use module_platform_driver()
References: <1322274354.10633.3.camel@phoenix>
In-Reply-To: <1322274354.10633.3.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2011 02:25 AM, Axel Lin wrote:
> This patch converts the drivers in drivers/video/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Wan ZongShun <mcuos.com@gmail.com>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Lennert Buytenhek <buytenh@marvell.com>
> Cc: Ben Dooks <ben@simtec.co.uk>
> Cc: Alexey Charkov <alchark@gmail.com>
> Cc: Damian Hobson-Garcia <dhobsong@igel.co.jp>
> Cc: Manuel Lauss <mano@roarinelk.homelinux.net>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied this patch.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/mxsfb.c            |   13 +------------
>  drivers/video/nuc900fb.c         |   13 +------------
>  drivers/video/pxa168fb.c         |   12 +-----------
>  drivers/video/pxa3xx-gcu.c       |   15 +--------------
>  drivers/video/s3c-fb.c           |   13 +------------
>  drivers/video/sh7760fb.c         |   13 +------------
>  drivers/video/sh_mobile_lcdcfb.c |   13 +------------
>  drivers/video/sh_mobile_meram.c  |   13 +------------
>  drivers/video/sm501fb.c          |   13 +------------
>  drivers/video/vt8500lcdfb.c      |   13 +------------
>  drivers/video/w100fb.c           |   13 +------------
>  drivers/video/wm8505fb.c         |   13 +------------
>  drivers/video/wmt_ge_rops.c      |   13 +------------
>  drivers/video/xilinxfb.c         |   20 +-------------------
>  14 files changed, 14 insertions(+), 176 deletions(-)
> 
> diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
> index d837d63..18742c2 100644
> --- a/drivers/video/mxsfb.c
> +++ b/drivers/video/mxsfb.c
> @@ -902,18 +902,7 @@ static struct platform_driver mxsfb_driver = {
>  	},
>  };
>  
> -static int __init mxsfb_init(void)
> -{
> -	return platform_driver_register(&mxsfb_driver);
> -}
> -
> -static void __exit mxsfb_exit(void)
> -{
> -	platform_driver_unregister(&mxsfb_driver);
> -}
> -
> -module_init(mxsfb_init);
> -module_exit(mxsfb_exit);
> +module_platform_driver(mxsfb_devtype);
>  
>  MODULE_DESCRIPTION("Freescale mxs framebuffer driver");
>  MODULE_AUTHOR("Sascha Hauer, Pengutronix");
> diff --git a/drivers/video/nuc900fb.c b/drivers/video/nuc900fb.c
> index d1fbbd8..e10f551 100644
> --- a/drivers/video/nuc900fb.c
> +++ b/drivers/video/nuc900fb.c
> @@ -762,18 +762,7 @@ static struct platform_driver nuc900fb_driver = {
>  	},
>  };
>  
> -int __devinit nuc900fb_init(void)
> -{
> -	return platform_driver_register(&nuc900fb_driver);
> -}
> -
> -static void __exit nuc900fb_cleanup(void)
> -{
> -	platform_driver_unregister(&nuc900fb_driver);
> -}
> -
> -module_init(nuc900fb_init);
> -module_exit(nuc900fb_cleanup);
> +module_platform_driver(nuc900fb_driver);
>  
>  MODULE_DESCRIPTION("Framebuffer driver for the NUC900");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/video/pxa168fb.c b/drivers/video/pxa168fb.c
> index 18ead6f..8384b94 100644
> --- a/drivers/video/pxa168fb.c
> +++ b/drivers/video/pxa168fb.c
> @@ -832,17 +832,7 @@ static struct platform_driver pxa168fb_driver = {
>  	.remove		= __devexit_p(pxa168fb_remove),
>  };
>  
> -static int __init pxa168fb_init(void)
> -{
> -	return platform_driver_register(&pxa168fb_driver);
> -}
> -module_init(pxa168fb_init);
> -
> -static void __exit pxa168fb_exit(void)
> -{
> -	platform_driver_unregister(&pxa168fb_driver);
> -}
> -module_exit(pxa168fb_exit);
> +module_platform_driver(pxa168fb_driver);
>  
>  MODULE_AUTHOR("Lennert Buytenhek <buytenh@marvell.com> "
>  	      "Green Wan <gwan@marvell.com>");
> diff --git a/drivers/video/pxa3xx-gcu.c b/drivers/video/pxa3xx-gcu.c
> index 1ed8b36..1d71c08 100644
> --- a/drivers/video/pxa3xx-gcu.c
> +++ b/drivers/video/pxa3xx-gcu.c
> @@ -747,20 +747,7 @@ static struct platform_driver pxa3xx_gcu_driver = {
>  	},
>  };
>  
> -static int __init
> -pxa3xx_gcu_init(void)
> -{
> -	return platform_driver_register(&pxa3xx_gcu_driver);
> -}
> -
> -static void __exit
> -pxa3xx_gcu_exit(void)
> -{
> -	platform_driver_unregister(&pxa3xx_gcu_driver);
> -}
> -
> -module_init(pxa3xx_gcu_init);
> -module_exit(pxa3xx_gcu_exit);
> +module_platform_driver(pxa3xx_gcu_driver);
>  
>  MODULE_DESCRIPTION("PXA3xx graphics controller unit driver");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
> index 12eaee0..cf1d11f 100644
> --- a/drivers/video/s3c-fb.c
> +++ b/drivers/video/s3c-fb.c
> @@ -2003,18 +2003,7 @@ static struct platform_driver s3c_fb_driver = {
>  	},
>  };
>  
> -static int __init s3c_fb_init(void)
> -{
> -	return platform_driver_register(&s3c_fb_driver);
> -}
> -
> -static void __exit s3c_fb_cleanup(void)
> -{
> -	platform_driver_unregister(&s3c_fb_driver);
> -}
> -
> -module_init(s3c_fb_init);
> -module_exit(s3c_fb_cleanup);
> +module_platform_driver(s3c_fb_driver);
>  
>  MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
>  MODULE_DESCRIPTION("Samsung S3C SoC Framebuffer driver");
> diff --git a/drivers/video/sh7760fb.c b/drivers/video/sh7760fb.c
> index 45e47d8..83b16e2 100644
> --- a/drivers/video/sh7760fb.c
> +++ b/drivers/video/sh7760fb.c
> @@ -585,18 +585,7 @@ static struct platform_driver sh7760_lcdc_driver = {
>  	.remove = __devexit_p(sh7760fb_remove),
>  };
>  
> -static int __init sh7760fb_init(void)
> -{
> -	return platform_driver_register(&sh7760_lcdc_driver);
> -}
> -
> -static void __exit sh7760fb_exit(void)
> -{
> -	platform_driver_unregister(&sh7760_lcdc_driver);
> -}
> -
> -module_init(sh7760fb_init);
> -module_exit(sh7760fb_exit);
> +module_platform_driver(sh7760_lcdc_driver);
>  
>  MODULE_AUTHOR("Nobuhiro Iwamatsu, Manuel Lauss");
>  MODULE_DESCRIPTION("FBdev for SH7760/63 integrated LCD Controller");
> diff --git a/drivers/video/sh_mobile_lcdcfb.c b/drivers/video/sh_mobile_lcdcfb.c
> index 1f49ab4..a264ebf 100644
> --- a/drivers/video/sh_mobile_lcdcfb.c
> +++ b/drivers/video/sh_mobile_lcdcfb.c
> @@ -1709,18 +1709,7 @@ static struct platform_driver sh_mobile_lcdc_driver = {
>  	.remove		= sh_mobile_lcdc_remove,
>  };
>  
> -static int __init sh_mobile_lcdc_init(void)
> -{
> -	return platform_driver_register(&sh_mobile_lcdc_driver);
> -}
> -
> -static void __exit sh_mobile_lcdc_exit(void)
> -{
> -	platform_driver_unregister(&sh_mobile_lcdc_driver);
> -}
> -
> -module_init(sh_mobile_lcdc_init);
> -module_exit(sh_mobile_lcdc_exit);
> +module_platform_driver(sh_mobile_lcdc_driver);
>  
>  MODULE_DESCRIPTION("SuperH Mobile LCDC Framebuffer driver");
>  MODULE_AUTHOR("Magnus Damm <damm@opensource.se>");
> diff --git a/drivers/video/sh_mobile_meram.c b/drivers/video/sh_mobile_meram.c
> index 4d63490..f45d83e 100644
> --- a/drivers/video/sh_mobile_meram.c
> +++ b/drivers/video/sh_mobile_meram.c
> @@ -679,18 +679,7 @@ static struct platform_driver sh_mobile_meram_driver = {
>  	.remove		= sh_mobile_meram_remove,
>  };
>  
> -static int __init sh_mobile_meram_init(void)
> -{
> -	return platform_driver_register(&sh_mobile_meram_driver);
> -}
> -
> -static void __exit sh_mobile_meram_exit(void)
> -{
> -	platform_driver_unregister(&sh_mobile_meram_driver);
> -}
> -
> -module_init(sh_mobile_meram_init);
> -module_exit(sh_mobile_meram_exit);
> +module_platform_driver(sh_mobile_meram_driver);
>  
>  MODULE_DESCRIPTION("SuperH Mobile MERAM driver");
>  MODULE_AUTHOR("Damian Hobson-Garcia / Takanari Hayama");
> diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
> index a78254c..3690eff 100644
> --- a/drivers/video/sm501fb.c
> +++ b/drivers/video/sm501fb.c
> @@ -2230,18 +2230,7 @@ static struct platform_driver sm501fb_driver = {
>  	},
>  };
>  
> -static int __devinit sm501fb_init(void)
> -{
> -	return platform_driver_register(&sm501fb_driver);
> -}
> -
> -static void __exit sm501fb_cleanup(void)
> -{
> -	platform_driver_unregister(&sm501fb_driver);
> -}
> -
> -module_init(sm501fb_init);
> -module_exit(sm501fb_cleanup);
> +module_platform_driver(sm501fb_driver);
>  
>  module_param_named(mode, fb_mode, charp, 0);
>  MODULE_PARM_DESC(mode,
> diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
> index 777c21d..2a5fe6e 100644
> --- a/drivers/video/vt8500lcdfb.c
> +++ b/drivers/video/vt8500lcdfb.c
> @@ -457,18 +457,7 @@ static struct platform_driver vt8500lcd_driver = {
>  	},
>  };
>  
> -static int __init vt8500lcd_init(void)
> -{
> -	return platform_driver_register(&vt8500lcd_driver);
> -}
> -
> -static void __exit vt8500lcd_exit(void)
> -{
> -	platform_driver_unregister(&vt8500lcd_driver);
> -}
> -
> -module_init(vt8500lcd_init);
> -module_exit(vt8500lcd_exit);
> +module_platform_driver(vt8500lcd_driver);
>  
>  MODULE_AUTHOR("Alexey Charkov <alchark@gmail.com>");
>  MODULE_DESCRIPTION("LCD controller driver for VIA VT8500");
> diff --git a/drivers/video/w100fb.c b/drivers/video/w100fb.c
> index 2375e5b..90a2e30 100644
> --- a/drivers/video/w100fb.c
> +++ b/drivers/video/w100fb.c
> @@ -1620,18 +1620,7 @@ static struct platform_driver w100fb_driver = {
>  	},
>  };
>  
> -int __init w100fb_init(void)
> -{
> -	return platform_driver_register(&w100fb_driver);
> -}
> -
> -void __exit w100fb_cleanup(void)
> -{
> -	platform_driver_unregister(&w100fb_driver);
> -}
> -
> -module_init(w100fb_init);
> -module_exit(w100fb_cleanup);
> +module_platform_driver(w100fb_driver);
>  
>  MODULE_DESCRIPTION("ATI Imageon w100 framebuffer driver");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
> index 96e34a5..c8703bd 100644
> --- a/drivers/video/wm8505fb.c
> +++ b/drivers/video/wm8505fb.c
> @@ -404,18 +404,7 @@ static struct platform_driver wm8505fb_driver = {
>  	},
>  };
>  
> -static int __init wm8505fb_init(void)
> -{
> -	return platform_driver_register(&wm8505fb_driver);
> -}
> -
> -static void __exit wm8505fb_exit(void)
> -{
> -	platform_driver_unregister(&wm8505fb_driver);
> -}
> -
> -module_init(wm8505fb_init);
> -module_exit(wm8505fb_exit);
> +module_platform_driver(wm8505fb_driver);
>  
>  MODULE_AUTHOR("Ed Spiridonov <edo.rus@gmail.com>");
>  MODULE_DESCRIPTION("Framebuffer driver for WMT WM8505");
> diff --git a/drivers/video/wmt_ge_rops.c b/drivers/video/wmt_ge_rops.c
> index 45832b7..55be386 100644
> --- a/drivers/video/wmt_ge_rops.c
> +++ b/drivers/video/wmt_ge_rops.c
> @@ -167,18 +167,7 @@ static struct platform_driver wmt_ge_rops_driver = {
>  	},
>  };
>  
> -static int __init wmt_ge_rops_init(void)
> -{
> -	return platform_driver_register(&wmt_ge_rops_driver);
> -}
> -
> -static void __exit wmt_ge_rops_exit(void)
> -{
> -	platform_driver_unregister(&wmt_ge_rops_driver);
> -}
> -
> -module_init(wmt_ge_rops_init);
> -module_exit(wmt_ge_rops_exit);
> +module_platform_driver(wmt_ge_rops_driver);
>  
>  MODULE_AUTHOR("Alexey Charkov <alchark@gmail.com");
>  MODULE_DESCRIPTION("Accelerators for raster operations using "
> diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
> index fcb6cd9..1808452 100644
> --- a/drivers/video/xilinxfb.c
> +++ b/drivers/video/xilinxfb.c
> @@ -511,25 +511,7 @@ static struct platform_driver xilinxfb_of_driver = {
>  	},
>  };
>  
> -
> -/* ---------------------------------------------------------------------
> - * Module setup and teardown
> - */
> -
> -static int __init
> -xilinxfb_init(void)
> -{
> -	return platform_driver_register(&xilinxfb_of_driver);
> -}
> -
> -static void __exit
> -xilinxfb_cleanup(void)
> -{
> -	platform_driver_unregister(&xilinxfb_of_driver);
> -}
> -
> -module_init(xilinxfb_init);
> -module_exit(xilinxfb_cleanup);
> +module_platform_driver(xilinxfb_of_driver);
>  
>  MODULE_AUTHOR("MontaVista Software, Inc. <source@mvista.com>");
>  MODULE_DESCRIPTION("Xilinx TFT frame buffer driver");

