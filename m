Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab2CXJXj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 05:23:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49051 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab2CXJXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 05:23:38 -0400
Date: Sat, 24 Mar 2012 09:23:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: mathieu.poirier@linaro.org
Cc: tony@atomide.com, linux-omap@vger.kernel.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/9] ARM: omap2/n8x0: work around modular omap mmc
Message-ID: <20120324092316.GA22608@n2100.arm.linux.org.uk>
References: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org> <1332522836-29517-4-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332522836-29517-4-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 11:13:50AM -0600, mathieu.poirier@linaro.org wrote:
> From: Russell King <linux@arm.linux.org.uk>

This is wrong.  I am not the author of this patch.

> When the omap driver is built as a module for n8x0,
> n8x0_mmc_set_power_menelaus cannot call into the driver:
> 
> arch/arm/mach-omap2/board-n8x0.c:374: undefined reference
> to `omap_mmc_notify_cover_event'
> 
> As a workaround, do not provide that device in this case. This needs
> to be fixed properly, e.g. by converting n8x0 to be probed through the
> device tree and moving that code into the driver.
> 
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Suggested-by: Russell King <linux@arm.linux.org.uk>
> Acked-by: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/mach-omap2/board-n8x0.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
> index 6722627..8529ca0 100644
> --- a/arch/arm/mach-omap2/board-n8x0.c
> +++ b/arch/arm/mach-omap2/board-n8x0.c
> @@ -193,8 +193,10 @@ static struct omap_onenand_platform_data board_onenand_data[] = {
>  };
>  #endif
>  
> -#if defined(CONFIG_MENELAUS) &&						\
> -	(defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE))
> +#ifdef CONFIG_MMC_OMAP_MODULE
> +#warning FIXME: cannot call omap_mmc_notify_cover_event for CONFIG_MMC_OMAP_MODULE
> +#endif
> +#if defined(CONFIG_MENELAUS) && (defined(CONFIG_MMC_OMAP)
>  
>  /*
>   * On both N800 and N810, only the first of the two MMC controllers is in use.
> -- 
> 1.7.5.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
