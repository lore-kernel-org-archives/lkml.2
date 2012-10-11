Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab2JKSNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 14:13:31 -0400
Received: from 10.mo4.mail-out.ovh.net ([188.165.33.109]:52297 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755331Ab2JKSNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 14:13:30 -0400
Date: Thu, 11 Oct 2012 20:11:08 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH 3/6] ARM: ux500: Add support for ST-Ericsson's u9540 SoC
Message-ID: <20121011181108.GZ12801@game.jcrosoft.org>
References: <1349882335-6786-1-git-send-email-lee.jones@linaro.org>
 <1349882335-6786-4-git-send-email-lee.jones@linaro.org>
 <20121010190144.GS12801@game.jcrosoft.org>
 <20121011073820.GS9707@gmail.com>
 <20121011085223.GW12801@game.jcrosoft.org>
 <20121011092039.GV9707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011092039.GV9707@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 885801751771261951
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrvdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrvdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:20 Thu 11 Oct     , Lee Jones wrote:
> On Thu, 11 Oct 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> 
> > On 08:38 Thu 11 Oct     , Lee Jones wrote:
> > > On Wed, 10 Oct 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > > 
> > > > On 16:18 Wed 10 Oct     , Lee Jones wrote:
> > > > > First level board support for the u9540.
> > > > > 
> > > > > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > ---
> > > > >  arch/arm/mach-ux500/cpu-db8500.c |   14 ++++++++++++++
> > > > >  1 file changed, 14 insertions(+)
> > > > > 
> > > > > diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
> > > > > index 3d8e321..6b7f970 100644
> > > > > --- a/arch/arm/mach-ux500/cpu-db8500.c
> > > > > +++ b/arch/arm/mach-ux500/cpu-db8500.c
> > > > > @@ -17,6 +17,7 @@
> > > > >  #include <linux/platform_device.h>
> > > > >  #include <linux/io.h>
> > > > >  #include <linux/mfd/abx500/ab8500.h>
> > > > > +#include <linux/mfd/dbx500-prcmu.h>
> > > > >  #include <linux/of.h>
> > > > >  #include <linux/of_platform.h>
> > > > >  #include <linux/regulator/machine.h>
> > > > > @@ -319,6 +320,8 @@ static void __init u8500_init_machine(void)
> > > > >  		snowball_pinmaps_init();
> > > > >  	else if (of_machine_is_compatible("st-ericsson,hrefv60+"))
> > > > >  		hrefv60_pinmaps_init();
> > > > > +	else if (of_machine_is_compatible("st-ericsson,u9540")) {}
> > > > > +		/* TODO: Add u9540 pinmaps. */
> > > > do you via DT no here
> > > 
> > > We don't support pinctrl yet. It will come, it's just not available yet.
> > so stop to add more and update the drviers
> 
> We'll get round to it. 
> 
> We have a set priority list. Neither you nor I have control over that.
yes but code mainline is not driver be politics but by code review

so no do the effort to add the dt to the pinctrl it's 12 hours work so you have
no excuse to delay it again
> 
> > and u9540 is a SoC name not a baord name
> 
> It's both. The u9540 board is affectionately called the u9540 board.
> 
> > > > >  	/* TODO: Export SoC, USB, cpu-freq and DMA40 */
> > > > >  	parent = u8500_of_init_devices();
> > > > > @@ -331,6 +334,7 @@ static const char * u8500_dt_board_compat[] = {
> > > > >  	"calaosystems,snowball-a9500",
> > > > >  	"st-ericsson,hrefv60+",
> > > > >  	"st-ericsson,mop500",
> > > > > +	"st-ericsson,u9540",
> > > > stop to add more compatible sue a more generic one
> > > 
> > > Not entirely sure what you mean here.
> > > 
> > > These are the only four boards we officially support.
> > > 
> > > There are other uXXXX boards that we do not.
> > you do not need it just mach a global compatbile
> 
> Why? What difference does it make? I could understand if we
> had a long list of supported boards, but I think this is move
> verbose and descriptive.

this is already the case simplify it and give a good example in the mainline
code as people just do copy & paste usualy
> 
> > > > >  	NULL,
> > > > >  };
> > > > >  
> > > > > @@ -345,4 +349,14 @@ DT_MACHINE_START(U8500_DT, "ST-Ericsson U8500 platform (Device Tree Support)")
> > > > >  	.dt_compat      = u8500_dt_board_compat,
> > > > >  MACHINE_END
> > > > >  
> > > > > +DT_MACHINE_START(U9540_DT, "ST-Ericsson 9540 platform (Device Tree Support)")
> > > > > +	.map_io		= u8500_map_io,
> > > > > +	.init_irq	= ux500_init_irq,
> > > > > +	.timer		= &ux500_timer,
> > > > > +	.handle_irq	= gic_handle_irq,
> > > > > +	.init_machine	= u8500_init_machine,
> > > > > +	.init_late	= NULL,
> > > > > +	.dt_compat      = u8500_dt_board_compat,
> > > > > +MACHINE_END
> > > > really?
> > > > no need drop it for a more generic on
> > > 
> > > This may look the same as the previous MACHINE_START now, but
> > > it will have differences in the future as more u9540 support is
> > > upstreamed. I think it should stick around as a separate entity
> > > for the time being. If we can consolidate the init functions at
> > > a later date, believe me I will make sure it happens.
no sorry add it when it's need not now

Best Regards,
J.
