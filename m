Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2AaOnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:43:11 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47056 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab2AaOnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:43:09 -0500
Message-ID: <4F27FDF7.8070008@samsung.com>
Date: Tue, 31 Jan 2012 23:43:03 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Karol Lewandowski <k.lewandowsk@samsung.com>
CC: thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-samsung-soc@vger.kernel.org, marc.zyngier@arm.com,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH 1/2] ARM: Exynos4: Make exynos4-dt compile again
References: <1328006193-13902-1-git-send-email-k.lewandowsk@samsung.com> <1328006193-13902-2-git-send-email-k.lewandowsk@samsung.com>
In-Reply-To: <1328006193-13902-2-git-send-email-k.lewandowsk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/12 19:36, Karol Lewandowski wrote:
> Commit cc511b8d84d8 ("ARM: 7257/1: EXYNOS: introduce
> arch/arm/mach-exynos/common.[ch]") replaced plat/exynos4.h with
> common.h, requiring all boards to be adjusted appropriately.
>
> This commit fixes exynos4-dt.c, missed out in original patch.
>
> Signed-off-by: Karol Lewandowski<k.lewandowsk@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> Cc: Thomas Abraham<thomas.abraham@linaro.org>
> Cc: Kukjin Kim<kgene.kim@samsung.com>
> ---
>   arch/arm/mach-exynos/mach-exynos4-dt.c |    5 +++--
>   1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c b/arch/arm/mach-exynos/mach-exynos4-dt.c
> index 85fa027..98e79c9 100644
> --- a/arch/arm/mach-exynos/mach-exynos4-dt.c
> +++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
> @@ -19,7 +19,8 @@
>
>   #include<plat/cpu.h>
>   #include<plat/regs-serial.h>
> -#include<plat/exynos4.h>
> +
> +#include "common.h"
>
>   /*
>    * The following lookup table is used to override device names when devices
> @@ -60,7 +61,7 @@ static const struct of_dev_auxdata exynos4210_auxdata_lookup[] __initconst = {
>
>   static void __init exynos4210_dt_map_io(void)
>   {
> -	s5p_init_io(NULL, 0, S5P_VA_CHIPID);
> +	exynos_init_io(NULL, 0);
>   	s3c24xx_init_clocks(24000000);
>   }
>
Looks ok to me, will apply.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
