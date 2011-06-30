Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab1F3OSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 10:18:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44640 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab1F3OSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 10:18:24 -0400
Date: Thu, 30 Jun 2011 16:18:23 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: pca953x: change driver name to be unique
Message-ID: <20110630141823.GF1997@pengutronix.de>
References: <1309440959-18692-1-git-send-email-w.sang@pengutronix.de>
 <20110630161101.4bee9b19@endymion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xaMk4Io5JJdpkLEb"
Content-Disposition: inline
In-Reply-To: <20110630161101.4bee9b19@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xaMk4Io5JJdpkLEb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 30, 2011 at 04:11:01PM +0200, Jean Delvare wrote:
> On Thu, 30 Jun 2011 15:35:59 +0200, Wolfram Sang wrote:
> > This driver handles the variants pca9534-pca9539, so it chose the name
> > "pca953x". However, there is a led driver which decided on the same
> > name. As a result, those two can't be loaded at the same time. Add a
> > subsystem prefix to make the driver name unique. Device matching will
> > not suffer, because both are I2C drivers which match using a
> > i2c_device_id-table which is not altered.
> >=20
> > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> > ---
> >  drivers/gpio/pca953x.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
> > index 0451d7a..b30dd0b 100644
> > --- a/drivers/gpio/pca953x.c
> > +++ b/drivers/gpio/pca953x.c
> > @@ -742,7 +742,7 @@ static int pca953x_remove(struct i2c_client *client)
> > =20
> >  static struct i2c_driver pca953x_driver =3D {
> >  	.driver =3D {
> > -		.name	=3D "pca953x",
> > +		.name	=3D "gpio-pca953x",
> >  	},
> >  	.probe		=3D pca953x_probe,
> >  	.remove		=3D pca953x_remove,
>=20
> With the proposed change to the leds-pca9532 driver, you could leave
> this one alone, for the sake of simplicity and consistency with the
> pca953x, pcf857x and max732x gpio drivers.
>=20
> But I am not objecting to this change, if you like it.

I am fine with your suggestion.

Thanks!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--xaMk4Io5JJdpkLEb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk4Mha8ACgkQD27XaX1/VRvkzQCghLUxT8UM6gpXiUaDV/o/m/Nl
C8AAn1kbItkukWSSIvJH99h3cL7GN44J
=Xxcm
-----END PGP SIGNATURE-----

--xaMk4Io5JJdpkLEb--
