Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab1ADM5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 07:57:46 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:36483 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1ADM5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 07:57:44 -0500
Date: Tue, 4 Jan 2011 13:57:22 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Harald Welte <HaraldWelte@viatech.com>,
        Michal Ludvig <michal@logix.cz>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20110104125722.GC27114@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
References: <20101230204522.GC23219@darkside.kls.lan>
 <4D1D0C61.9050800@lwfinger.net>
 <20101231003735.GA24101@gondor.apana.org.au>
 <4D1D27E7.7030301@lwfinger.net>
 <20101231022550.GA2512@darkside.kls.lan>
 <20101231024653.GA24879@gondor.apana.org.au>
 <20101231085103.GA31935@darkside.kls.lan>
 <20110104043338.GA27604@gondor.apana.org.au>
 <20110104121957.GA27114@darkside.kls.lan>
 <20110104123824.GA31557@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
In-Reply-To: <20110104123824.GA31557@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 04, 2011 at 11:38:24PM +1100, Herbert Xu wrote:
> On Tue, Jan 04, 2011 at 01:19:57PM +0100, Mario 'BitKoenig' Holbe wrote:
> >
> > Hmmm, yes - the patch fixes the crashes, i.e. no more crashes with
> > either sequence of module-loading, cat rng_available works as well,
> > but...
> >=20
> > Having this patch active rngd complains:
> > 	rngd[1435]: rngd 2-unofficial-mt.13 starting up...
> > 	rngd[1435]: block failed FIPS test: 0x1f
> > 	rngd[1435]: block failed FIPS test: 0x1f
> > 	...
> > 	rngd[1435]: stats: entropy added to kernel pool: 0
> > 	rngd[1435]: stats: FIPS 140-2 successes: 0
> > 	rngd[1435]: stats: FIPS 140-2 failures: 10
> >=20
> > It doesn't do this without the patch.
> > The only available rng was via, I did blacklist the others just to be
> > sure.
>=20
> Hmm, can you print out what it's actually producing (e.g., by
> stracing rngd)?

# ps -ef | grep 'rng[d]'
# cat /sys/devices/virtual/misc/hw_random/rng_available
via=20
# hexdump -n 512 -C /dev/hwrng
00000000  00 ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |..............=
=2E.|
00000010  ff ff ff ff ff ff ff 00  00 00 00 00 00 00 00 00  |..............=
=2E.|
00000020  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
=2E.|
*
00000200
# hexdump -n 512 -C /dev/hwrng
00000000  00 ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |..............=
=2E.|
00000010  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |..............=
=2E.|
*
00000070  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
=2E.|
*
00000200
# hexdump -n 1024 -C /dev/hwrng
00000000  00 ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |..............=
=2E.|
00000010  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |..............=
=2E.|
*
00000060  ff ff ff ff 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
=2E.|
00000070  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
=2E.|
*
00000400
# hexdump -n 1024 -C /dev/hwrng
00000000  00 ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |..............=
=2E.|
00000010  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |..............=
=2E.|
*
00000070  ff 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
=2E.|
00000080  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
=2E.|
*
00000400
#                                                                          =
                                               =20
> Can you also double-check that this doesn't happen with Larry's
> patch?

Nope, it doesn't do this with Larry's patch.


Mario
--=20
The Encyclopedia Galactica, in its chapter on Love states that it is far
too complicated to define.
The Hitchhiker's Guide to the Galaxy has this to say on the subject of
love: Avoid, if at all possible.

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTSMZMhS+e2HeSPbpAQK5zAgAg3/4GFc24riEzOjhHnfApANoUhzbrpAR
uQZV/poVPo1KPd2cszNAwm12lTFRd16rB/sYQP0KkSszhReRBlwpmSJxEwYyZoUQ
/gBjirQaZuzkgZF1cWxSzr7fJnVTPnwpqH0rRipiFOPNRbUMXVNlLBQ4YK3wBNI1
5/n2Erous4CIcWIIjjUvg5yx9Pz37i9mT/cKuAK+uTOiZQrc1KRst1l4Cr+aHiR6
xcDKM4jyf3eqElNXYmP3D8OZ9onE3V7VtEC7c6U369Cz1B1BchvOn4qtyaLZMDDd
b7odLrCLXDVLvIbOTV2f8ysCaug0/EepBv7zZdjmkJ5CmupKAm//SA==
=/9Zh
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
