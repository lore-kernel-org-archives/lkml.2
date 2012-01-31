Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab2AaOqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:46:54 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45390 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab2AaOqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:46:53 -0500
MIME-Version: 1.0
In-Reply-To: <1328006193-13902-3-git-send-email-k.lewandowsk@samsung.com>
References: <1328006193-13902-1-git-send-email-k.lewandowsk@samsung.com>
	<1328006193-13902-3-git-send-email-k.lewandowsk@samsung.com>
Date: Tue, 31 Jan 2012 20:16:52 +0530
Message-ID: <CAJuYYwQvGDwCTcSNQVVjsPS8kbRkbnUyybjD6=mRv6nwhRwzdQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: Exynos4: Convert exynos4-dt to CONFIG_MULTI_IRQ_HANDLER
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: m.szyprowski@samsung.com, linux-samsung-soc@vger.kernel.org,
        marc.zyngier@arm.com, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 January 2012 16:06, Karol Lewandowski <k.lewandowsk@samsung.com> wrote:
> Commit 4e44d2cb95bd ("ARM: exynos4: convert to CONFIG_MULTI_IRQ_HANDLER")
> converted all exynos boards but exynos4-dt.c.
>
> This commit fixes that omission.
>
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/mach-exynos/mach-exynos4-dt.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c b/arch/arm/mach-exynos/mach-exynos4-dt.c
> index 98e79c9..8aef6aa 100644
> --- a/arch/arm/mach-exynos/mach-exynos4-dt.c
> +++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
> @@ -15,6 +15,7 @@
>  #include <linux/serial_core.h>
>
>  #include <asm/mach/arch.h>
> +#include <asm/hardware/gic.h>
>  #include <mach/map.h>
>
>  #include <plat/cpu.h>
> @@ -83,4 +84,5 @@ DT_MACHINE_START(EXYNOS4210_DT, "Samsung Exynos4 (Flattened Device Tree)")
>        .init_machine   = exynos4210_dt_machine_init,
>        .timer          = &exynos4_timer,
>        .dt_compat      = exynos4210_dt_compat,
> +       .handle_irq     = gic_handle_irq,
>  MACHINE_END

Tested along with the restart hook as suggested by Mr. Park.

Tested-by: Thomas Abraham@linaro.org

Thanks,
Thomas.

> --
> 1.7.8.3
>
