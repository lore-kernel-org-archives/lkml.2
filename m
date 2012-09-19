Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab2ISTLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:11:10 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:33498 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754843Ab2ISTLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 15:11:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/kKgXosTQW3vnMStpe0U9f
Date: Wed, 19 Sep 2012 12:11:00 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers: bus: Move the OMAP interconnect driver to
 drivers/bus/
Message-ID: <20120919191059.GH11762@atomide.com>
References: <1347614434-15938-1-git-send-email-santosh.shilimkar@ti.com>
 <20120917215128.GF11762@atomide.com>
 <201209191857.57862.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209191857.57862.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [120919 11:59]:
> On Monday 17 September 2012, Tony Lindgren wrote:
> > * Santosh Shilimkar <santosh.shilimkar@ti.com> [120914 02:21]:
> > > OMAP interconnect drivers are used for the interconnect error handling.
> > > Since they are bus driver, lets move it to newly created drivers/bus.
> > > 
> > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > Cc: Tony Lindgren <tony@atomide.com>
> > > Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
> > > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > > ---
> > > Patch just moves OMAP interconnect drivers as is to the newly created
> > > driver/bus/* directory. Patch is generated against "arm-soc/drivers/ocp2scp"
> > > tree and test on all OMAP boards.
> > 
> > Great, looks like this should not conflict with other
> > omap patches queued, so Arnd should probably take this into
> > the bus branch:
> > 
> > Acked-by: Tony Lindgren <tony@atomide.com>
> 
> It turns out that the patch actually did conflict and we now have a broken
> omap2plus_defconfig. The patch below seems to fix it, but please verify
> that this makes sense.

Heh a conflict caused by hard coded irqs for the error message :)
Looks like a good fix that removes some unncecessary dependencies:

Acked-by: Tony Lindgren <tony@atomide.com>
 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
> index f447e02..ab911a3 100644
> --- a/drivers/bus/omap_l3_noc.c
> +++ b/drivers/bus/omap_l3_noc.c
> @@ -28,7 +28,6 @@
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
>  
> -#include "soc.h"
>  #include "omap_l3_noc.h"
>  
>  /*
> @@ -191,7 +190,7 @@ static int __devinit omap4_l3_probe(struct platform_device *pdev)
>  			IRQF_DISABLED, "l3-dbg-irq", l3);
>  	if (ret) {
>  		pr_crit("L3: request_irq failed to register for 0x%x\n",
> -						9 + OMAP44XX_IRQ_GIC_START);
> +						l3->debug_irq);
>  		goto err3;
>  	}
>  
> @@ -201,7 +200,7 @@ static int __devinit omap4_l3_probe(struct platform_device *pdev)
>  			IRQF_DISABLED, "l3-app-irq", l3);
>  	if (ret) {
>  		pr_crit("L3: request_irq failed to register for 0x%x\n",
> -						10 + OMAP44XX_IRQ_GIC_START);
> +						l3->app_irq);
>  		goto err4;
>  	}
>  
