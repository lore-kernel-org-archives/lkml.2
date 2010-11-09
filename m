Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0KIJdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:33:06 -0500
Received: from ns39351.ovh.net ([91.121.21.191]:49895 "EHLO ns39351.ovh.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab0KIJdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:33:03 -0500
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Nov 2010 04:33:03 EST
Date: Tue, 9 Nov 2010 09:25:25 +0000
From: Simon Guinot <simon@sequanux.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Simon Guinot <sguinot@lacie.com>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: (gpio-fan) Fix fan_ctrl_init error path
Message-ID: <20101109092525.GC32648@kw.sim.vm.gnt>
References: <1289279919.14461.7.camel@mola>
 <20101109090147.155dd1e9@endymion.delvare>
 <AANLkTim9mNy+ocftWn0ZiGPyefjhc-eXj3gunFw1Q04s@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DSayHWYpDlRfCAAQ"
Content-Disposition: inline
In-Reply-To: <AANLkTim9mNy+ocftWn0ZiGPyefjhc-eXj3gunFw1Q04s@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DSayHWYpDlRfCAAQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 09, 2010 at 04:22:02PM +0800, Axel Lin wrote:
> 2010/11/9 Jean Delvare <khali@linux-fr.org>:
> > On Tue, 09 Nov 2010 13:18:39 +0800, Axel Lin wrote:
> >> Remove sysfs entries before return -ENODEV.
> >>
> >> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> >> ---
> >> =C2=A0drivers/hwmon/gpio-fan.c | =C2=A0 =C2=A04 +++-
> >> =C2=A01 files changed, 3 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
> >> index aa701a1..d2e66b4 100644
> >> --- a/drivers/hwmon/gpio-fan.c
> >> +++ b/drivers/hwmon/gpio-fan.c
> >> @@ -388,11 +388,13 @@ static int fan_ctrl_init(struct gpio_fan_data *f=
an_data,
> >> =C2=A0 =C2=A0 =C2=A0 fan_data->speed_index =3D get_fan_speed_index(fan=
_data);
> >> =C2=A0 =C2=A0 =C2=A0 if (fan_data->speed_index < 0) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -ENODEV;
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto err_free_gpio;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto err_remove_sysfs;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> =C2=A0 =C2=A0 =C2=A0 return 0;
> >>
> >> +err_remove_sysfs:
> >> + =C2=A0 =C2=A0 sysfs_remove_group(&pdev->dev.kobj, &gpio_fan_ctrl_gro=
up);
> >> =C2=A0err_free_gpio:
> >> =C2=A0 =C2=A0 =C2=A0 for (i =3D i - 1; i >=3D 0; i--)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 gpio_free(ctrl[i]);
> >
> > Oh, and while you're here, fan_alarm_init() needs some love as well.
> > There's a "return 0" in the middle which clearly can't be correct.
> I think this part is correct. see the comment:
>         /*
>          * If the alarm GPIO don't support interrupts, just leave
>          * without initializing the fail notification support.
>          */
>=20

Yes, GPIO interrupts could not be supported. That's not an error case.

Simon

--DSayHWYpDlRfCAAQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkzZE4UACgkQgtp0PDeOcDqOXQCgnCjAkgy0AaTNuIZGomQyc4nV
AdoAnjsydFGAbXu/PtzfYeGZ6HK3Q00Y
=QcAD
-----END PGP SIGNATURE-----

--DSayHWYpDlRfCAAQ--
