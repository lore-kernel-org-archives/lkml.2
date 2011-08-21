Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab1HUL3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 07:29:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36485 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab1HUL3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:29:38 -0400
Date: Sun, 21 Aug 2011 13:29:30 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Julia Lawall <julia@diku.dk>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>, Liam Girdwood <lrg@ti.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sound/soc/mxs/mxs-saif.c: add missing kfree
Message-ID: <20110821112930.GB1914@pengutronix.de>
References: <1313820761-12042-3-git-send-email-julia@diku.dk>
 <20110820134439.GA2266@pengutronix.de>
 <Pine.LNX.4.64.1108201718200.30651@ask.diku.dk>
 <65EE16ACC360FA4D99C96DC085B3F7722212DF@039-SN1MPN1-001.039d.mgd.msft.net>
 <Pine.LNX.4.64.1108211318060.4072@ask.diku.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108211318060.4072@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 21, 2011 at 01:18:45PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>=20
> Move the test on pdev->id before the kzalloc to avoid requiring kfree when
> the test fails.  This fix was suggested by Wolfram Sang.
>=20
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @@
> identifier x;
> expression E1!=3D0,E2,E3,E4;
> statement S;
> iterator I;
> @@
>=20
> (
> if (...) { ... when !=3D kfree(x)
>                when !=3D x =3D E3
>                when !=3D E3 =3D x
> *  return ...;
>  }
> ... when !=3D x =3D E2
>     when !=3D I(...,x,...) S
> if (...) { ... when !=3D x =3D E4
>  kfree(x); ... return ...; }
> )
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <julia@diku.dk>

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk5Q7BoACgkQD27XaX1/VRvXqACZAYA3qFGHfgjM+y9gguYETxik
R9wAoJ64bv/9wRFcI13A4V2u21v5s9RJ
=GdL5
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
