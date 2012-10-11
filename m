Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690Ab2JKHi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 03:38:29 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63008 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624Ab2JKHiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 03:38:25 -0400
Date: Thu, 11 Oct 2012 08:38:20 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de
Subject: Re: [PATCH 3/6] ARM: ux500: Add support for ST-Ericsson's u9540 SoC
Message-ID: <20121011073820.GS9707@gmail.com>
References: <1349882335-6786-1-git-send-email-lee.jones@linaro.org>
 <1349882335-6786-4-git-send-email-lee.jones@linaro.org>
 <20121010190144.GS12801@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121010190144.GS12801@game.jcrosoft.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:

> On 16:18 Wed 10 Oct     , Lee Jones wrote:
> > First level board support for the u9540.
> > 
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/mach-ux500/cpu-db8500.c |   14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
> > index 3d8e321..6b7f970 100644
> > --- a/arch/arm/mach-ux500/cpu-db8500.c
> > +++ b/arch/arm/mach-ux500/cpu-db8500.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/platform_device.h>
> >  #include <linux/io.h>
> >  #include <linux/mfd/abx500/ab8500.h>
> > +#include <linux/mfd/dbx500-prcmu.h>
> >  #include <linux/of.h>
> >  #include <linux/of_platform.h>
> >  #include <linux/regulator/machine.h>
> > @@ -319,6 +320,8 @@ static void __init u8500_init_machine(void)
> >  		snowball_pinmaps_init();
> >  	else if (of_machine_is_compatible("st-ericsson,hrefv60+"))
> >  		hrefv60_pinmaps_init();
> > +	else if (of_machine_is_compatible("st-ericsson,u9540")) {}
> > +		/* TODO: Add u9540 pinmaps. */
> do you via DT no here

We don't support pinctrl yet. It will come, it's just not available yet.

> >  	/* TODO: Export SoC, USB, cpu-freq and DMA40 */
> >  	parent = u8500_of_init_devices();
> > @@ -331,6 +334,7 @@ static const char * u8500_dt_board_compat[] = {
> >  	"calaosystems,snowball-a9500",
> >  	"st-ericsson,hrefv60+",
> >  	"st-ericsson,mop500",
> > +	"st-ericsson,u9540",
> stop to add more compatible sue a more generic one

Not entirely sure what you mean here.

These are the only four boards we officially support.

There are other uXXXX boards that we do not.

> >  	NULL,
> >  };
> >  
> > @@ -345,4 +349,14 @@ DT_MACHINE_START(U8500_DT, "ST-Ericsson U8500 platform (Device Tree Support)")
> >  	.dt_compat      = u8500_dt_board_compat,
> >  MACHINE_END
> >  
> > +DT_MACHINE_START(U9540_DT, "ST-Ericsson 9540 platform (Device Tree Support)")
> > +	.map_io		= u8500_map_io,
> > +	.init_irq	= ux500_init_irq,
> > +	.timer		= &ux500_timer,
> > +	.handle_irq	= gic_handle_irq,
> > +	.init_machine	= u8500_init_machine,
> > +	.init_late	= NULL,
> > +	.dt_compat      = u8500_dt_board_compat,
> > +MACHINE_END
> really?
> no need drop it for a more generic on

This may look the same as the previous MACHINE_START now, but
it will have differences in the future as more u9540 support is
upstreamed. I think it should stick around as a separate entity
for the time being. If we can consolidate the init functions at
a later date, believe me I will make sure it happens.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
