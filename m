Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab1JJUUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 16:20:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59982 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab1JJUUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 16:20:24 -0400
Date: Mon, 10 Oct 2011 22:20:11 +0200
From: Julian Andres Klode <jak@jak-linux.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Marc Dietrich <marvin24@gmx.de>, Mikael Pettersson <mikpe@it.uu.se>,
        "Olof Johansson (olof@lixom.net)" <olof@lixom.net>,
        "Greg KH (gregkh@suse.de)" <gregkh@suse.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Leon Romanovsky <leon@leon.nu>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>
Subject: Re: [PATCH] fix drivers/staging/nvec linkage error when keyboard is
 disabled
Message-ID: <20111010202011.GA7220@jak-linux.org>
References: <20112.34922.209107.730268@pilspetsen.it.uu.se>
 <1534774.fR3YHUzZE9@fb07-iapwap2>
 <74CDBE0F657A3D45AFBB94109FB122FF173B23B539@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173B23B539@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 10:25:07AM -0700, Stephen Warren wrote:
> Marc Dietrich wrote at Sunday, October 09, 2011 9:48 AM:
> > Hi Mikael,
> > 
> > thanks for review. The nvec driver received some overhaul in the 3.1 release cycle
> > and he fruids can be viewed in linux-next tree. The nvec client drivers were
> > converted to mfd children in the mean time. This solves the build error, but is not
> > very flexible. We are planing to move the mfd stuct to the board file(s) in the next
> > cycle.
> 
> Indeed, the code in v3.1-rc9 is quite different to that in linux-next, so
> this exact problem doesn't exist in linux-next.
> 
> However, don't we still want to solve build problems for the final v3.1
> release, or a stable update to that? As such,
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Julian Andres Klode <jak@jak-linux.org>

But I should also add that there are probably more build failures due to
dependencies, as there are no dependencies specified in Kconfig (so basically
all nvec-* modules are subject to build failure if there dependencies
are not enabled (INPUT/SERIO/whatever). There's a patch in -staging
and -next for that, it may need adoption for 3.1 but would be needed
to fix all build failures.

I do not have good internet currently and am busy, so I can't
do anything to fix those problems, but I should have time
and connection to review patches for 3.1 (perhaps adapted
from the -staging one).

> > Am Samstag, 8. Oktober 2011, 19:29:14 schrieb Mikael Pettersson:
> > > Building linux-3.1-rc9 for the Tegra ARM SoC with CONFIG_MFD_NVEC=y
> > > and CONFIG_KEYBOARD_NVEC=n results in the following linkage error:
> > >
> > > drivers/built-in.o: In function `tegra_nvec_probe':
> > > /tmp/linux-3.1-rc9/drivers/staging/nvec/nvec.c:373: undefined reference to
> > > `nvec_kbd_init' make: *** [.tmp_vmlinux1] Error 1
> > >
> > > Fixed by #ifdef:ing the call to nvec_kbd_init(), similar to the
> > > existing #ifdef CONFIG_SERIO_NVEC_PS2 around the nvec_ps2() call.
> > >
> > > Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
> > > ---
> > >
> > > --- linux-3.1-rc9/drivers/staging/nvec/nvec.c.~1~	2011-10-08 16:28:20.000000000
> > > +0200 +++ linux-3.1-rc9/drivers/staging/nvec/nvec.c	2011-10-08 19:09:18.000000000
> > > +0200 @@ -370,7 +370,9 @@ static int __devinit tegra_nvec_probe(st
> > >  	nvec_write_async(nvec, EC_ENABLE_EVENT_REPORTING,
> > >  				sizeof(EC_ENABLE_EVENT_REPORTING));
> > >
> > > +#ifdef CONFIG_KEYBOARD_NVEC
> > >  	nvec_kbd_init(novec);
> > > +#endif
> > >  #ifdef CONFIG_SERIO_NVEC_PS2
> > >  	nvec_ps2(nvec);
> > >  #endif
> 
Live long and prosper!
-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.
