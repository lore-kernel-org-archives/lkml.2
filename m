Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2KZPyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 10:54:09 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:27682 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751589Ab2KZPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 10:54:07 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18IPUbttQ9p+fo4fwmVTu7W
Date: Mon, 26 Nov 2012 07:53:58 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lokesh Vutla <lokeshvutla@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 omap_dss2 tree
Message-ID: <20121126155358.GH5279@atomide.com>
References: <20121126215600.236b2e44ffea1abbea26898b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126215600.236b2e44ffea1abbea26898b@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [121126 02:58]:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/plat-omap/common.c between commit b022e17b1c7e ("OMAP: common.c:
> remove init call to vram") from the omap_dss2 tree and commit
> f583f0f2c720 ("ARM: OMAP2+: Move omap_reserve() locally to mach-omap2")
> from the arm-soc tree.
> 
> I fixed it up (by deleting the file and adding the following patch) and
> can carry the fix as necessary (no action is required).

Thanks this is the correct fix.

Tony
 
> From 523f2987a07f97c946c63e0be4558b8332b46e8f Mon Sep 17 00:00:00 2001
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 26 Nov 2012 21:51:20 +1100
> Subject: [PATCH] OMAP: common.c: remove init call to vram fixup
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/arm/mach-omap2/common.c |    3 ---
>  1 file changed, 3 deletions(-)
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
> 1.7.10.280.gaa39
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


