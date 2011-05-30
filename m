Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab1E3Fy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 01:54:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41368 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1E3Fy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 01:54:26 -0400
Date: Sun, 29 May 2011 23:54:24 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: gpio: gpio-exynos4 build fails in mainline
Message-ID: <20110530055424.GB23517@ponder.secretlab.ca>
References: <20110529083032.d3d16059.randy.dunlap@oracle.com>
 <20110529083520.41730250.randy.dunlap@oracle.com>
 <20110529084000.68a6351a.randy.dunlap@oracle.com>
 <20110529084440.a4803072.rdunlap@xenotime.net>
 <BANLkTinhXj51dzCnnXhxrCLeW1qQES6CvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinhXj51dzCnnXhxrCLeW1qQES6CvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 10:24:47AM +0900, Kyungmin Park wrote:
> On Mon, May 30, 2011 at 12:44 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > On Sun, 29 May 2011 08:40:00 -0700 Randy Dunlap wrote:
> >
> >> On Sun, 29 May 2011 08:35:20 -0700 Randy Dunlap wrote:
> >>
> >> > On Sun, 29 May 2011 08:30:32 -0700 Randy Dunlap wrote:
> >> >
> >> > > probably should depend on ARM or some ARM sub-arch/mach-type?
> >> > >
> >> > >
> >> > > drivers/gpio/gpio-exynos4.c:18:11: error: unable to open 'mach/map.h'
> >> > >
> >> > >
> >> > > on x86_64
> >> > >
> >> > > ---
> >> >
> >> > similarly:
> >> >
> >> > drivers/gpio/gpio-plat-samsung.c:22:11: error: unable to open 'plat/gpio-core.h'
> >>
> >>
> >> and
> >>
> >> drivers/gpio/gpio-s5pc100.c:21:11: error: unable to open 'mach/map.h'
> >>
> >>
> >> (this began as x86_64 allmodconfig)
> >
> > and
> >
> > drivers/gpio/gpio-s5pv210.c:17:11: error: unable to open 'plat/gpio-core.h'
> 
> Hi,
> 
> Right, now it's just moved from mach directories to drivers/gpio
> So it requires the proper depends on each ARCH_CPU.
> 
> Thank you,
> Kyungmin Park

A variant on this patch merged and pushed out to the following branch.  Thanks.

git://git.secretlab.ca/git/linux-2.6 gpio/merge

It should be in linux-next tomorrow.

g.

> ---
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 5923976..655babf 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -88,24 +88,28 @@ config GPIO_IT8761E
> 
>  config GPIO_EXYNOS4
>         bool "Samsung Exynos4 GPIO library support"
> +       depends on CPU_EXYNOS4210
>         default y if CPU_EXYNOS4210
>         help
>           Say yes here to support Samsung Exynos4 series SoCs GPIO library
> 
>  config GPIO_PLAT_SAMSUNG
>         bool "Samsung SoCs GPIO library support"
> +       depends on SAMSUNG_GPIOLIB_4BIT
>         default y if SAMSUNG_GPIOLIB_4BIT
>         help
>           Say yes here to support Samsung SoCs GPIO library
> 
>  config GPIO_S5PC100
>         bool "Samsung S5PC100 GPIO library support"
> +       depends on CPU_S5PC100
>         default y if CPU_S5PC100
>         help
>           Say yes here to support Samsung S5PC100 SoCs GPIO library
> 
>  config GPIO_S5PV210
>         bool "Samsung S5PV210/S5PC110 GPIO library support"
> +       depends on CPU_S5PV210
>         default y if CPU_S5PV210
>         help
>           Say yes here to support Samsung S5PV210/S5PC110 SoCs GPIO library
> 
> >
> >
> > ---
> > ~Randy
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
