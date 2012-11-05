Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab2KEVsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 16:48:36 -0500
Received: from mailserver6.natinst.com ([130.164.80.6]:37870 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab2KEVsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 16:48:33 -0500
Date: Mon, 5 Nov 2012 15:47:53 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Linn <John.Linn@xilinx.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/8] ARM: zynq: move ttc timer code to drivers/clocksource
Message-ID: <20121105214753.GB1254@beefymiracle.amer.corp.natinst.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
 <c0347788fbad559a249a25128a23f40c85d9cbda.1351721190.git.josh.cartwright@ni.com>
 <CAHTX3d++0fGSw7GQHcc-S1X1Qh-rfekpr-E8Jkg2_vFqdCFFTg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHTX3d++0fGSw7GQHcc-S1X1Qh-rfekpr-E8Jkg2_vFqdCFFTg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/05/2012 03:47:44 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/05/2012 03:47:44 PM,
	Serialize complete at 11/05/2012 03:47:44 PM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mojUlQ0s9EVzWg2t"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-11-05_03:2012-11-05,2012-11-05,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 05, 2012 at 12:22:55PM +0100, Michal Simek wrote:
> 2012/10/29 Josh Cartwright <josh.cartwright@ni.com>:
> > Suggested cleanup by Arnd Bergmann.  Move the ttc timer.c code to
> > drivers/clocksource, and out of the mach-zynq directory.
> >
> > The common.h (which only held the timer declaration) was renamed to
> > xilinx_ttc.h and moved into include/linux.
> >
> > Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  arch/arm/mach-zynq/Makefile                                    | 2 +-
> >  arch/arm/mach-zynq/common.c                                    | 2 +-
> >  drivers/clocksource/Makefile                                   | 1 +
> >  arch/arm/mach-zynq/timer.c => drivers/clocksource/xilinx_ttc.c | 1 -
> >  arch/arm/mach-zynq/common.h => include/linux/xilinx_ttc.h      | 4 ++--
> >  5 files changed, 5 insertions(+), 5 deletions(-)
> >  rename arch/arm/mach-zynq/timer.c => drivers/clocksource/xilinx_ttc.c (99%)
> >  rename arch/arm/mach-zynq/common.h => include/linux/xilinx_ttc.h (91%)
>
> Not going to apply this patch till there is clean way how to move all
> drivers there.  Especially I don't like to add xilinx_ttc.h to
> include/linux folder.

Okay;  I think it's best to defer the moving of the ttc driver from this
patchset.  It is not a dependency of the clk driver support stuff.
If you agree, I can spin up a v2 of the patchset w/o this change, and
without the serial CONFIG_OF stuff.  Should v2 contain the patches
you've already pulled into testing?

I'll give Rob's irqchip-like suggestion a spin and see how that works
out in parallel.

Thanks,

  Josh

--mojUlQ0s9EVzWg2t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQmDQJAAoJEEef0niEbw+lxMoP/AoAAAJVkxDC33NFPtqLVnTp
v8NZdPf7Yf62YFRr4c9uYzX91FH9Ksz8qmxGSlRLSLvsneeuIqt0rSXXLa72I370
ufAFpusrK1JMEZCX9SKOp34M6QUVqFAe6RdnRUrHku+uCKlVuD1s38uScRacnJpQ
udEblFpV9dZ+UYyvXUv6RpUP8EZI0Xh7ftSlvTU/Tq4237VCJb52nsocJaicZJbO
2oBiamHS2zxIX2gEzfRdOSzGgWeUwuoijwB//r5pEUTvqcGWRQpFfJ3PM9+6L67g
qBwvb+xtxkfI7LqU88k2gwAYD8pJgVKVrLGTrv3/1EXRD2INWkNrGABJBbHdSrHu
91m7rBPNpcs6Q5Tw6F2hsYv9WH0bgN/Tb/RcYuNLSheVjiFBl28MHh/jweB5fIwB
T6YgKrLfD+0bfYlV9V3Um2PVaw0Z2wrY5kSbsRT613d2T6TUiKFnUGE+OpA+8+b2
vebLx/i5lPV37yX19c0ATrAy5EoTzLs7O7S8c5Fw9r7N8LI3akSEu989RH+I1Hjk
ck3ezZq2nE41kicwNM+yi6vb2WnxBdMZ1lS0efxYVNZtWDSEXcpsTJkg++AYwHGr
FSGhXppIs3bzEPmj0mPxAQVC19SZpBHsU5bpgDOxRtzHco+su/v7oefkTxeD//Ep
kZSyWIpq+NYJkNXnD9Kw
=H11z
-----END PGP SIGNATURE-----

--mojUlQ0s9EVzWg2t--
