Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab2LPRsd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:48:33 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:49959 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752736Ab2LPRsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:48:31 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/nw037py/XTj73K+91KVe6
Date: Sun, 16 Dec 2012 09:48:25 -0800
From: Tony Lindgren <tony@atomide.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Russell King <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ARM: OMAP2+: common: remove use of vram
Message-ID: <20121216174824.GB18490@atomide.com>
References: <1355626132-32117-1-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355626132-32117-1-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Javier Martinez Canillas <javier.martinez@collabora.co.uk> [121215 18:52]:
> commit 966458f OMAP: remove vram allocator
> 
> Removed the OMAP specific vram allocator but OMAP2 common was
> still trying to use it and this lead to the following build error:
> 
> CC      arch/arm/mach-omap2/common.o
> arch/arm/mach-omap2/common.c:19:23: fatal error: plat/vram.h: No such file or directory
> compilation terminated.
> make[1]: *** [arch/arm/mach-omap2/common.o] Error 1
> make: *** [arch/arm/mach-omap2] Error 2

OK looks like this got missed in the merge notes from Tomi, will
apply.

Thanks,

Ton
 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  arch/arm/mach-omap2/common.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/common.c b/arch/arm/mach-omap2/common.c
> index 5c2fd48..2dabb9e 100644
> --- a/arch/arm/mach-omap2/common.c
> +++ b/arch/arm/mach-omap2/common.c
> @@ -16,8 +16,6 @@
>  #include <linux/init.h>
>  #include <linux/platform_data/dsp-omap.h>
>  
> -#include <plat/vram.h>
> -
>  #include "common.h"
>  #include "omap-secure.h"
>  
> @@ -32,7 +30,6 @@ int __weak omap_secure_ram_reserve_memblock(void)
>  
>  void __init omap_reserve(void)
>  {
> -	omap_vram_reserve_sdram_memblock();
>  	omap_dsp_reserve_sdram_memblock();
>  	omap_secure_ram_reserve_memblock();
>  	omap_barrier_reserve_memblock();
> -- 
> 1.7.7.6
> 
