Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab0JNISl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 04:18:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35343 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab0JNISj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 04:18:39 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
CC: "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Thu, 14 Oct 2010 03:18:30 -0500
Subject: RE: [PATCH 3/4] iovmm: replace __iounmap with omap_iounmap
Thread-Topic: [PATCH 3/4] iovmm: replace __iounmap with omap_iounmap
Thread-Index: Actra4VX5MarTWmXTyOHbKvwa93C2AADB7Tl
Message-ID: <496565EC904933469F292DDA3F1663E602F3E074FB@dlee06.ent.ti.com>
References: <1287023257-30951-2-git-send-email-x0095840@ti.com>
	<1287023257-30951-3-git-send-email-x0095840@ti.com>
	<1287023257-30951-4-git-send-email-x0095840@ti.com>,<20101014.094525.71092814.Hiroshi.DOYU@nokia.com>
In-Reply-To: <20101014.094525.71092814.Hiroshi.DOYU@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> ________________________________________
> From: Hiroshi DOYU [Hiroshi.DOYU@nokia.com]
> Sent: Thursday, October 14, 2010 1:45 AM
> To: Guzman Lugo, Fernando
> Cc: felipe.contreras@nokia.com; tony@atomide.com;
>  linux-kernel@vger.kernel.org; andy.shevchenko@gmail.com; linux-omap@vger.kernel.org
> Subject: Re: [PATCH 3/4] iovmm: replace __iounmap with omap_iounmap
> 
> Hi Fernando,
> 
> From: ext Fernando Guzman Lugo <x0095840@ti.com>
> Subject: [PATCH 3/4] iovmm: replace __iounmap with omap_iounmap
> Date: Thu, 14 Oct 2010 04:27:36 +0200
> 
> > Omap platform is omap_iounmap function.
> >
> > Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> > ---
> >  arch/arm/plat-omap/iovmm.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
> > index 93a34d9..5489ca9 100644
> > --- a/arch/arm/plat-omap/iovmm.c
> > +++ b/arch/arm/plat-omap/iovmm.c
> > @@ -821,7 +821,7 @@ void iommu_kunmap(struct iommu *obj, u32 da)
> >       struct sg_table *sgt;
> >       typedef void (*func_t)(const void *);
> >
> > -     sgt = unmap_vm_area(obj, da, (func_t)__iounmap,
> 
> +       sgt = unmap_vm_area(obj, da, (func_t)iounmap,
> 
> Woundn't the above be enough?
> 
> Eventually this "iounmap()" calls "__arch_iounmap()" ->
> "omap_iounmap()". I don't see any special reason to call
> "omap_iounmap()" here for now.

iounmap and __arch_iounmap are macros they cannot not
be used there. If so, it gives a "undeclared" compile error.

Regards,
Fernando.

> 
> 
> > +     sgt = unmap_vm_area(obj, da, (func_t)omap_iounmap,
> >                           IOVMF_LINEAR | IOVMF_MMIO);
> >       if (!sgt)
> >               dev_dbg(obj->dev, "%s: No sgt\n", __func__);
> > --
> > 1.6.3.3
> >
