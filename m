Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab2DWH2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 03:28:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48346 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab2DWH2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 03:28:44 -0400
Date: Mon, 23 Apr 2012 09:28:39 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>,
        Huang Shijie <b32955@freescale.com>
Subject: Re: [PATCH V2 1/3] lib: add support for stmp-style devices
Message-ID: <20120423072839.GC4568@pengutronix.de>
References: <1332368519-22660-1-git-send-email-w.sang@pengutronix.de>
 <1332368519-22660-2-git-send-email-w.sang@pengutronix.de>
 <20120422235506.d3377f0e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w7PDEPdKQumQfZlR"
Content-Disposition: inline
In-Reply-To: <20120422235506.d3377f0e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w7PDEPdKQumQfZlR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 22, 2012 at 11:55:06PM -0700, Andrew Morton wrote:
> On Wed, 21 Mar 2012 23:21:57 +0100 Wolfram Sang <w.sang@pengutronix.de> w=
rote:
>=20
> > MX23/28 use IP cores which follow a register layout I have first seen on
> > STMP3xxx SoCs. In this layout, every register actually has four u32:
> >=20
> >  1.) to store a value directly
> >  2.) a SET register where every 1-bit sets the corresponding bit,
> >      others are unaffected
> >  3.) same with a CLR register
> >  4.) same with a TOG (toggle) register
> >=20
> > Also, the 2 MSBs in register 0 are always the same and can be used to r=
eset
> > the IP core.
> >=20
> > All this is strictly speaking not mach-specific (but IP core specific) =
and,
> > thus, doesn't need to be in mach-mxs/include. At least, mx6 and mx50 al=
so
> > utilize IP cores following this stmp-style. So:
> >=20
> > Introduce a stmp-style device, put the code and defines for that in a p=
ublic
> > place (lib/), and let drivers for stmp-style devices select that code.
> > To avoid regressions and ease reviewing, the actual code is simply copi=
ed from
> > mach-mxs. It definately wants updates, but those need a seperate patch =
series.
> >=20
> > Voila, mach dependency gone, reusable code introduced. Note that I didn=
't
> > remove the duplicated code from mach-mxs yet, first the drivers have to=
 be
> > converted.
> >=20
> > ...
> >
> >  include/linux/stmp_device.h |   20 +++++++++++
> >  lib/Kconfig                 |    3 ++
> >  lib/Makefile                |    2 +
> >  lib/stmp_device.c           |   80 +++++++++++++++++++++++++++++++++++=
++++++++
>=20
> It's good that this is being presented as library code, rather than
> being buried in some device-specific directory then copied and pasted
> ten times.
>=20
> But ./lib/ does seem rather a strange place for it.  Perhaps we need a
> drivers/lib/ or something.  We can use ./lib/ for now - it can always
> be moved later on.

The first version had it in drivers/base/ but that also felt strange.
I like drivers/lib/. Arnd, do you agree? Shall I resend?

>=20
> > --- /dev/null
> > +++ b/lib/stmp_device.c
>=20
> The functions in this file look terribly racy on SMP, or even with
> preemption or interrupts.  What happens if two CPUs or threads run
> stmp_reset_block() against the same device at the same time?
>=20
> Perhaps the caller is supposed to prevent that, and the documentation
> which isn't there forgot to mention it ;)

The code needs even more cleanups, timeouts are terrible as well. But as
mentioned above, this series only moves existing code to a central
place. Improvements would be the next, seperate step.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--w7PDEPdKQumQfZlR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+VBKcACgkQD27XaX1/VRvmQQCeOi616QJuSWw78koSOmgN3yUx
xvQAoJsWagvjQ1lsq9DhBlKlPUjdveDv
=S7Xl
-----END PGP SIGNATURE-----

--w7PDEPdKQumQfZlR--
