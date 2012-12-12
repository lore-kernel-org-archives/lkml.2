Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab2LLTHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 14:07:32 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59858 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab2LLTHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 14:07:30 -0500
Date: Wed, 12 Dec 2012 21:00:21 +0200
From: Felipe Balbi <balbi@ti.com>
To: Robert Nelson <robertcnelson@gmail.com>
CC: Paolo Pisati <paolo.pisati@canonical.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: if voltage scaling fails, restore
 original voltage values
Message-ID: <20121212190021.GA29854@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1355312753-16514-1-git-send-email-paolo.pisati@canonical.com>
 <1355312753-16514-2-git-send-email-paolo.pisati@canonical.com>
 <CAOCHtYhgQQX5560+bOHJGJ3EWqrE2JtdUfDNzk_R2Pgkw6c9+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <CAOCHtYhgQQX5560+bOHJGJ3EWqrE2JtdUfDNzk_R2Pgkw6c9+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 12, 2012 at 12:13:35PM -0600, Robert Nelson wrote:
> On Wed, Dec 12, 2012 at 5:45 AM, Paolo Pisati
> <paolo.pisati@canonical.com> wrote:
> > Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
> > ---
> >  drivers/regulator/core.c |   16 ++++++++++++++--
> >  1 file changed, 14 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> > index e872c8b..c347fd0 100644
> > --- a/drivers/regulator/core.c
> > +++ b/drivers/regulator/core.c
> > @@ -2250,6 +2250,7 @@ int regulator_set_voltage(struct regulator *regul=
ator, int min_uV, int max_uV)
> >  {
> >         struct regulator_dev *rdev =3D regulator->rdev;
> >         int ret =3D 0;
> > +       int old_min_uV, old_max_uV;
> >
> >         mutex_lock(&rdev->mutex);
> >
> > @@ -2271,18 +2272,29 @@ int regulator_set_voltage(struct regulator *reg=
ulator, int min_uV, int max_uV)
> >         ret =3D regulator_check_voltage(rdev, &min_uV, &max_uV);
> >         if (ret < 0)
> >                 goto out;
> > +
> > +       /* restore original values in case of error */
> > +       old_min_uV =3D regulator->min_uV;
> > +       old_max_uV =3D regulator->max_uV;
> >         regulator->min_uV =3D min_uV;
> >         regulator->max_uV =3D max_uV;
> >
> >         ret =3D regulator_check_consumers(rdev, &min_uV, &max_uV);
> >         if (ret < 0)
> > -               goto out;
> > +               goto out2;
> >
> >         ret =3D _regulator_do_set_voltage(rdev, min_uV, max_uV);
> > -
> > +       if (ret < 0)
> > +               goto out2;
> > +
> >  out:
> >         mutex_unlock(&rdev->mutex);
> >         return ret;
> > +out2:
> > +       regulator->min_uV =3D old_min_uV;
> > +       regulator->max_uV =3D old_max_uV;
> > +       mutex_unlock(&rdev->mutex);
> > +       return ret;
> >  }
> >  EXPORT_SYMBOL_GPL(regulator_set_voltage);
> >
> > --
> > 1.7.10.4
>=20
> Nice! This fixes the 800Mhz lockup on bootup after a software reset we
> were seeing on the Beagle xM's with v3.7.x/v3.6.x...
>=20
> Tested-by: Robert Nelson <robertcnelson@gmail.com>

if this fixes a boot lockup with older kernel, I believe this deserves a
Cc: stable@vger.kernel.org.

--=20
balbi

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQyNRFAAoJEIaOsuA1yqREGOMQAKrdaHEhlkTlu8ZVLk+Awu/5
3PQ6eaOQwkYWrY6RZ0rMTshEUZvraaJ2Ge3vWTdR5eaIPaDSE3EgDh7JjqosAlu1
PC6p19mPxUqijsL/ZAWP7oHs5m7xw/5jKlzBaemlel2SOOppSlI5i17aocRVibhB
vtLrJgdTlUZ5RAxUMOIg3zai6K0P36THLdOC00X+PKbvCg3TeWoR/6/nTgFCXADH
i/0R81dHRLv7aYKi+vBGmyxplEy8Fv3zovfOInE8sDxjvSLlumWXjwPzjm7R5nJ/
O+rJWTcEG2UJzv1eaHvKYGWg/rHnHO2Cjc5KJ3G4EDHBfLWpoCfpOnayaNuWj1KA
asMjTUrQoTZ7eTNqvpsWWZinlqyaxkPtyVNJun5QKObZFeVot7rKOxvdTSqQbtu9
vcXNHAcTwoLHvlnro+nZrqmSJrLXB4icQJ8GJBJJsmp6fpLT/HRliD8OauOu413I
JYBKq8NeAWN7RDbxqTJWvHGuykUh6kfPSWaASLPRAMR6jidex4WFSgw0qQZwQQY/
9dq2JasIPFFoCJKQochmXgGhj6l1SB+PtO+omURB+BhoryphkB5TElOToIk54lNy
78jAQgRa1qUZeU6RphDX/UKjESF+HGJVpPw50oRQ+XFTWp0S54CkGqsZfsLjlJAa
3k7Ii23H2kYEtHXl9Rvn
=7f5T
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
