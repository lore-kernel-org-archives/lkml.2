Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab1GGHr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 03:47:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35751 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1GGHr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 03:47:57 -0400
Date: Thu, 7 Jul 2011 09:47:55 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 2/3] ARM: mxc: use ARCH_NR_GPIOS to define gpio number
Message-ID: <20110707074755.GX6069@pengutronix.de>
References: <1309970263-13239-1-git-send-email-shawn.guo@linaro.org>
 <1309970263-13239-3-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309970263-13239-3-git-send-email-shawn.guo@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:45:58 up 15 days, 13:33, 34 users,  load average: 0.89, 0.65,
 0.59
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 12:37:42AM +0800, Shawn Guo wrote:
> The patch removes MXC_GPIO_IRQS and instead uses ARCH_NR_GPIOS to
> define gpio number.  This change is need when we change mxc gpio
> driver to be device tree aware.  When migrating the driver to device
> tree, pdev->id becomes unusable.  It requires driver get gpio range
> from gpio core, which will dynamically allocates number from
> ARCH_NR_GPIOS to 0.
> 
> As a bonus point, it removes lines of '#if' and make the code a
> little bit cleaner.  The side effect is the waste of number.  But
> this is not a point when we go single image.

I'm not sure whether we really should depend on an externally defined
ARCH_NR_GPIOS. Someone might get the idea to change this to a lower
value. Maybe we should define this ourselves instead.

Any other opinions?

Otherwise I'm fine with this patch.

Sascha

> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
>  arch/arm/plat-mxc/include/mach/irqs.h |   21 +++------------------
>  1 files changed, 3 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm/plat-mxc/include/mach/irqs.h b/arch/arm/plat-mxc/include/mach/irqs.h
> index 35c89bc..00e812b 100644
> --- a/arch/arm/plat-mxc/include/mach/irqs.h
> +++ b/arch/arm/plat-mxc/include/mach/irqs.h
> @@ -11,6 +11,8 @@
>  #ifndef __ASM_ARCH_MXC_IRQS_H__
>  #define __ASM_ARCH_MXC_IRQS_H__
>  
> +#include <asm-generic/gpio.h>
> +
>  /*
>   * SoCs with TZIC interrupt controller have 128 IRQs, those with AVIC have 64
>   */
> @@ -22,30 +24,13 @@
>  
>  #define MXC_GPIO_IRQ_START	MXC_INTERNAL_IRQS
>  
> -/* these are ordered by size to support multi-SoC kernels */
> -#if defined CONFIG_SOC_IMX53
> -#define MXC_GPIO_IRQS		(32 * 7)
> -#elif defined CONFIG_ARCH_MX2
> -#define MXC_GPIO_IRQS		(32 * 6)
> -#elif defined CONFIG_SOC_IMX50
> -#define MXC_GPIO_IRQS		(32 * 6)
> -#elif defined CONFIG_ARCH_MX1
> -#define MXC_GPIO_IRQS		(32 * 4)
> -#elif defined CONFIG_ARCH_MX25
> -#define MXC_GPIO_IRQS		(32 * 4)
> -#elif defined CONFIG_SOC_IMX51
> -#define MXC_GPIO_IRQS		(32 * 4)
> -#elif defined CONFIG_ARCH_MX3
> -#define MXC_GPIO_IRQS		(32 * 3)
> -#endif
> -
>  /*
>   * The next 16 interrupts are for board specific purposes.  Since
>   * the kernel can only run on one machine at a time, we can re-use
>   * these.  If you need more, increase MXC_BOARD_IRQS, but keep it
>   * within sensible limits.
>   */
> -#define MXC_BOARD_IRQ_START	(MXC_INTERNAL_IRQS + MXC_GPIO_IRQS)
> +#define MXC_BOARD_IRQ_START	(MXC_INTERNAL_IRQS + ARCH_NR_GPIOS)
>  
>  #ifdef CONFIG_MACH_MX31ADS_WM1133_EV1
>  #define MXC_BOARD_IRQS  80
> -- 
> 1.7.4.1
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
