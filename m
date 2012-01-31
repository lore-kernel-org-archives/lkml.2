Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2AaOrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:47:37 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62439 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab2AaOrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:47:36 -0500
Message-ID: <4F27FF00.2040307@samsung.com>
Date: Tue, 31 Jan 2012 23:47:28 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Karol Lewandowski <k.lewandowsk@samsung.com>
CC: thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-samsung-soc@vger.kernel.org, marc.zyngier@arm.com,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH 2/2] ARM: Exynos4: Convert exynos4-dt to CONFIG_MULTI_IRQ_HANDLER
References: <1328006193-13902-1-git-send-email-k.lewandowsk@samsung.com> <1328006193-13902-3-git-send-email-k.lewandowsk@samsung.com>
In-Reply-To: <1328006193-13902-3-git-send-email-k.lewandowsk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/12 19:36, Karol Lewandowski wrote:
> Commit 4e44d2cb95bd ("ARM: exynos4: convert to CONFIG_MULTI_IRQ_HANDLER")
> converted all exynos boards but exynos4-dt.c.
>
> This commit fixes that omission.
>
> Signed-off-by: Karol Lewandowski<k.lewandowsk@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> Cc: Thomas Abraham<thomas.abraham@linaro.org>
> Cc: Kukjin Kim<kgene.kim@samsung.com>
> Cc: Marc Zyngier<marc.zyngier@arm.com>
> ---
>   arch/arm/mach-exynos/mach-exynos4-dt.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c b/arch/arm/mach-exynos/mach-exynos4-dt.c
> index 98e79c9..8aef6aa 100644
> --- a/arch/arm/mach-exynos/mach-exynos4-dt.c
> +++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
> @@ -15,6 +15,7 @@
>   #include<linux/serial_core.h>
>
>   #include<asm/mach/arch.h>
> +#include<asm/hardware/gic.h>
>   #include<mach/map.h>
>
>   #include<plat/cpu.h>
> @@ -83,4 +84,5 @@ DT_MACHINE_START(EXYNOS4210_DT, "Samsung Exynos4 (Flattened Device Tree)")
>   	.init_machine	= exynos4210_dt_machine_init,
>   	.timer		=&exynos4_timer,
>   	.dt_compat	= exynos4210_dt_compat,
> +	.handle_irq	= gic_handle_irq,

This should be added after map_io.

>   MACHINE_END

And as Kyungmin said, we need to fix about restart too. I will apply 
this series together after your submitting.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
