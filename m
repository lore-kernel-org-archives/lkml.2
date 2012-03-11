Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab2CKVRe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 17:17:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58804 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab2CKVR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 17:17:28 -0400
Message-ID: <4F5D1661.4090007@samsung.com>
Date: Sun, 11 Mar 2012 14:17:21 -0700
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Thomas Abraham <thomas.abraham@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linus.walleij@linaro.org,
        kgene.kim@samsung.com, patches@linaro.org
Subject: Re: [PATCH 3/5] ARM: Exynos4: Add pinctrl devices and pin maps
References: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org> <1331469965-28846-4-git-send-email-thomas.abraham@linaro.org>
In-Reply-To: <1331469965-28846-4-git-send-email-thomas.abraham@linaro.org>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Abraham wrote:
> Add the three pinctrl platform devices and the pin maps for Exynos4.
> 
> Signed-off-by: Thomas Abraham<thomas.abraham@linaro.org>
> ---
>   arch/arm/mach-exynos/Kconfig              |    1 +
>   arch/arm/mach-exynos/Makefile             |    1 +
>   arch/arm/mach-exynos/common.h             |    6 ++
>   arch/arm/mach-exynos/dev-pinctrl.c        |  115 +++++++++++++++++++++++++++++
>   arch/arm/plat-samsung/include/plat/devs.h |    3 +
>   5 files changed, 126 insertions(+), 0 deletions(-)
>   create mode 100644 arch/arm/mach-exynos/dev-pinctrl.c

[...]

> +#include<linux/kernel.h>
> +#include<linux/dma-mapping.h>
> +#include<linux/platform_device.h>
> +#include<linux/interrupt.h>
> +#include<linux/pinctrl/machine.h>

#include <linux/ioport.h> for DEFINE_RES_xxx at below.

> +
> +#include<plat/devs.h>
> +#include<plat/pinctrl.h>
> +
> +#include<mach/map.h>
> +
> +static struct resource exynos4_pinctrl_resource0[] = {
> +	[0] = {
> +		.start  = EXYNOS4_PA_GPIO1,
> +		.end    = EXYNOS4_PA_GPIO1 + SZ_4K - 1,
> +		.flags  = IORESOURCE_MEM,
> +	},

[0] = DEFINE_RES_MEM(EXYNOS4_PA_GPIO1, SZ_4K),

> +	[1] = {
> +		.start  = IRQ_GPIO_XA,
> +		.end    = IRQ_GPIO_XA,
> +		.flags  = IORESOURCE_IRQ,
> +	},

[1] = DEFINE_RES_IRQ(IRQ_GPIO_XA),

But I'm thinking, we need to move to use EXYNOS4_IRQ_GPIO_XA here for
both EXYNOS4 and EXYNOS5 and as a note, I'm working on updating IRQ
naming you can see it in this week :)

> +};
> +
> +struct platform_device exynos4_pinctrl0 = {
> +	.name		= "exynos4-pinctrl",
> +	.id		= 0,
> +	.resource	= exynos4_pinctrl_resource0,
> +	.num_resources	= ARRAY_SIZE(exynos4_pinctrl_resource0),
> +};
> +
> +static struct resource exynos4_pinctrl_resource1[] = {
> +	[0] = {
> +		.start  = EXYNOS4_PA_GPIO2,
> +		.end    = EXYNOS4_PA_GPIO2 + SZ_4K - 1,
> +		.flags  = IORESOURCE_MEM,
> +	},

same as above.

> +	[1] = {
> +		.start  = IRQ_GPIO_XB,
> +		.end    = IRQ_GPIO_XB,
> +		.flags  = IORESOURCE_IRQ,
> +	},

same.

> +};
> +
> +struct platform_device exynos4_pinctrl1 = {
> +	.name		= "exynos4-pinctrl",
> +	.id		= 1,
> +	.resource	= exynos4_pinctrl_resource1,
> +	.num_resources	= ARRAY_SIZE(exynos4_pinctrl_resource1),
> +};
> +
> +static struct resource exynos4_pinctrl_resource2[] = {
> +	[0] = {
> +		.start  = EXYNOS4_PA_GPIO3,
> +		.end    = EXYNOS4_PA_GPIO3 + SZ_4K - 1,
> +		.flags  = IORESOURCE_MEM,
> +	},

same.

> +};
> +
> +struct platform_device exynos4_pinctrl2 = {
> +	.name		= "exynos4-pinctrl",
> +	.id		= 2,
> +	.resource	= exynos4_pinctrl_resource2,
> +	.num_resources	= ARRAY_SIZE(exynos4_pinctrl_resource2),
> +};
> +

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
