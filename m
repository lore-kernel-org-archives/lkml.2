Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1B1GqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 01:46:11 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:46738 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab1B1GqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 01:46:10 -0500
Date: Mon, 28 Feb 2011 15:37:54 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 03/09] ARM: s3c2440: gta02: Add button support
In-reply-to: <1297043521-21903-3-git-send-email-lars@metafoo.de>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Ben Dooks'" <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-id: <000601cbd712$092d7bb0$1b887310$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcvGaWsLRylo1u1uTqqAFBsKss/6owQqIlIw
References: <1297043521-21903-1-git-send-email-lars@metafoo.de>
 <1297043521-21903-3-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars-Peter Clausen wrote:
> 
> This patch adds support for the two buttons found on the gta02 device,
which
> are
> connectd to gpio pins, using the gpio-keys driver.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  arch/arm/mach-s3c2440/mach-gta02.c |   34
++++++++++++++++++++++++++++++++++
>  1 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c2440/mach-gta02.c
b/arch/arm/mach-s3c2440/mach-
> gta02.c
> index e83062b..6629998 100644
> --- a/arch/arm/mach-s3c2440/mach-gta02.c
> +++ b/arch/arm/mach-s3c2440/mach-gta02.c
> @@ -58,6 +58,9 @@
>  #include <linux/mfd/pcf50633/pmic.h>
>  #include <linux/mfd/pcf50633/backlight.h>
> 
> +#include <linux/input.h>
> +#include <linux/gpio_keys.h>
> +
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
> @@ -489,6 +492,36 @@ static struct s3c2410_hcd_info gta02_usb_info
__initdata
> = {
>  	},
>  };
> 
> +/* Buttons */
> +static struct gpio_keys_button gta02_buttons[] = {
> +	{
> +		.gpio = GTA02_GPIO_AUX_KEY,
> +		.code = KEY_PHONE,
> +		.desc = "Aux",
> +		.type = EV_KEY,
> +		.debounce_interval = 100,
> +	},
> +	{
> +		.gpio = GTA02_GPIO_HOLD_KEY,
> +		.code = KEY_PAUSE,
> +		.desc = "Hold",
> +		.type = EV_KEY,
> +		.debounce_interval = 100,
> +	},
> +};
> +
> +static struct gpio_keys_platform_data gta02_buttons_pdata = {
> +	.buttons = gta02_buttons,
> +	.nbuttons = ARRAY_SIZE(gta02_buttons),
> +};
> +
> +static struct platform_device gta02_buttons_device = {
> +	.name = "gpio-keys",
> +	.id = -1,
> +	.dev = {
> +		.platform_data = &gta02_buttons_pdata,
> +	},
> +};
> 
>  static void __init gta02_map_io(void)
>  {
> @@ -511,6 +544,7 @@ static struct platform_device *gta02_devices[]
__initdata
> = {
>  	&s3c_device_iis,
>  	&samsung_asoc_dma,
>  	&s3c_device_i2c0,
> +	&gta02_buttons_device,
>  };
> 
>  /* These guys DO need to be children of PMU. */
> --

Ok, will apply.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

