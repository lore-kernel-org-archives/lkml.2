Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab1F3Pto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 11:49:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53977 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1F3Ptn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 11:49:43 -0400
Date: Thu, 30 Jun 2011 17:49:39 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ARM i.MX23/28: platform-mxsfb: Add missing include of
 linux/dma-mapping.h
Message-ID: <20110630154939.GN11559@pengutronix.de>
References: <1309440903.22791.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1309440903.22791.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 09:35:03PM +0800, Axel Lin wrote:
> Fix below build error:
>   CC      arch/arm/mach-mxs/devices/platform-mxsfb.o
> arch/arm/mach-mxs/devices/platform-mxsfb.c: In function 'mx23_add_mxsfb':
> arch/arm/mach-mxs/devices/platform-mxsfb.c:27: error: implicit declaration of function 'DMA_BIT_MASK'
> make[2]: *** [arch/arm/mach-mxs/devices/platform-mxsfb.o] Error 1
> make[1]: *** [arch/arm/mach-mxs/devices] Error 2
> make: *** [arch/arm/mach-mxs] Error 2
I bisected the problem and it occurs since 

	b7f080c (net: remove mm.h inclusion from netdevice.h)

which is currently in next (pulled in via net-next-2.6).

Tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Best regards
Uwe
 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  arch/arm/mach-mxs/devices/platform-mxsfb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-mxs/devices/platform-mxsfb.c b/arch/arm/mach-mxs/devices/platform-mxsfb.c
> index bf72c9b..5a75b71 100644
> --- a/arch/arm/mach-mxs/devices/platform-mxsfb.c
> +++ b/arch/arm/mach-mxs/devices/platform-mxsfb.c
> @@ -5,6 +5,7 @@
>   * the terms of the GNU General Public License version 2 as published by the
>   * Free Software Foundation.
>   */
> +#include <linux/dma-mapping.h>
>  #include <asm/sizes.h>
>  #include <mach/mx23.h>
>  #include <mach/mx28.h>
> -- 
> 1.7.4.1
> 
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
