Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0DVLjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 07:39:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44932 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab0DVLjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 07:39:20 -0400
Date: Thu, 22 Apr 2010 13:39:12 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux@arm.linux.org.uk, Dinh Nguyen <Dinh.Nguyen@freescale.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Fix build error for i.MX51 (mx51_defconfig)
Message-ID: <20100422113912.GP7882@pengutronix.de>
References: <20100421211707.GC2951@matterhorn.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421211707.GC2951@matterhorn.lan>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:38:48 up 33 days, 28 min, 61 users,  load average: 1.79, 1.92,
	2.87
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 12:17:07AM +0300, Amit Kucheria wrote:
> Russell,
> 
> Please apply the following patch to fix build failure for i.MX51 in
> 2.6.34-rc5.

Already queued the same patch from Dinh Nguyen.

Sascha

> 
> Regards,
> Amit
> 
> 
> From 3a30bc0788e02ba069c003d194680a2d39ef1c1a Mon Sep 17 00:00:00 2001
> Message-Id: <3a30bc0788e02ba069c003d194680a2d39ef1c1a.1271883980.git.amit.kucheria@canonical.com>
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> Date: Tue, 13 Apr 2010 14:05:08 -0500
> Subject: [2.6.34-fixes 1/1] mx5: Fix build error for mx51_defconfig
> 
> Need to include <asm/div64.h> for do_div calls. Fixes the following error:
> 
> arch/arm/mach-mx5/clock-mx51.c: In function 'clk_pll_get_rate':
> arch/arm/mach-mx5/clock-mx51.c:149: error: implicit declaration of function
> 'do_div'
> make[1]: *** [arch/arm/mach-mx5/clock-mx51.o] Error 1
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> ---
>  arch/arm/mach-mx5/clock-mx51.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-mx5/clock-mx51.c b/arch/arm/mach-mx5/clock-mx51.c
> index 8f85f73..1ee6ce4 100644
> --- a/arch/arm/mach-mx5/clock-mx51.c
> +++ b/arch/arm/mach-mx5/clock-mx51.c
> @@ -16,6 +16,7 @@
>  #include <linux/io.h>
>  
>  #include <asm/clkdev.h>
> +#include <asm/div64.h>
>  
>  #include <mach/hardware.h>
>  #include <mach/common.h>
> -- 
> 1.7.0.4
> 
> 
> -- 
> -------------------------------------------------------------------------
> Amit Kucheria,				 Kernel Developer, Verdurent
> -------------------------------------------------------------------------
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
