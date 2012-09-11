Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab2IKNfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:35:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53004 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757693Ab2IKNfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:35:46 -0400
Date: Tue, 11 Sep 2012 15:35:31 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 06/16] ARM: netx: move platform_data definitions
Message-ID: <20120911133531.GA27244@pengutronix.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-6-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347368390-31252-6-git-send-email-arnd@arndb.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:35:19 up 80 days,  4:46, 81 users,  load average: 3.29, 6.08,
 6.16
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 02:59:40PM +0200, Arnd Bergmann wrote:
> Platform data for device drivers should be defined in
> include/linux/platform_data/*.h, not in the architecture
> and platform specific directories.
> 
> This moves such data out of the netx include directories
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Cc: Sascha Hauer <s.hauer@pengutronix.de>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
>  arch/arm/mach-netx/nxdb500.c                                         |    2 +-
>  arch/arm/mach-netx/nxdkn.c                                           |    2 +-
>  arch/arm/mach-netx/nxeb500hmi.c                                      |    2 +-
>  drivers/net/ethernet/netx-eth.c                                      |    2 +-
>  .../include/mach/eth.h => include/linux/platform_data/eth-netx.h     |    0
>  5 files changed, 4 insertions(+), 4 deletions(-)
>  rename arch/arm/mach-netx/include/mach/eth.h => include/linux/platform_data/eth-netx.h (100%)
> 
> diff --git a/arch/arm/mach-netx/nxdb500.c b/arch/arm/mach-netx/nxdb500.c
> index 180ea89..8b781ff 100644
> --- a/arch/arm/mach-netx/nxdb500.c
> +++ b/arch/arm/mach-netx/nxdb500.c
> @@ -30,7 +30,7 @@
>  #include <asm/mach/arch.h>
>  #include <asm/hardware/vic.h>
>  #include <mach/netx-regs.h>
> -#include <mach/eth.h>
> +#include <linux/platform_data/eth-netx.h>
>  
>  #include "generic.h"
>  #include "fb.h"
> diff --git a/arch/arm/mach-netx/nxdkn.c b/arch/arm/mach-netx/nxdkn.c
> index 58009e2..b26dbce 100644
> --- a/arch/arm/mach-netx/nxdkn.c
> +++ b/arch/arm/mach-netx/nxdkn.c
> @@ -30,7 +30,7 @@
>  #include <asm/mach/arch.h>
>  #include <asm/hardware/vic.h>
>  #include <mach/netx-regs.h>
> -#include <mach/eth.h>
> +#include <linux/platform_data/eth-netx.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-netx/nxeb500hmi.c b/arch/arm/mach-netx/nxeb500hmi.c
> index 122e998..257382e 100644
> --- a/arch/arm/mach-netx/nxeb500hmi.c
> +++ b/arch/arm/mach-netx/nxeb500hmi.c
> @@ -30,7 +30,7 @@
>  #include <asm/mach/arch.h>
>  #include <asm/hardware/vic.h>
>  #include <mach/netx-regs.h>
> -#include <mach/eth.h>
> +#include <linux/platform_data/eth-netx.h>
>  
>  #include "generic.h"
>  #include "fb.h"
> diff --git a/drivers/net/ethernet/netx-eth.c b/drivers/net/ethernet/netx-eth.c
> index 9d11ab7..63e7af4 100644
> --- a/drivers/net/ethernet/netx-eth.c
> +++ b/drivers/net/ethernet/netx-eth.c
> @@ -34,7 +34,7 @@
>  #include <mach/netx-regs.h>
>  #include <mach/pfifo.h>
>  #include <mach/xc.h>
> -#include <mach/eth.h>
> +#include <linux/platform_data/eth-netx.h>
>  
>  /* XC Fifo Offsets */
>  #define EMPTY_PTR_FIFO(xcno)    (0 + ((xcno) << 3))	/* Index of the empty pointer FIFO */
> diff --git a/arch/arm/mach-netx/include/mach/eth.h b/include/linux/platform_data/eth-netx.h
> similarity index 100%
> rename from arch/arm/mach-netx/include/mach/eth.h
> rename to include/linux/platform_data/eth-netx.h
> -- 
> 1.7.10
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
