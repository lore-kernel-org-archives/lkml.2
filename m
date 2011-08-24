Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab1HXPlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 11:41:42 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:44589 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab1HXPlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 11:41:39 -0400
MIME-Version: 1.0
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Wed, 24 Aug 2011 10:41:17 -0500
Message-ID: <CAKnK67RcMAt6j3CEi2Z7QTN42v07LDCfa_T38F9-5b97TJ0-hA@mail.gmail.com>
Subject: Re: [PATCH 8/8] ARM: S5PV210: example of CMA private area for FIMC
 device on Goni board
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek/Kyungmin,

On Fri, Aug 19, 2011 at 04:27:44PM +0200, Marek Szyprowski wrote:
> This patch is an example how device private CMA area can be activated.
> It creates one CMA region and assigns it to the first s5p-fimc device on
> Samsung Goni S5PC110 board.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/mach-s5pv210/mach-goni.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
> index 14578f5..f766c45 100644
> --- a/arch/arm/mach-s5pv210/mach-goni.c
> +++ b/arch/arm/mach-s5pv210/mach-goni.c
> @@ -26,6 +26,7 @@
>  #include <linux/input.h>
>  #include <linux/gpio.h>
>  #include <linux/interrupt.h>
> +#include <linux/dma-contiguous.h>
>
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
> @@ -857,6 +858,9 @@ static void __init goni_map_io(void)
>  static void __init goni_reserve(void)
>  {
>  	s5p_mfc_reserve_mem(0x43000000, 8 << 20, 0x51000000, 8 << 20);
> +
> +	/* Create private 16MiB contiguous memory area for s5p-fimc.0 device */
> +	dma_declare_contiguous(&s5p_device_fimc0.dev, 16*SZ_1M, 0);

This is broken, since according to patch #0006, dma_declare_contiguous requires
a 4th param (limit) which you're not providing here.

Regards,
Sergio

>  }
>
>  static void __init goni_machine_init(void)
> --
> 1.7.1.569.g6f426
