Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1KHHbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 02:31:50 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:65046 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab1KHHbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 02:31:49 -0500
Date: Tue, 8 Nov 2011 08:30:52 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: lm63: Add support for the NatSemi LM96163.
Message-ID: <20111108073052.GC27841@avionic-0098.mockup.avionic-design.de>
References: <1320661258-1775-1-git-send-email-thierry.reding@avionic-design.de>
 <1320684566.2309.115.camel@groeck-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
In-Reply-To: <1320684566.2309.115.camel@groeck-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:cAQYs39ck/u2vRwbCYZuLXpehMSGtaulGtNhgD4mHKH
 Ter1YC32H3vB4JTeOAxunfmw8o1TjjBehoGAIBBo7AjZiNYIrs
 46tjnWTVYT7Vmqu5u61U8xuYTFSPjL2BB4kT6IB8V15l/ZdYC5
 WlQRSmUun8WqBKtaKwR/aLvJBQfdytwOjWiMwq1/cfHQcKSOCF
 FRQ2jSTuyb7sVPx8EByyjNFOz3I+20QTUH5ezwsSoOV+FJveb4
 PGmTHoS2iY5EIus69BeRcBcY+YSPsQB7RVNHdofxE9MFc7/G4Y
 PggQBF3n5mkR29SEmJ7kIvOsRmg6wX+odfSZTzA7NuiuVsDnyx
 2FDI6BCZhI9c7CKYy7uTOGaikH+SgypjWceJQJhcrQ7+t6LY/k
 VeeABnPJKNfrZbqGnY/owATrDlmzcpYgXo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Guenter Roeck wrote:
> Hi,
>=20
> On Mon, 2011-11-07 at 05:20 -0500, Thierry Reding wrote:
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> >  drivers/hwmon/lm63.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
> > index 508cb29..94e373c 100644
> > --- a/drivers/hwmon/lm63.c
> > +++ b/drivers/hwmon/lm63.c
> > @@ -483,7 +483,7 @@ static int lm63_detect(struct i2c_client *new_clien=
t,
> >  		return -ENODEV;
> >  	}
> > =20
> > -	if (chip_id =3D=3D 0x41 && address =3D=3D 0x4c)
> > +	if ((chip_id =3D=3D 0x41 || chip_id =3D=3D 0x49) && address =3D=3D 0x=
4c)
> >  		strlcpy(info->type, "lm63", I2C_NAME_SIZE);
> >  	else if (chip_id =3D=3D 0x51 && (address =3D=3D 0x18 || address =3D=
=3D 0x4e))
> >  		strlcpy(info->type, "lm64", I2C_NAME_SIZE);
>=20
> Minor - the new chip should be mentioned in drivers/hwmon/Kconfig and in
> Documentation/hwmon/lm63.

I don't see how to list this variant meaningfully in the documentation.
Since, as you mention, no functionality specific to the LM96163 is added,
this patch really only adds support for one more lm63 chip.

> My main concern is that LM96163 supports a high resolution PWM mode.
> Since that mode is much more convenient than the LM63-compatible mode, I
> think it is likely to be enabled in designs using LM96163, and it should
> be supported by the driver if we add support for LM96163.

Unfortunately our design doesn't use the PWM at all. It is only used for
temperature measurements, so I'm not able to test any of the PWM code.

Thierry

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk642qwACgkQZ+BJyKLjJp9SVgCZAT+v0GQNxZR3NLNZHWp9y9kP
+EkAnjJE0OvMoYgQ+d8qzOz4S6hsPTBH
=5tbI
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
