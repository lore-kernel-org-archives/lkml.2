Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768906Ab2KOUGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 15:06:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42659 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1768435Ab2KOUGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 15:06:30 -0500
Message-ID: <1353009986.4867.70.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 27/82] gpiolib: Dont return -EPROBE_DEFER to sysfs, or for
 invalid gpios
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 15 Nov 2012 20:06:26 +0000
In-Reply-To: <20121115175242.GA10102@herton-Z68MA-D2H-B3>
References: <20121114053933.726869752@decadent.org.uk>
	 <20121114053937.652708298@decadent.org.uk>
	 <20121115175242.GA10102@herton-Z68MA-D2H-B3>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-c5myi5uPBx/HfrbplrBo"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-c5myi5uPBx/HfrbplrBo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-11-15 at 15:52 -0200, Herton Ronaldo Krzesinski wrote:
> On Wed, Nov 14, 2012 at 05:40:00AM +0000, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Mathias Nyman <mathias.nyman@linux.intel.com>
> >=20
> > commit ad2fab36d7922401c4576fb7ea9b21a47a29a17f upstream.
> >=20
> > gpios requested with invalid numbers, or gpios requested from userspace=
 via sysfs
> > should not try to be deferred on failure.
> >=20
> > Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  drivers/gpio/gpiolib.c |   10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > index 5d6c71e..1c8d9e3 100644
> > --- a/drivers/gpio/gpiolib.c
> > +++ b/drivers/gpio/gpiolib.c
> > @@ -623,9 +623,11 @@ static ssize_t export_store(struct class *class,
> >  	 */
> > =20
> >  	status =3D gpio_request(gpio, "sysfs");
> > -	if (status < 0)
> > +	if (status < 0) {
> > +		if (status =3D=3D -EPROBE_DEFER)
>=20
> This one fails to build here:
> linux/drivers/gpio/gpiolib.c: In function 'export_store':
> linux/drivers/gpio/gpiolib.c:625:18: error: 'EPROBE_DEFER' undeclared (fi=
rst use in this function)
> linux/drivers/gpio/gpiolib.c:625:18: note: each undeclared identifier is =
reported only once for each function it appears in
>
> There is no EPROBE_DEFER functionality on 3.2 and in gpio_request, so I
> think the patch can be safely dropped.
>=20
> [...]

Right, I'll do that, thanks.

Ben.

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.

--=-c5myi5uPBx/HfrbplrBo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUKVLQue/yOyVhhEJAQo7zBAAkX07GESTJdXJYYx5AW5fhceR3EhpuEJ+
qoVFBQlAyoFAd+jTKz11u6BskmCFxe54NbTlPipYEUtxH8b+azeasycmQ2E9SDgv
Hw9GYab5TScDAX/iFuQpdu22QdEJyhJ+iaTTlo7FS5ofvYNTHg0jSOsEVjicuSrB
Yl0cTwK6SYeo+soKn1LjK8mL/om6ySDFZIgVTGz1KDSiT3jC1keciPJidrvU8Yy2
SH43ypZmLhsMSQo85a/XdYADDbn4yOn0DpnjjQoK+PXN98JrNbfuJumgTC4m9F6u
phif43BScni6uVZLelJL0qa08YHP9ym+/lvfUNAzKL4857jjf4nTjFKTuI3d0CY3
f1LK8xARC2hkjHLrdM3rrG8NhbXzk5wIsLRg5/G/dhspf/AB/K+gJGkVdgzAsXSC
9Wt90wnQ299HPUSqxpMAG+QvSwCPD/uug2nH3Vq3EdGFtE4MdLHSY9qQcRqzHI+b
3s/iZGS5lKGsjFZk/4y153b/UL1HCpaJb8BvJRpiZnuzs/gANPIkG5/fzl5vrPZn
BXzWUBAdbdaA78l4uPh+5wDI9pfIRU8PAvN3Ohy8y0Yzs/4XhsKVZL44BOLCvZja
DV764a0qU8THGDCDn6n3YlXvjkYObppbmRQKYeodNtr8i+kg0TACXU76G9gv0k3W
LeE9B/+eFSg=
=My2b
-----END PGP SIGNATURE-----

--=-c5myi5uPBx/HfrbplrBo--
