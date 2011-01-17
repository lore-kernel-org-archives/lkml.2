Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab1AQAuI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 19:50:08 -0500
Received: from trinity.fluff.org ([89.16.178.74]:49273 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab1AQAuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 19:50:06 -0500
Date: Mon, 17 Jan 2011 00:49:59 +0000
From: Ben Dooks <ben@trinity.fluff.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: linux-next: manual merge of the bjdooks-i2c tree with Linus'
	tree
Message-ID: <20110117004958.GC5432@trinity.fluff.org>
References: <20110117111700.7fefe690.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110117111700.7fefe690.sfr@canb.auug.org.au>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 11:17:00AM +1100, Stephen Rothwell wrote:
> Hi Ben,
> 
> Today's linux-next merge of the bjdooks-i2c tree got a conflict in
> arch/arm/mach-pxa/pxa27x.c between commit
> a3f4c927d379cfaa597bc8ff75dc9d28f8d9200e ("ARM: PXA SoCs: irq_data
> conversion") from Linus' tree and commit
> 0a56f28ec486273d84d25571573908344aa67176 ("arm/pxa2xx: reorganize I2C
> files") from the bjdooks-i2c tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.
> 
> Ben, is that stuff going into 2.6.38?  If so, please get Linus to pull it
> as it has quite a few conflicts (especially this one commit) ...

I'll check with RMK on this and sort it out tomorrow.
 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mach-pxa/pxa27x.c
> index 987301f,1c77e89..0000000
> --- a/arch/arm/mach-pxa/pxa27x.c
> +++ b/arch/arm/mach-pxa/pxa27x.c
> @@@ -17,10 -17,8 +17,11 @@@
>   #include <linux/suspend.h>
>   #include <linux/platform_device.h>
>   #include <linux/sysdev.h>
>  +#include <linux/io.h>
>  +#include <linux/irq.h>
> + #include <linux/i2c/pxa-i2c.h>
>   
>  +#include <asm/mach/map.h>
>   #include <mach/hardware.h>
>   #include <asm/irq.h>
>   #include <mach/irqs.h>
> @@@ -30,10 -28,7 +31,8 @@@
>   #include <mach/ohci.h>
>   #include <mach/pm.h>
>   #include <mach/dma.h>
>  +#include <mach/smemc.h>
>   
> - #include <plat/i2c.h>
> - 
>   #include "generic.h"
>   #include "devices.h"
>   #include "clock.h"

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

