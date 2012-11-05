Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab2KEIOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:14:22 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:58266 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab2KEIOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:14:21 -0500
Message-ID: <5097753F.7080307@atmel.com>
Date: Mon, 05 Nov 2012 16:13:51 +0800
From: Josh Wu <josh.wu@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 2/9] ARM: at91: Remove unused struct at91sam9g45_isi_device
 and its resources
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org> <1351980150-24145-3-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1351980150-24145-3-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Lee Jones

On 11/4/2012 6:02 AM, Lee Jones wrote:
> This the at91sam9g45_isi_device structure and its associated resources
> were added in 2008 and have been unused ever since. Let's remove them.

I'm the maintainer of the Atmel ISI driver. Currently the ISI still not 
work on at91sam9263 board.
But this task is in my plan. So keep those code and I will enable ISI 
support for 9263 in the future. Thanks.

Best Regards,
Josh Wu

> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   arch/arm/mach-at91/at91sam9263_devices.c |   20 --------------------
>   1 file changed, 20 deletions(-)
>
> diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
> index cb85da2..0562a9d 100644
> --- a/arch/arm/mach-at91/at91sam9263_devices.c
> +++ b/arch/arm/mach-at91/at91sam9263_devices.c
> @@ -901,26 +901,6 @@ void __init at91_add_device_lcdc(struct atmel_lcdfb_info *data) {}
>   
>   #if defined(CONFIG_VIDEO_AT91_ISI) || defined(CONFIG_VIDEO_AT91_ISI_MODULE)
>   
> -struct resource isi_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9263_BASE_ISI,
> -		.end	= AT91SAM9263_BASE_ISI + SZ_16K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9263_ID_ISI,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9263_ID_ISI,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static struct platform_device at91sam9263_isi_device = {
> -	.name		= "at91_isi",
> -	.id		= -1,
> -	.resource	= isi_resources,
> -	.num_resources	= ARRAY_SIZE(isi_resources),
> -};
> -
>   void __init at91_add_device_isi(struct isi_platform_data *data,
>   		bool use_pck_as_mck)
>   {

