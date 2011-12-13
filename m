Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1LMKDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:03:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54705 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab1LMKDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:03:47 -0500
Date: Tue, 13 Dec 2011 11:03:43 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Anatolij Gustschin <agust@denx.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH RESEND] gpio: mpc8xxx: don't allow input-only pins to
 be output for MPC5121
Message-ID: <20111213100343.GA2619@pengutronix.de>
References: <1323767568-9565-1-git-send-email-w.sang@pengutronix.de>
 <20111213105243.101ced70@wker>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20111213105243.101ced70@wker>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 13, 2011 at 10:52:43AM +0100, Anatolij Gustschin wrote:
> Hi Wolfram,
>=20
> Looks mostly good to me. Please see minor comments below.
>=20
> On Tue, 13 Dec 2011 10:12:48 +0100
> Wolfram Sang <w.sang@pengutronix.de> wrote:
> ...
> > diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
> > index ec3fcf0..25dc736 100644
> > --- a/drivers/gpio/gpio-mpc8xxx.c
> > +++ b/drivers/gpio/gpio-mpc8xxx.c
> > @@ -115,6 +115,14 @@ static int mpc8xxx_gpio_dir_in(struct gpio_chip *g=
c, unsigned int gpio)
> >  	return 0;
> >  }
> > =20
> > +static int mpc5121_gpio_dir_out(struct gpio_chip *gc, unsigned int gpi=
o, int val)
>=20
> Line over 80 chars.

In this case, I think the alternative would be far less readable.

> > +{
> > +	/* GPIO 28..31 are input only on MPC5121 */
> > +	if (gpio >=3D 28)
> > +		return -EINVAL;
> > +
> > +	return mpc8xxx_gpio_dir_out(gc, gpio, val);
> > +}
> >  static int mpc8xxx_gpio_dir_out(struct gpio_chip *gc, unsigned int gpi=
o, int val)
>=20
> Please separate by an empty line. Thanks.

Ups, yes.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7nIv8ACgkQD27XaX1/VRuH8gCeKb5LnrGGNno+uH2ldUkfQM5C
5ggAoL6YhndBjzxtmL4pdmJua5CCQtrO
=Adf9
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
