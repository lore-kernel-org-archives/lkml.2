Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab2AFCQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 21:16:10 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:42022 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2AFCQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 21:16:08 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-68-4f065966e076
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, broonie@opensource.wolfsonmicro.com,
        kyungmin.park@samsung.com, cbou@mail.ru, kwangwoo.lee@gmail.com,
        augulis.darius@gmail.com, ben-linux@fluff.org, lars@metafoo.de,
        patches@linaro.org
References: <1325778146-27056-1-git-send-email-thomas.abraham@linaro.org>
In-reply-to: <1325778146-27056-1-git-send-email-thomas.abraham@linaro.org>
Subject: RE: [PATCH] backlight: lcd: add driver for raster-type lcd's with gpio
 controlled panel reset
Date: Fri, 06 Jan 2012 11:16:06 +0900
Message-id: <001401cccc19$25b52920$711f7b60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: AczLwA2lMi0W2seQRkG2XLj4MxokeQAV2fDg
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Thomas.
> -----Original Message-----
> From: Thomas Abraham [mailto:thomas.abraham@linaro.org]
> Sent: Friday, January 06, 2012 12:42 AM
> Subject: [PATCH] backlight: lcd: add driver for raster-type lcd's with gpio controlled panel reset
> 
> Add a lcd panel driver for simple raster-type lcd's which uses a gpio
> controlled panel reset. The driver controls the nRESET line of the panel
> using a gpio connected from the host system. The Vcc supply to the panel
> is (optionally) controlled using a voltage regulator. This driver excludes
> support for lcd panels that use a serial command interface or direct
> memory mapped IO interface.
> 
> Suggested-by: Lars-Peter Clausen <lars@metafoo.de>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> ---
>  .../devicetree/bindings/lcd/lcd-pwrctrl.txt        |   39 ++++
>  drivers/video/backlight/Kconfig                    |    7 +
>  drivers/video/backlight/Makefile                   |    1 +
>  drivers/video/backlight/lcd_pwrctrl.c              |  231 ++++++++++++++++++++
>  include/video/lcd_pwrctrl.h                        |   30 +++
>  5 files changed, 308 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/lcd/lcd-pwrctrl.txt
>  create mode 100644 drivers/video/backlight/lcd_pwrctrl.c
>  create mode 100644 include/video/lcd_pwrctrl.h
> 
> [...]
> --- a/drivers/video/backlight/Makefile
> +++ b/drivers/video/backlight/Makefile
> @@ -8,6 +8,7 @@ obj-$(CONFIG_LCD_LMS283GF05)	   += lms283gf05.o
>  obj-$(CONFIG_LCD_LTV350QV)	   += ltv350qv.o
>  obj-$(CONFIG_LCD_ILI9320)	   += ili9320.o
>  obj-$(CONFIG_LCD_PLATFORM)	   += platform_lcd.o
> +obj-$(CONFIG_LCD_PWRCTRL) 	   += lcd_pwrctrl.o
Can you remove unnecessary space?
Please use <tab><space><space><space> instead of <space><tab><space><space><space>
between PWRCTRL) and += lcd_.
> [...]
> +static struct platform_driver lcd_pwrctrl_driver = {
> +	.driver		= {
> +		.name	= "lcd-pwrctrl",
> +		.owner	= THIS_MODULE,
> +		.of_match_table	= of_match_ptr(lcd_pwrctrl_match),
> +	},
> +	.probe		= lcd_pwrctrl_probe,
> +	.remove		= lcd_pwrctrl_remove,
> +	.suspend	= lcd_pwrctrl_suspend,
> +	.resume		= lcd_pwrctrl_resume,
Please use 'struct dev_pm_ops'.
> +};
> +
> +static int __init lcd_pwrctrl_init(void)
> +{
> +	return platform_driver_register(&lcd_pwrctrl_driver);
> +}
> +
> +static void __exit lcd_pwrctrl_cleanup(void)
> +{
> +	platform_driver_unregister(&lcd_pwrctrl_driver);
> +}
> +
> +module_init(lcd_pwrctrl_init);
> +module_exit(lcd_pwrctrl_cleanup);
Use module_platform_driver(lcd_pwrctrl_driver).
It can make the code simpler.
> [...]

