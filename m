Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab0JTJB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 05:01:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35013 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab0JTJBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 05:01:24 -0400
Date: Wed, 20 Oct 2010 11:01:22 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        daniel@caiaq.de, xiao-lizhang@freescale.com,
        valentin.longchamp@epfl.ch
Subject: Re: [PATCH] ARM: imx: change mx51.h into mx5x.h
Message-ID: <20101020090122.GH28166@pengutronix.de>
References: <1287525423-22329-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287525423-22329-1-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dinh,

On Tue, Oct 19, 2010 at 04:57:03PM -0500, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> In preparation for submitting i.MX53 support, change mx51.h to
> mx5x.h so that mx5x.h can contain MX53 information as well.
Last time I found time to clean up the imx ports I worked hard that e.g.
mx27 machines only used MX27_ prefixed symbols, not the MX2x_ ones.  (I
don't remember off-hand if I was done, so there might be a few users
left.)

I'd prefer to just add an mx53.h instead.

> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/mach-mx5/devices-imx51.h                 |    2 +-
>  arch/arm/plat-mxc/include/mach/debug-macro.S      |    2 +-
>  arch/arm/plat-mxc/include/mach/hardware.h         |    2 +-
>  arch/arm/plat-mxc/include/mach/{mx51.h => mx5x.h} |    0
BTW, this is wrong, at least the header guard needs updating when you
rename the file.

>  4 files changed, 3 insertions(+), 3 deletions(-)
>  rename arch/arm/plat-mxc/include/mach/{mx51.h => mx5x.h} (100%)
> 
> diff --git a/arch/arm/mach-mx5/devices-imx51.h b/arch/arm/mach-mx5/devices-imx51.h
> index 5cc910e..f6abe2d 100644
> --- a/arch/arm/mach-mx5/devices-imx51.h
> +++ b/arch/arm/mach-mx5/devices-imx51.h
> @@ -6,7 +6,7 @@
>   * the terms of the GNU General Public License version 2 as published by the
>   * Free Software Foundation.
>   */
> -#include <mach/mx51.h>
> +#include <mach/mx5x.h>
>  #include <mach/devices-common.h>
>  
>  extern const struct imx_fec_data imx51_fec_data __initconst;
> diff --git a/arch/arm/plat-mxc/include/mach/debug-macro.S b/arch/arm/plat-mxc/include/mach/debug-macro.S
> index 2560640..ac8a2bf 100644
> --- a/arch/arm/plat-mxc/include/mach/debug-macro.S
> +++ b/arch/arm/plat-mxc/include/mach/debug-macro.S
> @@ -49,7 +49,7 @@
>  #ifdef UART_PADDR
>  #error "CONFIG_DEBUG_LL is incompatible with multiple archs"
>  #endif
> -#include <mach/mx51.h>
> +#include <mach/mx5x.h>
>  #define UART_PADDR	MX51_UART1_BASE_ADDR
>  #define UART_VADDR	MX51_AIPS1_IO_ADDRESS(MX51_UART1_BASE_ADDR)
>  #endif
> diff --git a/arch/arm/plat-mxc/include/mach/hardware.h b/arch/arm/plat-mxc/include/mach/hardware.h
> index ebadf4a..5a7395a 100644
> --- a/arch/arm/plat-mxc/include/mach/hardware.h
> +++ b/arch/arm/plat-mxc/include/mach/hardware.h
> @@ -28,7 +28,7 @@
>  	 (addr) - (module ## _BASE_ADDR) + (module ## _BASE_ADDR_VIRT) : 0))
>  
>  #ifdef CONFIG_ARCH_MX5
> -#include <mach/mx51.h>
> +#include <mach/mx5x.h>
>  #endif
>  
>  #ifdef CONFIG_ARCH_MX3
> diff --git a/arch/arm/plat-mxc/include/mach/mx51.h b/arch/arm/plat-mxc/include/mach/mx5x.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/mx51.h
> rename to arch/arm/plat-mxc/include/mach/mx5x.h
> -- 
> 1.6.0.4

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
