Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760485Ab0HFImh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 04:42:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46116 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab0HFIme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 04:42:34 -0400
Date: Fri, 6 Aug 2010 10:42:32 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regulator: max8660 - fix a memory leak in
 max8660_remove()
Message-ID: <20100806084232.GA2347@pengutronix.de>
References: <1281072927.24426.5.camel@mola>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <1281072927.24426.5.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 06, 2010 at 01:35:27PM +0800, Axel Lin wrote:
> In max8660_probe(), we allocate memory for max660.

Typo: max8660

> In max8660_remove(), current implementation only free rdev
> which is a member of struct max8660.
> Thus, there is a small memory leak when we unload the module.
>=20
> This patch fixes the memory leak by passing max660 to i2c clientdata,
> and properly kfree(max8660) in max8660_remove().

These two lines could go away IMHO as they are directly visible from the
code. Still, no real need for a resend from my side.

>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Thanks for catching that!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxbyvgACgkQD27XaX1/VRuE1wCgrgA0ojjvi0OOO2fpOQtwoR1i
wZgAmwdOpkphxjKDZpS7qnbM7rR24Rh8
=/qxF
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
