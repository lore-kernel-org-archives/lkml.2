Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab1A3VoH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 16:44:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49496 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab1A3VoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 16:44:06 -0500
Date: Sun, 30 Jan 2011 22:43:55 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Joachim Eastwood <manabian@gmail.com>
Cc: rpurdie@rpsys.net, riku.voipio@iki.fi, linux-kernel@vger.kernel.org,
        joachim.eastwood@jotron.com
Subject: Re: [leds-pca9532] Add gpio capability
Message-ID: <20110130214355.GA28220@pengutronix.de>
References: <AANLkTimHqDGtY3rTzB_xr9f_-pd7Sf084G8vOGghdKhh@mail.gmail.com>
 <20110130182540.GA12801@pengutronix.de>
 <AANLkTi=UYOeNXtL9ZhyVESBvWQwMEdbVUAOMqp4aV4_H@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <AANLkTi=UYOeNXtL9ZhyVESBvWQwMEdbVUAOMqp4aV4_H@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Some Kconfig-magic is missing. Iff that feature is used, then it depend=
s on
> > GENERIC_GPIO.
>=20
> I though about it just when I had hit send. I'll create an updated
> version where gpio capability is optional.
>=20
> GENERIC_GPIO? Shouldn't it be GPIOLIB in this case?

Yes, you are right. You are adding a gpiochip, so you need GPIOLIB.

> >> +	if (gpios) {
> >> +		data->gpio.label =3D "gpio-pca9532";
> >> +		data->gpio.set =3D pca9532_gpio_set_value;
> >> +		data->gpio.get =3D pca9532_gpio_get_value;
> >> +		data->gpio.request =3D pca9532_gpio_request_pin;
> >> +		data->gpio.can_sleep =3D 1;
> >> +		data->gpio.base =3D pdata->gpio_base;
> >> +		data->gpio.ngpio =3D 16;
> >> +		data->gpio.dev =3D &client->dev;
> >> +		data->gpio.owner =3D THIS_MODULE;
> >
> > I'd assume that you also need to define a direction_output-function whi=
ch
> > always
> > returns success?
>=20
> Yes, you are right. It is not possible to set direction in hw, but I
> should provide them.

It should be okay to skip direction_input, because gpiolib will return an e=
rror
if it is not available. This is exactly why IMO you need a direction_output
returning 0. Otherwise drivers checking if that operation was successful, m=
ight
be fooled.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1F25sACgkQD27XaX1/VRtORwCeLbj04WahNKy6/1uzkJqtlemr
J/kAn3ByogD3CUO2Qmd56wKCdGLsEjz5
=MaDs
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
