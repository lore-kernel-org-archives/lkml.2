Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967118Ab2EPNIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:08:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36535 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932658Ab2EPNIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:08:05 -0400
Date: Wed, 16 May 2012 14:08:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: Yadwinder Singh <yadi.brar@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] regulator: Add support for MAX77686.
Message-ID: <20120516130800.GC26337@opensource.wolfsonmicro.com>
References: <1336580695-1184-1-git-send-email-yadi.brar@samsung.com>
 <1336580695-1184-3-git-send-email-yadi.brar@samsung.com>
 <20120509184709.GC32037@sirena.org.uk>
 <CAKew6eVZuOUH8RHQbffCGX7i=6dM-qOJXojoKrOsM3V5ugEjHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JgQwtEuHJzHdouWu"
Content-Disposition: inline
In-Reply-To: <CAKew6eVZuOUH8RHQbffCGX7i=6dM-qOJXojoKrOsM3V5ugEjHA@mail.gmail.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 15, 2012 at 07:17:11PM +0530, Yadwinder Singh Brar wrote:
> On Thu, May 10, 2012 at 12:17 AM, Mark Brown
> > On Wed, May 09, 2012 at 09:54:55PM +0530, Yadwinder Singh wrote:

> >> + =A0 =A0 if (iodev->dev->of_node) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ret =3D max77686_pmic_dt_parse_pdata(iodev, =
pdata);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;

> > This ought to use of_regulator_match().

> While using it I am seeing that though it reduces few lines of code in
> our driver , it adds a huge array(of_regulator_match[])in which we
> have to populate the strings(name) which we already have in
> regulator_desc[ ], Isn't it overhead ?

Well, I think half the problem here is that you're only instantiating
things you find in the device tree.  If you were unconditionally
instantiating all the regulators then suddenly this becomes a lot
neater.

> >> + =A0 =A0 =A0 =A0 =A0 =A0 rdev[i] =3D regulator_register(&regulators[i=
d], max77686->dev,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0pdata->regulators[i].initdata,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0max77686, NULL);

> > No, you should unconditionally register all regulators the device
> > physically has. =A0This is useful for debug and simplifies the code.

> If we have to use only 2 or 3 regulators on our board out off 36 or
> lets take a case if our chip supports 50/100 regulators, I think i
> will a overhead to register all unused regulators as well as
> populating all the regulators in DT or platform data.

This isn't really a terribly realistic situation - if there are were
that many unused regulators the part selection is clearly not
appropriate to the system and most hardware engineers just wouldn't do
it.

Having information about all the regulators also allows us to do things
like power off any unused regulators which were left on after boot (eg,
due to bootloader or the PMIC defaults).

--JgQwtEuHJzHdouWu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPs6aoAAoJEBus8iNuMP3dAcAP/A5sos9nrV0wWChFeJwxE6a6
2EYqgs3/QWzWIyijWja2zJHfeBbG0rDEJEw4Tkq4zsOEfHwvkJ4orlUFz1415zsG
nVWQtTwod5Q5cAQqGUCSNOGYLx5eerloCLGi7oYp48gcmZ9FwkVfImRauAbs5GAa
VvjFd2Awwx3QBooBlgKdHR9MmY5zPhZIMw0fLlUm3vQpFgTumyXyGSRc+JtBt2M0
MvjkJ291/M4BiCdWVanmNQqGDl/dYR5fqIGzY4c4Z34BfhP73BisKdFN//s5qUPi
M/fY8misCoDmn5umVUDXB/qaLB5VzUTBHVojqDIHrffjhXsNtsARrA7TMVla0iUX
pOIXU1Wgjop9oml76y3sh8MRqOm+G0lfJBYcA+z4xFvrxlXACTvsjg/c3HPHqyAG
GwsBzHPpz88BKwwR2rQMOpiONARTPor8jMuG6hzfTWjhk0FRuEvY3SkQsdeh2um2
v+z/5wEh7XFlG02HBMz5mqPBKFys5Z4R3HX8WuNVnV5BXucgZmoHlP00wL1DAtZY
Vdfo12WdE0ztrxaWhjtziCwQVliQUdmc1DDovZf1SCVUb4TsxrbbBsOQdNOgeA/z
AP4TSaCMPsMwTb7ymltOfcYHV8VZ0rH2lyitkjRMv17fYNjQ8km3MwMaIs9gW0SQ
JAYV1kj2O0ahw4xi9oCZ
=tfPH
-----END PGP SIGNATURE-----

--JgQwtEuHJzHdouWu--
