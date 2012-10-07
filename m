Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750981Ab2JGEMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 00:12:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58631 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2JGEMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 00:12:36 -0400
Date: Sun, 7 Oct 2012 12:12:35 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 09/17] ARM: imx: select ARM_CPU_SUSPEND if necessary
Message-ID: <20121007041233.GM20231@S2101-09.ap.freescale.net>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
 <1349195816-2225-10-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349195816-2225-10-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isn't the following the approach we agreed on?

http://thread.gmane.org/gmane.linux.ports.arm.kernel/183222/focus=1348538

Shawn

On Tue, Oct 02, 2012 at 06:36:48PM +0200, Arnd Bergmann wrote:
> As tests using 'make randconfig' showed, imx5 requires the same logic
> as imx6 to select ARM_CPU_SUSPEND when building with power management
> enabled.
> 
> The defconfig does not have this problem because it enables imx6
> as well, but disabling it leads to this warning:
> 
> arch/arm/mach-imx/built-in.o: In function `v7_cpu_resume':
> arch/arm/mach-imx/head-v7.S:104: undefined reference to `cpu_resume'
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: Shawn Guo <shawn.guo@linaro.org>
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
