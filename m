Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab2ILKwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 06:52:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56828 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937Ab2ILKwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 06:52:05 -0400
Date: Wed, 12 Sep 2012 12:52:02 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com, arnd@arndb.de, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 12/19] i2c-nomadik: Register sub-devices when passed
 via Device Tree
Message-ID: <20120912105202.GD2624@pengutronix.de>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
 <1347016499-29354-13-git-send-email-lee.jones@linaro.org>
 <CACRpkdaCrus9SOpxyK+kV2gKr3sEZJsHCn6ivn2gA3ri0rcvHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KdquIMZPjGJQvRdI"
Content-Disposition: inline
In-Reply-To: <CACRpkdaCrus9SOpxyK+kV2gKr3sEZJsHCn6ivn2gA3ri0rcvHw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KdquIMZPjGJQvRdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 10, 2012 at 04:42:36AM -0700, Linus Walleij wrote:
> On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:
>=20
> > Each I2C device can be correctly probed already using Device Tree,
> > but the sub-devices still have to be registered by calls to
> > i2c_register_board_info(). After this patch, each sub-device can
> > be registered directly from Device Tree instead, removing the
> > requirement for the aforementioned calls from platform code.
> >
> > CC: linux-i2c@vger.kernel.org
> > CC: Wolfram Sang <w.sang@pengutronix.de>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>=20
> The patch as such is fine.
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>=20
> ...but there will be merge issues (of the type I'm
> discussing with Arnd in another thread).
>=20
> > ---
> >  drivers/i2c/busses/i2c-nomadik.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-=
nomadik.c
> > index 5d1a970..01231c2 100644
> > --- a/drivers/i2c/busses/i2c-nomadik.c
> > +++ b/drivers/i2c/busses/i2c-nomadik.c
> > @@ -26,6 +26,7 @@
> >  #include <linux/pm_runtime.h>
> >  #include <linux/platform_data/i2c-nomadik.h>
> >  #include <linux/of.h>
> > +#include <linux/of_i2c.h>
>=20
> This is clearly dependent on the other patches to I2C to
> be merged first (the include above is not yet there in
> linux-next even), so this patch should go into Wolfram's
> tree right? Else we have to rip out all the patches to the
> I2C driver from his tree and funnel it all through ARM SoC.

First, I'd like to have this patch squashed with "i2c: nomadik: Add
Device Tree support to the Nomadik I2C driver". I wanted to do this on
my own, but the patches do not apply to 3.6-rc5 (with or without
regulator removal patch from Linus)?

I can also take the I2C related changes to the devicetrees via my tree.
This is not uncommon. Some people prefer to do this via their soc-trees,
though. I don't care much since this is not really a hard dependency
causing build failures or merge conflicts, but just needs a little extra
time until the patches are all there...

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--KdquIMZPjGJQvRdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlBQaVIACgkQD27XaX1/VRtFaACgoh39FHUnKUPV5kp+0b/v4dJ8
sCoAoKZ+cztQxIEszGwClG27oICXHZ6H
=Hc56
-----END PGP SIGNATURE-----

--KdquIMZPjGJQvRdI--
