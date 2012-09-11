Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab2IKMBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 08:01:52 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:51674 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932143Ab2IKMBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 08:01:51 -0400
Date: Tue, 11 Sep 2012 14:57:19 +0300
From: Felipe Balbi <balbi@ti.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Ryan Mallon'" <rmallon@gmail.com>, balbi@ti.com,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: samsung: use pr_* instead of printk
Message-ID: <20120911115716.GI18907@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <002f01cd8f4b$b1100a30$13301e90$%han@samsung.com>
 <20120911063048.GA18072@arwen.pp.htv.fi>
 <002201cd8fe8$2aafa070$800ee150$%han@samsung.com>
 <504EDEA1.1050108@gmail.com>
 <002601cd8feb$7aa51c60$6fef5520$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3eH4Qcq5fItR5cpy"
Content-Disposition: inline
In-Reply-To: <002601cd8feb$7aa51c60$6fef5520$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3eH4Qcq5fItR5cpy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 11, 2012 at 04:02:59PM +0900, Jingoo Han wrote:
> On Tuesday, September 11, 2012 3:48 PM Ryan Mallon wrote
> >=20
> > On 11/09/12 16:39, Jingoo Han wrote:
> > > On Tuesday, September 11, 2012 3:31 PM Felipe Balbi wrote
> > >
> > >>
> > >> Hi,
> > >>
> > >> On Mon, Sep 10, 2012 at 08:59:11PM +0900, Jingoo Han wrote:
> > >>> This patch uses pr_* instead of printk.
> > >>>
> > >>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > >>> ---
> > >>>  drivers/gpio/gpio-samsung.c |    6 +++---
> > >>>  1 files changed, 3 insertions(+), 3 deletions(-)
> > >>>
> > >>> diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsun=
g.c
> > >>> index ba126cc..e38d990 100644
> > >>> --- a/drivers/gpio/gpio-samsung.c
> > >>> +++ b/drivers/gpio/gpio-samsung.c
> > >>> @@ -45,7 +45,7 @@
> > >>>  #ifndef DEBUG_GPIO
> > >>>  #define gpio_dbg(x...) do { } while (0)
> > >>>  #else
> > >>> -#define gpio_dbg(x...) printk(KERN_DEBUG x)
> > >>> +#define gpio_dbg(x...) pr_debug(x)
> > >>>  #endif
> > >>>
> > >>>  int samsung_gpio_setpull_updown(struct samsung_gpio_chip *chip,
> > >>> @@ -926,10 +926,10 @@ static void __init samsung_gpiolib_add(struct=
 samsung_gpio_chip *chip)
> > >>>  #ifdef CONFIG_PM
> > >>>  	if (chip->pm !=3D NULL) {
> > >>>  		if (!chip->pm->save || !chip->pm->resume)
> > >>> -			printk(KERN_ERR "gpio: %s has missing PM functions\n",
> > >>> +			pr_err("gpio: %s has missing PM functions\n",
> > >>>  			       gc->label);
> > >>
> > >> I would rather see dev_* conversion instead.
> > >>
> > >> my 2 cents
> > >
> > > Hi Felipe Balbi,
> > >
> > > OK, I will replace printk(KERN_ERR...) with dev_err.
> > > Thank you.
> >=20
> > I was going to suggest that also, but I don't think that there is a dev
> > pointer to use. The gpio_chip structure has an optional one, but from my
> > quick glance it didn't look like the Samsung driver was using it. I
> > could be wrong though. If I am, go with dev_err (and dev_dbg for
> > replacing the gpio_dbg statements).
>=20
> Also, I cannot find dev point to use.
> I will use pr_dbg, pr_err.

Now that I look at the driver, the missing dev pointer is just because
gpio-samsung.c is NOT a proper driver. I'd strongly suggest to convert
the driver to a proper platform_driver, but it's your call anyway ;-)

my 2 cents

--=20
balbi

--3eH4Qcq5fItR5cpy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQTyccAAoJEIaOsuA1yqREIsMP/3trgnz77BH6gQ69CqX3DoI3
QFvGbHTEVqM5FOkBLDPO4rSwT6jr1bdPZk3rL7GM2lAE9DtTSsId3aXxE1z1g4jB
qkyFXLWzHZtRAX34uS4UC9+jZWRq6sPqH5BpKL3HYMWcNLLuRdtZNcAcLGhuwCTt
DUj2LtIzUnQa9vlJ2M+9Lxy9skiliJu+SUIIJY8FHUBMORDY7Yo3oRalTdtsBa6p
jjo3R3RKKVghtVQZ7bU2QkNCDAe+r/tfj7AZwQwZqOVU0zuTht4JibRXAb9PrTZa
HBUUML2HcCAvtximGOM7VxgCHiR4VsMUimbOKj65c41mg9ukPHu7i2y7bkkBR60U
YWxLKccmBcvHvssDICH5pi6KQDPuTiyo9Uta4invIs0GGUx51Hom52UdJnFJX5MN
QAoWqCyLNugY4E9Kdo7e5ou0yuxUrHoUH9xJjn+puU50HwwqAMlTgB0JvCcauPeT
/Zy+W6YvRcaA7bzqm7SQKKkrT11EnkRNmfqcduFtCWHM0w9rrTKDlXB53fxvRCaZ
qXZBvQ2SLgnpBZkO+Ex+s2o4b/S0Ne9ltEty78b95B6eytM5SesSYU3IFtvnaHKd
8j1Uv5TZRck8HO8w5bIJZT1Ro3AIujgyOntvC+AD88LwiydgdVpPrCXj1ZXdhGBb
DUNj5IB+IwFC1LByJKUg
=uoNH
-----END PGP SIGNATURE-----

--3eH4Qcq5fItR5cpy--
