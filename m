Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab2BGO45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:56:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51225 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2BGO4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:56:54 -0500
Date: Tue, 7 Feb 2012 15:56:52 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rtc: ds1307: generalise ram size and offset
Message-ID: <20120207145652.GH2539@pengutronix.de>
References: <1326144071.3096.25.camel@pc786-ubu.gnet.global.vpn>
 <20120111110650.GC2605@pengutronix.de>
 <1326320516.3096.64.camel@pc786-ubu.gnet.global.vpn>
 <20120119194541.GA32483@pengutronix.de>
 <1328143057.3159.34.camel@pc786-ubu.gnet.global.vpn>
 <1328221704.3159.50.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l06SQqiZYCi8rTKz"
Content-Disposition: inline
In-Reply-To: <1328221704.3159.50.camel@pc786-ubu.gnet.global.vpn>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l06SQqiZYCi8rTKz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> So if you have multiple RTCs, even of the same type, they would be in
> rtc0, rtc1, rtc2
>=20
> Since they each have their own nvram, does it matter if the size is
> changed?

Yes, because currently you pass a pointer to a static struct to the
sysfs_bin_attribute. If you change the size of the static struct to
another value, all other instances will get the new size, too, because
they still use the pointer to it.

You could just delete the size from the static struct, copy it over and
add the correct size to the copy and pass the copy to create_bin_file().
Or you initialize directly.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--l06SQqiZYCi8rTKz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8xO7QACgkQD27XaX1/VRv4JQCgml96g6gR2pOCLvx3Bs5sAc1j
GmoAoLIGNe9VaBs1C7Fh6/K7MR6XTpTI
=VNhS
-----END PGP SIGNATURE-----

--l06SQqiZYCi8rTKz--
