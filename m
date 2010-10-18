Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab0JRN3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 09:29:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57648 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab0JRN3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 09:29:08 -0400
Date: Mon, 18 Oct 2010 22:29:26 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 3/9] ARM: S3C64XX: add touchscreen support for mach-real6410
In-reply-to: <20100929193322.25307.67196.stgit@darius-desktop>
To: "'Darius Augulis'" <augulis.darius@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Cc: paulius.zaleckas@gmail.com, linux-kernel@vger.kernel.org,
        ben-linux@fluff.org
Message-id: <04a501cb6ec8$7e719a80$7b54cf80$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=utf-8
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActgDTpZyzd++4tAQJmH7IaBJ2OZLgOur4xQ
References: <20100929192354.25307.40197.stgit@darius-desktop>
 <20100929193322.25307.67196.stgit@darius-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darius Augulis wrote:
> 
> Add touchscreen device support for mach-real6410
> 
> Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
> ---
>  arch/arm/mach-s3c64xx/Kconfig         |    2 ++
>  arch/arm/mach-s3c64xx/mach-real6410.c |   11 +++++++++++
>  2 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
> index e4aede1..b706b80 100644
> --- a/arch/arm/mach-s3c64xx/Kconfig
> +++ b/arch/arm/mach-s3c64xx/Kconfig
> @@ -107,6 +107,8 @@ config MACH_REAL6410
>  	select S3C_DEV_FB
>  	select S3C64XX_SETUP_FB_24BPP
>  	select S3C_DEV_NAND
> +	select SAMSUNG_DEV_ADC
> +	select SAMSUNG_DEV_TS
>  	help
>  	  Machine support for the CoreWind REAL6410
> 
> diff --git a/arch/arm/mach-s3c64xx/mach-real6410.c b/arch/arm/mach-
> s3c64xx/mach-real6410.c
> index 9fd943d..bad6990 100644
> --- a/arch/arm/mach-s3c64xx/mach-real6410.c
> +++ b/arch/arm/mach-s3c64xx/mach-real6410.c
> @@ -36,11 +36,13 @@
>  #include <mach/regs-srom.h>
>  #include <mach/s3c6410.h>
> 
> +#include <plat/adc.h>
>  #include <plat/cpu.h>
>  #include <plat/devs.h>
>  #include <plat/fb.h>
>  #include <plat/nand.h>
>  #include <plat/regs-serial.h>
> +#include <plat/ts.h>
> 
>  #include <video/platform_lcd.h>
> 
> @@ -191,6 +193,14 @@ static struct platform_device *real6410_devices[]
> __initdata = {
>  	&s3c_device_hsmmc1,
>  	&s3c_device_fb,
>  	&s3c_device_nand,
> +	&s3c_device_adc,
> +	&s3c_device_ts,
> +};
> +
> +static struct s3c2410_ts_mach_info s3c_ts_platform __initdata = {
> +	.delay			= 10000,
> +	.presc			= 49,
> +	.oversampling_shift	= 2,
>  };
> 
>  static void __init real6410_map_io(void)
> @@ -289,6 +299,7 @@ static void __init real6410_machine_init(void)
> 
>  	s3c_fb_set_platdata(&real6410_lcd_pdata);
>  	s3c_nand_set_platdata(&real6410_nand_info);
> +	s3c24xx_ts_set_platdata(&s3c_ts_platform);
> 
>  	/* configure nCS1 width to 16 bits */
> 

No need to add 's3c_adc_setname("s3c64xx-adc")' in mach-s3c64xx?

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

