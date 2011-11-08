Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1KHJGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 04:06:30 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58423 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1KHJG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 04:06:26 -0500
Date: Tue, 8 Nov 2011 10:05:34 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: lm63: Add support for the NatSemi LM96163.
Message-ID: <20111108090534.GE27841@avionic-0098.mockup.avionic-design.de>
References: <1320661258-1775-1-git-send-email-thierry.reding@avionic-design.de>
 <1320684566.2309.115.camel@groeck-laptop>
 <20111108073052.GC27841@avionic-0098.mockup.avionic-design.de>
 <20111108095925.0d99aea5@endymion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="11Y7aswkeuHtSBEs"
Content-Disposition: inline
In-Reply-To: <20111108095925.0d99aea5@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:VJO23iL8ZUIz24e8/Dt9z72v9QFhGAuclRjlkd5Deo1
 x8w41GLWScCa8S38+J1nAhWREPWtQOuinkTnjbobImD8MRrnZR
 fw+Knx6+2Budao4wVh4QJ4TTFlX6nlAYHViQFZb7Gs7FjhdWdl
 e6zlMcvenv1V/kUO/aEu/hQsCRr3dW7bmEm7U2is19uO15B6DM
 F1FcgWbiBfkpRA9KqytAJz/NsGx56TdT46mPabPdQDOckfY0dY
 7ToZKm2s8t8s1+cb3XrOp3qaXJp1AHFDTEmtNmafhYBNcUVMKk
 4S0oxjNbVoUBV6/up8GCdpB6KsLif4AN9zHCNtRjesbtmKEeyD
 v9hyOhUmNwAwa8lYNOZYEC2FeQE1rwuLe/fk75U5xDr3pVbf5M
 wOiuKj7Dtb2tD4laq+7Kf5Eo9C2SEythiY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--11Y7aswkeuHtSBEs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Jean Delvare wrote:
> Hi Thierry,
>=20
> On Tue, 8 Nov 2011 08:30:52 +0100, Thierry Reding wrote:
> > * Guenter Roeck wrote:
> > > Hi,
> > >=20
> > > On Mon, 2011-11-07 at 05:20 -0500, Thierry Reding wrote:
> > > > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > > > ---
> > > >  drivers/hwmon/lm63.c |    2 +-
> > > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > >=20
> > > > diff --git a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
> > > > index 508cb29..94e373c 100644
> > > > --- a/drivers/hwmon/lm63.c
> > > > +++ b/drivers/hwmon/lm63.c
> > > > @@ -483,7 +483,7 @@ static int lm63_detect(struct i2c_client *new_c=
lient,
> > > >  		return -ENODEV;
> > > >  	}
> > > > =20
> > > > -	if (chip_id =3D=3D 0x41 && address =3D=3D 0x4c)
> > > > +	if ((chip_id =3D=3D 0x41 || chip_id =3D=3D 0x49) && address =3D=
=3D 0x4c)
> > > >  		strlcpy(info->type, "lm63", I2C_NAME_SIZE);
> > > >  	else if (chip_id =3D=3D 0x51 && (address =3D=3D 0x18 || address =
=3D=3D 0x4e))
> > > >  		strlcpy(info->type, "lm64", I2C_NAME_SIZE);
> > >=20
> > > Minor - the new chip should be mentioned in drivers/hwmon/Kconfig and=
 in
> > > Documentation/hwmon/lm63.
> >=20
> > I don't see how to list this variant meaningfully in the documentation.
> > Since, as you mention, no functionality specific to the LM96163 is adde=
d,
> > this patch really only adds support for one more lm63 chip.
>=20
> The new chip name should at least be listed in
> Documentation/hwmon/lm63, drivers/hwmon/Kconfig.

Okay.

> > > My main concern is that LM96163 supports a high resolution PWM mode.
> > > Since that mode is much more convenient than the LM63-compatible mode=
, I
> > > think it is likely to be enabled in designs using LM96163, and it sho=
uld
> > > be supported by the driver if we add support for LM96163.
> >=20
> > Unfortunately our design doesn't use the PWM at all. It is only used for
> > temperature measurements, so I'm not able to test any of the PWM code.
>=20
> You still need to ensure that nothing bad will happen if users load the
> lm63 driver with a LM96163 chip (if nothing else, by disabling the
> unimplemented/untested feature.)

Okay. I'll make sure to mention that in the documentation as well.

Thanks,
Thierry

--11Y7aswkeuHtSBEs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk648N4ACgkQZ+BJyKLjJp9hMQCfSJ7hQxRyKcb1yMCICizRtE54
ULsAn31NEvWDdUU8DjLotxsr36Q0MtCp
=C8OX
-----END PGP SIGNATURE-----

--11Y7aswkeuHtSBEs--
