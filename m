Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab2CLEWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 00:22:19 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55280 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab2CLEWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 00:22:11 -0400
MIME-Version: 1.0
In-Reply-To: <4F5D1661.4090007@samsung.com>
References: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org>
	<1331469965-28846-4-git-send-email-thomas.abraham@linaro.org>
	<4F5D1661.4090007@samsung.com>
Date: Mon, 12 Mar 2012 09:52:10 +0530
Message-ID: <CAJuYYwQPrOte4EjpfBbUW0vg+qFJwYgZcSM88iZ95C8LwWuptg@mail.gmail.com>
Subject: Re: [PATCH 3/5] ARM: Exynos4: Add pinctrl devices and pin maps
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linus.walleij@linaro.org,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/12 Kukjin Kim <kgene.kim@samsung.com>:
> Thomas Abraham wrote:
>> Add the three pinctrl platform devices and the pin maps for Exynos4.
>>
>> Signed-off-by: Thomas Abraham<thomas.abraham@linaro.org>
>> ---
>>   arch/arm/mach-exynos/Kconfig              |    1 +
>>   arch/arm/mach-exynos/Makefile             |    1 +
>>   arch/arm/mach-exynos/common.h             |    6 ++
>>   arch/arm/mach-exynos/dev-pinctrl.c        |  115 +++++++++++++++++++++++++++++
>>   arch/arm/plat-samsung/include/plat/devs.h |    3 +
>>   5 files changed, 126 insertions(+), 0 deletions(-)
>>   create mode 100644 arch/arm/mach-exynos/dev-pinctrl.c
>
> [...]
>
>> +#include<linux/kernel.h>
>> +#include<linux/dma-mapping.h>
>> +#include<linux/platform_device.h>
>> +#include<linux/interrupt.h>
>> +#include<linux/pinctrl/machine.h>
>
> #include <linux/ioport.h> for DEFINE_RES_xxx at below.
>
>> +
>> +#include<plat/devs.h>
>> +#include<plat/pinctrl.h>
>> +
>> +#include<mach/map.h>
>> +
>> +static struct resource exynos4_pinctrl_resource0[] = {
>> +     [0] = {
>> +             .start  = EXYNOS4_PA_GPIO1,
>> +             .end    = EXYNOS4_PA_GPIO1 + SZ_4K - 1,
>> +             .flags  = IORESOURCE_MEM,
>> +     },
>
> [0] = DEFINE_RES_MEM(EXYNOS4_PA_GPIO1, SZ_4K),
>
>> +     [1] = {
>> +             .start  = IRQ_GPIO_XA,
>> +             .end    = IRQ_GPIO_XA,
>> +             .flags  = IORESOURCE_IRQ,
>> +     },
>
> [1] = DEFINE_RES_IRQ(IRQ_GPIO_XA),
>
> But I'm thinking, we need to move to use EXYNOS4_IRQ_GPIO_XA here for
> both EXYNOS4 and EXYNOS5 and as a note, I'm working on updating IRQ
> naming you can see it in this week :)

Thanks for reviewing this patch series. I will use DEFINE_RES_xxx for
resource instantiation.

Regards,
Thomas.

[...]
