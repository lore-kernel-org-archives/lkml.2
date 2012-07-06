Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab2GFJa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:30:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62859 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab2GFJaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:30:21 -0400
Message-ID: <4FF6A2DF.5030407@linaro.org>
Date: Fri, 06 Jul 2012 09:33:35 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, linus.walleij@stericsson.com
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, arnd@arndb.de
Subject: Re: [PATCH 8/9] ARM: ux500: Clean-up temporary Device Tree enablement
 helpers
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org> <1341493572-29735-9-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1341493572-29735-9-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Is this a NAK, or did you just miss it?

On 05/07/12 14:06, Lee Jones wrote:
> Here we remove some of the extra overhead we introduced to make
> DT:ing the Snowball platform easier. Unfortunately we can't
> remove everything. We are forced to leave cpufreq and DMA behind
> until they have been successfully Device Tree enabled.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   arch/arm/mach-ux500/cpu-db8500.c |   10 ++--------
>   1 file changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
> index c8dd94f..d7a28c0 100644
> --- a/arch/arm/mach-ux500/cpu-db8500.c
> +++ b/arch/arm/mach-ux500/cpu-db8500.c
> @@ -137,10 +137,6 @@ static struct platform_device *platform_devs[] __initdata = {
>   	&db8500_prcmu_device,
>   };
>
> -static struct platform_device *of_platform_devs[] __initdata = {
> -	&u8500_dma40_device,
> -};
> -
>   static resource_size_t __initdata db8500_gpio_base[] = {
>   	U8500_GPIOBANK0_BASE,
>   	U8500_GPIOBANK1_BASE,
> @@ -232,7 +228,6 @@ struct device * __init u8500_init_devices(void)
>   struct device * __init u8500_of_init_devices(void)
>   {
>   	struct device *parent;
> -	int i;
>
>   	parent = db8500_soc_device_init();
>
> @@ -241,8 +236,7 @@ struct device * __init u8500_of_init_devices(void)
>   	platform_device_register_data(parent,
>   		"cpufreq-u8500", -1, NULL, 0);
>
> -	for (i = 0; i < ARRAY_SIZE(of_platform_devs); i++)
> -		of_platform_devs[i]->dev.parent = parent;
> +	u8500_dma40_device.dev.parent = parent;
>
>   	/*
>   	 * Devices to be DT:ed:
> @@ -250,7 +244,7 @@ struct device * __init u8500_of_init_devices(void)
>   	 *   db8500_pmu_device   = done
>   	 *   db8500_prcmu_device = done
>   	 */
> -	platform_add_devices(of_platform_devs, ARRAY_SIZE(of_platform_devs));
> +	platform_device_register(&u8500_dma40_device);
>
>   	return parent;
>   }
>


-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


