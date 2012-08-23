Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab2HWCkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:40:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54692 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab2HWCkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:40:51 -0400
Date: Thu, 23 Aug 2012 10:41:23 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Eric Miao <eric.miao@linaro.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 6/6] ARM: imx: select ARM_CPU_SUSPEND when necessary
Message-ID: <20120823024119.GD24242@S2101-09.ap.freescale.net>
References: <1345648390-4234-1-git-send-email-arnd@arndb.de>
 <1345648390-4234-7-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345648390-4234-7-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 05:13:10PM +0200, Arnd Bergmann wrote:
> On i.MX6, we select ARM_CPU_SUSPEND when building with power management
> support, but for some reason this was omitted on i.MX5. Normally we
> build kernels for both together so the error only showed up in
> randconfig tests.
> 
> Without this patch, building imx5 standalone results in:
> 
> arch/arm/mach-imx/built-in.o: In function `v7_cpu_resume':
> arch/arm/mach-imx/head-v7.S:104: undefined reference to `cpu_resume'
> 
So far, none of the functions in head-v7.S is used on imx5.  Also
since imx5 SoCs implement State Retention Power Gating in hardware,
ARM_CPU_SUSPEND support will never be used on imx5.

Maybe we should make head-v7.S only compile for imx6?

Regards,
Shawn

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Eric Miao <eric.miao@linaro.org>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm/mach-imx/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index afd542a..8e96573 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -89,6 +89,7 @@ config SOC_IMX5
>  	select ARCH_MXC_IOMUX_V3
>  	select ARCH_HAS_CPUFREQ
>  	select ARCH_MX5
> +	select ARM_CPU_SUSPEND if PM
>  	bool
>  
>  config SOC_IMX50
> -- 
> 1.7.10
> 
