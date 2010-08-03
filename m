Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab0HCMM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 08:12:56 -0400
Received: from smtp.nokia.com ([192.100.122.230]:26600 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab0HCMMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 08:12:55 -0400
Subject: Re: [PATCH 21/33] Removing dead OMAP2_VENC_OUT_TYPE_SVIDEO,
 OMAP2_VENC_OUT_TYPE_COMPOSITE
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: ext Tony Lindgren <tony@atomide.com>
Cc: Christoph Egger <siccegge@cs.fau.de>,
        Russell King <linux@arm.linux.org.uk>, Jason Lam <lzg@ema-tech.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vamos@i4.informatik.uni-erlangen.de" 
	<vamos@i4.informatik.uni-erlangen.de>
In-Reply-To: <20100705085654.GL15951@atomide.com>
References: <cover.1277911345.git.siccegge@cs.fau.de>
	 <2709d1406900af2436f6f8af00555507baf8dac9.1277911346.git.siccegge@cs.fau.de>
	 <20100705085654.GL15951@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 15:12:22 +0300
Message-ID: <1280837542.3436.142.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2010 12:12:31.0601 (UTC) FILETIME=[26069610:01CB3305]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-05 at 10:56 +0200, ext Tony Lindgren wrote:
> * Christoph Egger <siccegge@cs.fau.de> [100630 18:58]:
> > OMAP2_VENC_OUT_TYPE_SVIDEO, OMAP2_VENC_OUT_TYPE_COMPOSITE doesn't
> > exist in Kconfig, therefore removing all references for it from the
> > source code.
> 
> Let's let Tomi figure out this one, added him to Cc.

The patch doesn't look valid, because either SVIDEO or COMPOSITE should
be set into .phy.venc.type. But then again, the code that's removed
doesn't look valid either, as by default it doesn't do either, and the
COMPOSITE block wouldn't even comile...

Those defines look like some custom defines that have never been in
mainstream linux, so I think the patch can be applied, and the board
file maintainer can fix it with proper code later.

 Tomi

> 
> Regards,
> 
> Tony
>  
> > Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> > ---
> >  arch/arm/mach-omap2/board-omap3stalker.c |    5 -----
> >  1 files changed, 0 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
> > index f848ba8..b38afd5 100644
> > --- a/arch/arm/mach-omap2/board-omap3stalker.c
> > +++ b/arch/arm/mach-omap2/board-omap3stalker.c
> > @@ -181,11 +181,6 @@ static struct omap_dss_device omap3_stalker_tv_device = {
> >  	.name			= "tv",
> >  	.driver_name		= "venc",
> >  	.type			= OMAP_DISPLAY_TYPE_VENC,
> > -#if defined(CONFIG_OMAP2_VENC_OUT_TYPE_SVIDEO)
> > -	.phy.venc.type		= OMAP_DSS_VENC_TYPE_SVIDEO,
> > -#elif defined(CONFIG_OMAP2_VENC_OUT_TYPE_COMPOSITE)
> > -	.u.venc.type		= OMAP_DSS_VENC_TYPE_COMPOSITE,
> > -#endif
> >  	.platform_enable	= omap3_stalker_enable_tv,
> >  	.platform_disable	= omap3_stalker_disable_tv,
> >  };
> > -- 
> > 1.7.0.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


