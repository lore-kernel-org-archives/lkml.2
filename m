Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935541Ab2JaMf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 08:35:28 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:34453 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531Ab2JaMf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 08:35:26 -0400
Date: Wed, 31 Oct 2012 06:35:13 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] ARM: zynq: move ttc timer code to drivers/clocksource
Message-ID: <20121031123513.GJ5190@beefymiracle.amer.corp.natinst.com>
References: <20121029185630.GA26149@beefymiracle.amer.corp.natinst.com>
 <508FBBA5.2080707@monstr.eu>
 <201210302236.43473.arnd@arndb.de>
 <2b8e9679-dade-4448-8c16-362de455ead0@AM1EHSMHS002.ehs.local>
MIME-Version: 1.0
In-Reply-To: <2b8e9679-dade-4448-8c16-362de455ead0@AM1EHSMHS002.ehs.local>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 07:35:05 AM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 07:35:05 AM,
	Serialize complete at 10/31/2012 07:35:05 AM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="16qp2B0xu0fRvRD7"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-31_02:2012-10-31,2012-10-31,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--16qp2B0xu0fRvRD7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 31, 2012 at 08:48:38AM +0000, Michal Simek wrote:
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> > On Tuesday 30 October 2012, Michal Simek wrote:
> > > On 10/29/2012 07:56 PM, Josh Cartwright wrote:
[..]
> >=20
> > > >   delete mode 100644 arch/arm/mach-zynq/common.h
> > > >   delete mode 100644 arch/arm/mach-zynq/timer.c
> > > >   create mode 100644 drivers/clocksource/xilinx_ttc.c
> > > >   create mode 100644 include/linux/xilinx_ttc.h
> > >
> > > Really?
> > > If yes. shouldn't be there any better naming convention especially
> > > for headers. linux/clocksource/xilinx_ttc.h.
> >
> > Moving it is certainly the right direction, but I think we need a
> > better way to handle those forward declarations. "struct sys_timer"
> > is actually an ARM specific structure, so we might just want to add
> > all the forward declarations for the timers into
> > arch/arm/include/asm/mach/time.h. It's not ideal to do it like that,
> > but I think it's much better than having a new globally visible
> > header for each timer that is used on ARM.
> >
> > Eventually, we might want to do something similar to what we are
> > discussing for the top-level IRQ controllers at the moment, where we
> > just autodetect them from DT if possible, so we don't need to have
> > any pointer to the timer from arch code at all.
>
> Ok. It means that it is not big deal to keep timer as is in mach and
> when we have any generic solution we can follow it. This patch just
> move the code out of mach-zynq.  It should be done across architecture
> because for example timer I use for microblaze can be used by zynq
> too, also by Xilinx ppc.

That all makes sense.  Since posting, I've had to rework this a bit for
getting COMMON_CLK support working with the TTC.  I'll pull this patch
(in proper form, and with some slight modifications) into my pending
COMMON_CLK support patchset.

Thanks,

  Josh

--16qp2B0xu0fRvRD7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQkRsBAAoJEEef0niEbw+l/H0QAJgS9bg6GlY9Db/z3vacmTVo
Q+4fQtH0Bmy+/5SXH2KiNBSJVxq7JyAg7nmEm2oTRiMg26YVPi1uJJjDf856angw
pfRjxDeM2XR0ntBKo7MeCibWmcxbVl2E2EvqCBy7sOaCwhtOJOU20A0i9EfXnMFJ
PLCahd49m3W5urRDgfITI+i7mVBGLiaq4y2zi8COdD2FL8ApgKSzgQZb1H5gvvGb
Efp2CeK2cDZn2VwgYdQGALdaom9PutCaWcBMrCflyfJpxMapNJn5t9ghVZ4928M0
PAUGj6PXq20YanLINWLNCIH/lgFFBdBYRmM4MuBlXONGi4crsoJcQn5q9oEyrN4I
sHYB3rRUQtwrF8/+FojwNRY4LyGgt0C/fZt/5Rik+SHkPczs73X6ZNkf+zBuzhai
rRnDscgB5KaucWc8Q1baHLfNIjQD1LjGtLIJAFQWLNS0EKPkI0ez+AyYZ2BljMXW
xK9Twpn9HYStPE8F5s90zAUh1OwjVl/JiBEIEIQJ/O9XS7LI0LFmQuEFAk6hQ+T9
+EhE1+tRaREO7b/ofBsxrmPfyW+udtL+Wx8OZWWRVj3rPAmbeE6tl4THiMNFB7Aa
NY9bQVWrHF571pNR3Ya0QeR0nRGSnLgpiDAw1fONWg3Ci6JFtJmg2BO18HrArduG
i+1kzNcaEX/L8yOkTUGk
=aHiq
-----END PGP SIGNATURE-----

--16qp2B0xu0fRvRD7--
