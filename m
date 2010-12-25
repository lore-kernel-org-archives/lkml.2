Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab0LYWRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 17:17:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54873 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab0LYWRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 17:17:48 -0500
Date: Sat, 25 Dec 2010 23:17:00 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>, netdev@vger.kernel.org, vortex@scyld.com,
        becker@scyld.com,
        Steffen Klassert <klassert@mathematik.tu-chemnitz.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 3c59x: Don't assign when a comparison is intended
Message-ID: <20101225221700.GA8612@pengutronix.de>
References: <alpine.LNX.2.00.1012252125410.10759@swampdragon.chaosbits.net> <AANLkTi=Y4wDG6+AY1=8NuFLGuCidgqaU1LginfB1YpZH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <AANLkTi=Y4wDG6+AY1=8NuFLGuCidgqaU1LginfB1YpZH@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 25, 2010 at 09:50:56PM +0100, richard -rw- weinberger wrote:
> On Sat, Dec 25, 2010 at 9:30 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > Hi,
> >
> > In drivers/net/3c59x.c::vortex_probe1() we have this code:
> >
> > =A0 =A0 =A0 =A0if (gendev) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((pdev =3D DEVICE_PCI(gendev))) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0print_name =3D pci_name(=
pdev);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((edev =3D DEVICE_EISA(gendev))) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0print_name =3D dev_name(=
&edev->dev);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0}
> >
> > I believe these assignments were intended to be comparisons.
> > If I'm correct, then here's a patch to fix that up.
>=20
> I don't think so. Look at the extra brackets.
>=20
> The code can also written as:
>=20
> pdev =3D DEVICE_PCI(gendev);
> if(pdev)
>   print_name =3D pci_name(pdev);

=2E.. which looks much better and could be worth a patch as well.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk0WbVwACgkQD27XaX1/VRuTRACfWd1/1j2rueStgVeJJxDVb3qT
F1IAniAFUAlpz/PMfkvFRf1HUbWapqBc
=mi1C
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
