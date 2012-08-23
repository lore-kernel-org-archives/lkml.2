Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab2HWOy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:54:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33758 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2HWOy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:54:56 -0400
Date: Thu, 23 Aug 2012 22:55:27 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Eric Miao <eric.miao@linaro.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 6/6] ARM: imx: select ARM_CPU_SUSPEND when necessary
Message-ID: <20120823145524.GM24242@S2101-09.ap.freescale.net>
References: <1345648390-4234-1-git-send-email-arnd@arndb.de>
 <1345648390-4234-7-git-send-email-arnd@arndb.de>
 <20120823024119.GD24242@S2101-09.ap.freescale.net>
 <201208231420.50247.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208231420.50247.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 02:20:50PM +0000, Arnd Bergmann wrote:
> From 4036e8f292887e7b1abc8eacec7d619abd608178 Mon Sep 17 00:00:00 2001
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Fri, 17 Aug 2012 00:16:08 +0000
> Subject: [PATCH] ARM: imx: build i.MX6 functions only when needed
> 
> The head-v7.S contains a call to the generic cpu_suspend function,
> which is only available when selected by the i.MX6 code. As
> pointed out by Shawn Guo, i.MX does not actually use any

s/i.MX/i.MX5

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> functions defined in head-v7.S. It is also needed only for
> the i.MX6 power management code and for the SMP code, so
> we can restrict building this file to situations in which
> at least one of those two is present.
> 
> Finally, other platforms with a similar file call it headsmp.S,
> so we can rename it to the same for consistency.
> 
> Without this patch, building imx5 standalone results in:
> 
> arch/arm/mach-imx/built-in.o: In function `v7_cpu_resume':
> arch/arm/mach-imx/head-v7.S:104: undefined reference to `cpu_resume'
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Eric Miao <eric.miao@linaro.org>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: stable@vger.kernel.org
> 
> diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
> index e08adb7..d004d37 100644
> --- a/arch/arm/mach-imx/Makefile
> +++ b/arch/arm/mach-imx/Makefile
> @@ -71,14 +71,13 @@ obj-$(CONFIG_DEBUG_LL) += lluart.o
>  obj-$(CONFIG_HAVE_IMX_GPC) += gpc.o
>  obj-$(CONFIG_HAVE_IMX_MMDC) += mmdc.o
>  obj-$(CONFIG_HAVE_IMX_SRC) += src.o
> -obj-$(CONFIG_CPU_V7) += head-v7.o
> -AFLAGS_head-v7.o :=-Wa,-march=armv7-a
> -obj-$(CONFIG_SMP) += platsmp.o
> +AFLAGS_headsmp.o :=-Wa,-march=armv7-a
> +obj-$(CONFIG_SMP) += headsmp.o platsmp.o
>  obj-$(CONFIG_HOTPLUG_CPU) += hotplug.o
>  obj-$(CONFIG_SOC_IMX6Q) += clk-imx6q.o mach-imx6q.o
>  
>  ifeq ($(CONFIG_PM),y)
> -obj-$(CONFIG_SOC_IMX6Q) += pm-imx6q.o
> +obj-$(CONFIG_SOC_IMX6Q) += pm-imx6q.o headsmp.o
>  endif
>  
>  # i.MX5 based machines
> diff --git a/arch/arm/mach-imx/head-v7.S b/arch/arm/mach-imx/headsmp.S
> similarity index 100%
> rename from arch/arm/mach-imx/head-v7.S
> rename to arch/arm/mach-imx/headsmp.S

-- 
Regards,
Shawn
