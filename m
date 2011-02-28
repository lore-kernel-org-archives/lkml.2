Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1B1L4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 06:56:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:41881 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab1B1L4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 06:56:18 -0500
Date: Mon, 28 Feb 2011 20:56:12 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH v2 09/09] ARM: s3c2440: gta02: Add touchscreen support
In-reply-to: <1298891846-7487-1-git-send-email-lars@metafoo.de>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Ben Dooks'" <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-id: <003d01cbd73e$80ed2340$82c769c0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcvXOPIYH5b/io5CR1a2EnNKdCh8dAABXBnA
References: <1297043521-21903-9-git-send-email-lars@metafoo.de>
 <1298891846-7487-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars-Peter Clausen wrote:
> 
> This patch adds registers the s3c touchscreen and adc devices to add
> touchscreen
> support for the gta02.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  arch/arm/mach-s3c2440/mach-gta02.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c2440/mach-gta02.c
b/arch/arm/mach-s3c2440/mach-
> gta02.c
> index 640ca68..12193ad 100644
> --- a/arch/arm/mach-s3c2440/mach-gta02.c
> +++ b/arch/arm/mach-s3c2440/mach-gta02.c
> @@ -89,6 +89,8 @@
>  #include <plat/udc.h>
>  #include <plat/gpio-cfg.h>
>  #include <plat/iic.h>
> +#include <plat/ts.h>
> +
> 
>  static struct pcf50633 *gta02_pcf;
> 
> @@ -480,6 +482,13 @@ static struct s3c2410_hcd_info gta02_usb_info
__initdata
> = {
>  	},
>  };
> 
> +/* Touchscreen */
> +static struct s3c2410_ts_mach_info gta02_ts_info = {
> +	.delay			= 10000,
> +	.presc			= 0xff, /* slow as we can go */
> +	.oversampling_shift	= 2,
> +};
> +
>  /* Buttons */
>  static struct gpio_keys_button gta02_buttons[] = {
>  	{
> @@ -533,6 +542,8 @@ static struct platform_device *gta02_devices[]
__initdata
> = {
>  	&samsung_asoc_dma,
>  	&s3c_device_i2c0,
>  	&gta02_buttons_device,
> +	&s3c_device_adc,
> +	&s3c_device_ts,
>  };
> 
>  /* These guys DO need to be children of PMU. */
> @@ -595,6 +606,7 @@ static void __init gta02_machine_init(void)
>  #endif
> 
>  	s3c24xx_udc_set_platdata(&gta02_udc_cfg);
> +	s3c24xx_ts_set_platdata(&gta02_ts_info);
>  	s3c_ohci_set_platdata(&gta02_usb_info);
>  	s3c_nand_set_platdata(&gta02_nand_info);
>  	s3c_i2c0_set_platdata(NULL);
> --
> 1.7.2.3

Ok, applied.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

