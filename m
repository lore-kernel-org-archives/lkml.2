Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2AMIpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 03:45:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:19146 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2AMIpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 03:45:35 -0500
X-AuditID: cbfee60f-b7bceae00000240c-80-4f0fef2b6ea7
Date: Fri, 13 Jan 2012 08:45:31 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 2/2] backlight: Convert backlight spi drivers to
 module_spi_driver
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Jingoo Han <jg1.han@samsung.com>, Eric Miao <eric.y.miao@gmail.com>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Donghwa Lee <dh09.lee@samsung.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>,
        In-Ki Dae <inki.dae@samsung.com>,
        Dmitry Baryshkov <dbaryshkov@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20120113084313022@jg1.han
Msgkey: 20120113084313022@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120113084313022@jg1.han
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <19063628.205041326444330971.JavaMail.weblogic@epml26>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0D8jlpn028052

Hi, Axel Lin.
> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@gmail.com]
> Sent: Friday, January 13, 2012 5:38 PM
> To: linux-kernel@vger.kernel.org
> Cc: Jingoo Han; Eric Miao; Alberto Panizzo; Donghwa Lee; Marek Vasut; Haavard Skinnemoen; InKi Dae;
> Dmitry Baryshkov; Ben Dooks; Richard Purdie; Andrew Morton
> Subject: [PATCH 2/2] backlight: Convert backlight spi drivers to module_spi_driver
> 
> Factor out some boilerplate code for spi driver registration into
> module_spi_driver.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Jingoo Han <jg1.han@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>
Thank you.

> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> Cc: Donghwa Lee <dh09.lee@samsung.com>
> Cc: Marek Vasut <marek.vasut@gmail.com>
> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
> Cc: InKi Dae <inki.dae@samsung.com>
> Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
>  drivers/video/backlight/ams369fg06.c  |   13 +------------
>  drivers/video/backlight/corgi_lcd.c   |   12 +-----------
>  drivers/video/backlight/l4f00242t03.c |   13 +------------
>  drivers/video/backlight/ld9040.c      |   13 +------------
>  drivers/video/backlight/lms283gf05.c  |   13 +------------
>  drivers/video/backlight/ltv350qv.c    |   12 +-----------
>  drivers/video/backlight/s6e63m0.c     |   13 +------------
>  drivers/video/backlight/tdo24m.c      |   12 +-----------
>  drivers/video/backlight/tosa_lcd.c    |   13 +------------
>  drivers/video/backlight/vgg2432a4.c   |   15 +--------------
>  10 files changed, 10 insertions(+), 119 deletions(-)
> 
> diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
> index 7838a23..7bdadc7 100644
> --- a/drivers/video/backlight/ams369fg06.c
> +++ b/drivers/video/backlight/ams369fg06.c
> @@ -629,18 +629,7 @@ static struct spi_driver ams369fg06_driver = {
>  	.resume		= ams369fg06_resume,
>  };
> 
> -static int __init ams369fg06_init(void)
> -{
> -	return spi_register_driver(&ams369fg06_driver);
> -}
> -
> -static void __exit ams369fg06_exit(void)
> -{
> -	spi_unregister_driver(&ams369fg06_driver);
> -}
> -
> -module_init(ams369fg06_init);
> -module_exit(ams369fg06_exit);
> +module_spi_driver(ams369fg06_driver);
> 
>  MODULE_AUTHOR("Jingoo Han <jg1.han@samsung.com>");
>  MODULE_DESCRIPTION("ams369fg06 LCD Driver");
> diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
> index c6533ba..6dab13f 100644
> --- a/drivers/video/backlight/corgi_lcd.c
> +++ b/drivers/video/backlight/corgi_lcd.c
> @@ -629,17 +629,7 @@ static struct spi_driver corgi_lcd_driver = {
>  	.resume		= corgi_lcd_resume,
>  };
> 
> -static int __init corgi_lcd_init(void)
> -{
> -	return spi_register_driver(&corgi_lcd_driver);
> -}
> -module_init(corgi_lcd_init);
> -
> -static void __exit corgi_lcd_exit(void)
> -{
> -	spi_unregister_driver(&corgi_lcd_driver);
> -}
> -module_exit(corgi_lcd_exit);
> +module_spi_driver(corgi_lcd_driver);
> 
>  MODULE_DESCRIPTION("LCD and backlight driver for SHARP C7x0/Cxx00");
>  MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>");
> diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
> index 4f5d1c4..fae421a 100644
> --- a/drivers/video/backlight/l4f00242t03.c
> +++ b/drivers/video/backlight/l4f00242t03.c
> @@ -272,18 +272,7 @@ static struct spi_driver l4f00242t03_driver = {
>  	.shutdown	= l4f00242t03_shutdown,
>  };
> 
> -static __init int l4f00242t03_init(void)
> -{
> -	return spi_register_driver(&l4f00242t03_driver);
> -}
> -
> -static __exit void l4f00242t03_exit(void)
> -{
> -	spi_unregister_driver(&l4f00242t03_driver);
> -}
> -
> -module_init(l4f00242t03_init);
> -module_exit(l4f00242t03_exit);
> +module_spi_driver(l4f00242t03_driver);
> 
>  MODULE_AUTHOR("Alberto Panizzo <maramaopercheseimorto@gmail.com>");
>  MODULE_DESCRIPTION("EPSON L4F00242T03 LCD");
> diff --git a/drivers/video/backlight/ld9040.c b/drivers/video/backlight/ld9040.c
> index 78dafc0..efd352b 100644
> --- a/drivers/video/backlight/ld9040.c
> +++ b/drivers/video/backlight/ld9040.c
> @@ -856,18 +856,7 @@ static struct spi_driver ld9040_driver = {
>  	.resume		= ld9040_resume,
>  };
> 
> -static int __init ld9040_init(void)
> -{
> -	return spi_register_driver(&ld9040_driver);
> -}
> -
> -static void __exit ld9040_exit(void)
> -{
> -	spi_unregister_driver(&ld9040_driver);
> -}
> -
> -module_init(ld9040_init);
> -module_exit(ld9040_exit);
> +module_spi_driver(ld9040_driver);
> 
>  MODULE_AUTHOR("Donghwa Lee <dh09.lee@samsung.com>");
>  MODULE_DESCRIPTION("ld9040 LCD Driver");
> diff --git a/drivers/video/backlight/lms283gf05.c b/drivers/video/backlight/lms283gf05.c
> index 4ec78cf..4161f9e 100644
> --- a/drivers/video/backlight/lms283gf05.c
> +++ b/drivers/video/backlight/lms283gf05.c
> @@ -226,18 +226,7 @@ static struct spi_driver lms283gf05_driver = {
>  	.remove		= __devexit_p(lms283gf05_remove),
>  };
> 
> -static __init int lms283gf05_init(void)
> -{
> -	return spi_register_driver(&lms283gf05_driver);
> -}
> -
> -static __exit void lms283gf05_exit(void)
> -{
> -	spi_unregister_driver(&lms283gf05_driver);
> -}
> -
> -module_init(lms283gf05_init);
> -module_exit(lms283gf05_exit);
> +module_spi_driver(lms283gf05_driver);
> 
>  MODULE_AUTHOR("Marek Vasut <marek.vasut@gmail.com>");
>  MODULE_DESCRIPTION("LCD283GF05 LCD");
> diff --git a/drivers/video/backlight/ltv350qv.c b/drivers/video/backlight/ltv350qv.c
> index cca43c0..333949f 100644
> --- a/drivers/video/backlight/ltv350qv.c
> +++ b/drivers/video/backlight/ltv350qv.c
> @@ -321,17 +321,7 @@ static struct spi_driver ltv350qv_driver = {
>  	.resume		= ltv350qv_resume,
>  };
> 
> -static int __init ltv350qv_init(void)
> -{
> -	return spi_register_driver(&ltv350qv_driver);
> -}
> -
> -static void __exit ltv350qv_exit(void)
> -{
> -	spi_unregister_driver(&ltv350qv_driver);
> -}
> -module_init(ltv350qv_init);
> -module_exit(ltv350qv_exit);
> +module_spi_driver(ltv350qv_driver);
> 
>  MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
>  MODULE_DESCRIPTION("Samsung LTV350QV LCD Driver");
> diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
> index e132157..9b0092e 100644
> --- a/drivers/video/backlight/s6e63m0.c
> +++ b/drivers/video/backlight/s6e63m0.c
> @@ -909,18 +909,7 @@ static struct spi_driver s6e63m0_driver = {
>  	.resume		= s6e63m0_resume,
>  };
> 
> -static int __init s6e63m0_init(void)
> -{
> -	return spi_register_driver(&s6e63m0_driver);
> -}
> -
> -static void __exit s6e63m0_exit(void)
> -{
> -	spi_unregister_driver(&s6e63m0_driver);
> -}
> -
> -module_init(s6e63m0_init);
> -module_exit(s6e63m0_exit);
> +module_spi_driver(s6e63m0_driver);
> 
>  MODULE_AUTHOR("InKi Dae <inki.dae@samsung.com>");
>  MODULE_DESCRIPTION("S6E63M0 LCD Driver");
> diff --git a/drivers/video/backlight/tdo24m.c b/drivers/video/backlight/tdo24m.c
> index 1997e12..2368b8e 100644
> --- a/drivers/video/backlight/tdo24m.c
> +++ b/drivers/video/backlight/tdo24m.c
> @@ -459,17 +459,7 @@ static struct spi_driver tdo24m_driver = {
>  	.resume		= tdo24m_resume,
>  };
> 
> -static int __init tdo24m_init(void)
> -{
> -	return spi_register_driver(&tdo24m_driver);
> -}
> -module_init(tdo24m_init);
> -
> -static void __exit tdo24m_exit(void)
> -{
> -	spi_unregister_driver(&tdo24m_driver);
> -}
> -module_exit(tdo24m_exit);
> +module_spi_driver(tdo24m_driver);
> 
>  MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>");
>  MODULE_DESCRIPTION("Driver for Toppoly TDO24M LCD Panel");
> diff --git a/drivers/video/backlight/tosa_lcd.c b/drivers/video/backlight/tosa_lcd.c
> index 772f601..a2161f6 100644
> --- a/drivers/video/backlight/tosa_lcd.c
> +++ b/drivers/video/backlight/tosa_lcd.c
> @@ -285,18 +285,7 @@ static struct spi_driver tosa_lcd_driver = {
>  	.resume		= tosa_lcd_resume,
>  };
> 
> -static int __init tosa_lcd_init(void)
> -{
> -	return spi_register_driver(&tosa_lcd_driver);
> -}
> -
> -static void __exit tosa_lcd_exit(void)
> -{
> -	spi_unregister_driver(&tosa_lcd_driver);
> -}
> -
> -module_init(tosa_lcd_init);
> -module_exit(tosa_lcd_exit);
> +module_spi_driver(tosa_lcd_driver);
> 
>  MODULE_AUTHOR("Dmitry Baryshkov");
>  MODULE_LICENSE("GPL v2");
> diff --git a/drivers/video/backlight/vgg2432a4.c b/drivers/video/backlight/vgg2432a4.c
> index b49063c..b617fae 100644
> --- a/drivers/video/backlight/vgg2432a4.c
> +++ b/drivers/video/backlight/vgg2432a4.c
> @@ -262,20 +262,7 @@ static struct spi_driver vgg2432a4_driver = {
>  	.resume		= vgg2432a4_resume,
>  };
> 
> -/* Device driver initialisation */
> -
> -static int __init vgg2432a4_init(void)
> -{
> -	return spi_register_driver(&vgg2432a4_driver);
> -}
> -
> -static void __exit vgg2432a4_exit(void)
> -{
> -	spi_unregister_driver(&vgg2432a4_driver);
> -}
> -
> -module_init(vgg2432a4_init);
> -module_exit(vgg2432a4_exit);
> +module_spi_driver(vgg2432a4_driver);
> 
>  MODULE_AUTHOR("Ben Dooks <ben-linux@fluff.org>");
>  MODULE_DESCRIPTION("VGG2432A4 LCD Driver");
> --
> 1.7.5.4
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
