Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab2ILVyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 17:54:20 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:55584 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751194Ab2ILVyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 17:54:19 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1++sGfXkEAJZ2s15d9L1M3c
Date: Wed, 12 Sep 2012 14:54:15 -0700
From: Tony Lindgren <tony@atomide.com>
To: Vaibhav Hiremath <hvaibhav@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, paul@pwsan.com
Subject: Re: [PATCH 1/2] ARM: AM33XX: hwmod: Remove platform specific
 header files
Message-ID: <20120912215415.GF5997@atomide.com>
References: <1347484551-11775-1-git-send-email-hvaibhav@ti.com>
 <1347484551-11775-2-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347484551-11775-2-git-send-email-hvaibhav@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vaibhav Hiremath <hvaibhav@ti.com> [120912 14:16]:
> With recent mainline changes on gpio and mcspi drivers, the
> platform specific header files (plat/gpio.h and plat/mcspi.h)
> have been removed, which results into build failure on
> AM33XX hwmod data, which was still using these headers.
> 
> This patch removes such both gpio and spi header file entry
> from omap_hwmod_33xx_data.c.
> 
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> ---
>  arch/arm/mach-omap2/omap_hwmod_33xx_data.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
> index de7a3ab..7b7ed08 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
> @@ -14,12 +14,14 @@
>   * GNU General Public License for more details.
>   */
>  
> +#include <linux/io.h>
> +#include <linux/platform_data/gpio-omap.h>
> +#include <linux/platform_data/spi-omap2-mcspi.h>
> +
>  #include <plat/omap_hwmod.h>
>  #include <plat/cpu.h>
> -#include <plat/gpio.h>
>  #include <plat/dma.h>
>  #include <plat/mmc.h>
> -#include <plat/mcspi.h>
>  #include <plat/i2c.h>
>  
>  #include "omap_hwmod_common_data.h"

This I can fix up when merging Paul's stuff with
sparseirq changes.

Regards,

Tony
