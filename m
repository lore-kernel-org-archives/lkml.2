Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab1E3SVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 14:21:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54902 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab1E3SVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 14:21:07 -0400
Date: Mon, 30 May 2011 20:21:03 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sdhci: fix undue iomem warning
Message-ID: <20110530182103.GA2674@pengutronix.de>
References: <1306758796-4254-1-git-send-email-daniel.blueman@gmail.com>
 <20110530125822.GD3409@pengutronix.de>
 <BANLkTinL3ZvaNhYnsRMZQ4zBRLx6_F-O6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <BANLkTinL3ZvaNhYnsRMZQ4zBRLx6_F-O6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > a) SDHC Specs (even v3) only mention 0x100, so this _is_ the standard.
> > =A0 Do the new cards (which ones?) have anything located in the extra
> > =A0 area?
>=20
> This controller is a dual-slot one, so has two register sets (though
> one set of pins aren't wired to a socket).

There are two controllers and they are packed into one PCI-bar? :( I guess =
this
needs refactoring of the probe_slot routine then. Just silencing the warning
will just hide the problem.

> > b) your approach won't scale very well
>=20
> True - a more scalable test would be to check for non-zero length and
> a multiple of 256 bytes, would you say?

That wouldn't alarm for 0x10000 or the like, so no gain as well.

> >> + =A0 =A0 =A0 =A0 =A0 =A0 dev_warn(&pdev->dev, "Invalid iomem size. Yo=
u may "
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "experience problems.\n");
> >
> > I second turning the message into a warning, though.
>=20
> If the latter method is preferred, I'll adjust the patch and resend.

Reconsidering: Given the current situation, an error message is maybe not a
that bad idea, until the code can handle two controllers in one bar.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3j4A8ACgkQD27XaX1/VRstGACgr0L5lhHGESrKJg0HpmDn7THX
ZJEAn2GoYrKEEJYKxADe3OxVjr/kix9Y
=sJiG
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
