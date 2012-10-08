Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab2JHSJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 14:09:15 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:15491 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754561Ab2JHSJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 14:09:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+A0ujlPesbVSBS6D7k+tDC
Date: Mon, 8 Oct 2012 11:09:00 -0700
From: Tony Lindgren <tony@atomide.com>
To: linux-arm-kernel@lists.infradead.org
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Deepak Saxena <dsaxena@plexity.net>, Chris Ball <cjb@laptop.org>,
        Matt Mackall <mpm@selenic.com>, Venkatraman S <svenkatr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: OMAP: Trivial driver changes to remove
 include plat/cpu.h
Message-ID: <20121008180900.GL3874@atomide.com>
References: <20121008173452.10603.53886.stgit@muffinssi>
 <20121008173557.10603.18539.stgit@muffinssi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121008173557.10603.18539.stgit@muffinssi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [121008 10:37]:
> Drivers should not use cpu_is_omap or cpu_class_is_omap macros,
> they should be private to the platform init code. And we'll be
> removing plat/cpu.h and only have a private soc.h for the
> arch/arm/*omap* code.
> 
> This patch is intended as preparation for the core omap changes
> and removes the need to include plat/cpu.h from several drivers.
> This is needed for the ARM common zImage support.
> 
> These changes are OK to do because:
> 
> - omap-rng.c and hsmmc.c don't need plat/cpu.h
> 
> - omap-aes.c and omap-sham.c get the proper platform_data
>   passed to them so they don't need extra checks in the driver
> 
> - omap-dma.c and omap-pcm.c can test the arch locally as
>   omap1 and omap2 cannot be compiled together because of
>   conflicting compiler flags


> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -40,7 +40,6 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/platform_data/mmc-omap.h>
>  #include <mach/hardware.h>
> -#include <plat/cpu.h>
>  
>  /* OMAP HSMMC Host Controller Registers */
>  #define OMAP_HSMMC_SYSSTATUS	0x0014

Actually I'll fold this mmc change into an earlier patch
I've posted as "ARM: OMAP: Split plat/mmc.h into local headers
and platform_data".

Regards,

Tony
