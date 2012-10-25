Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946038Ab2JYOAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:00:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49391 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945982Ab2JYOAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:00:17 -0400
Date: Thu, 25 Oct 2012 15:00:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca
Subject: Re: [PATCH v2 2/4] gpio: add viperboard gpio driver
Message-ID: <20121025140013.GK18814@opensource.wolfsonmicro.com>
References: <20120925085559.GL28670@sortiz-mobl>
 <CACRpkdZ3=VFOHqmo=XbyDGUKoxFaG+PpzDUsBQTQ1O3F-DhTvg@mail.gmail.com>
 <20121024163155.GH18814@opensource.wolfsonmicro.com>
 <201210251202.36708.poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rnP2AJ7yb1j09OW/"
Content-Disposition: inline
In-Reply-To: <201210251202.36708.poeschel@lemonage.de>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rnP2AJ7yb1j09OW/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 25, 2012 at 12:02:36PM +0200, Lars Poeschel wrote:

> You can reread our conversation before Linus Walleij brought you in start=
ing=20
> with my first patch submission here:

> https://lkml.org/lkml/2012/10/12/218

This has all the problems of this and your previous mail - here we've
got about 40 lines of unbroken text (with very wide lines too, notice
how things start to wrap when I quote them) none of which is easy to
read.

> As there is no general regmap_bus for reading/writing registers over USB =
(and=20
> probably will never be). I had to implement it in my driver for the speci=
al=20
> case of this device. I also have a regmap_config, that provides a volatil=
e_reg=20
> function. I need this to decide if the pin the value is queried is an out=
put=20
> or an input. In the latter case I obviously can't use the cache, in the f=
ormer=20
Why would you want to implement this as a bus?  If you're not actually
rendering things down into a register and value on the bus then you
should be hooking in at the level before we do the marshalling since
that's totally irrelevant.  This should be done by making the
marashalling pluggable.

> case I want to use it. Here the first problem arises. In the volatile_reg=
=20
> function I can not do a read of a regmap register since regmap internally=
 uses=20
> a mutex lock. Thus I have my own cache in a device private variable. This=
 is a=20
> bit strange. To use the cache to have to implement my own cache ;-)

What do you actually need to read back here?

> The other problem is, that the volatile_reg function is called with struc=
t=20
> device and I can not container_of up to my device vprbrd_gpio struct, sin=
ce=20

Why on earth can't you do that?  That sounds like something that should
be fixed for whatever bus you're using if it's an issue but normally
this is simply a case of setting and reading some driver data.

> The last problem is that I have 16 registers for setting/reading the firs=
t 16=20
> pins value. And there is another 16 registers for setting the pins direct=
ion=20
> (input/output). Setting the pin to output is an atomic operation of setti=
ng=20
> the pins direction AND setting it's value. So if there is a set pin direc=
tion=20
> to output operation in my driver I want to update the value of the=20
> corresponding value register, since regmap does not know of this change. =
But=20
> the regcache_write I would use for this seems also not intended for use b=
y=20
> drivers. It is not exported.

So just invalidate the cache and it'll get restored next time we look at
the register.

--rnP2AJ7yb1j09OW/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiUXmAAoJELSic+t+oim9xNUP/2nYkOwqPERMu5jzfom50Ha1
7GUfsCkRFZU+TAhBcZNFZljsRGlBeafpJRQ1fwoNQ+kwvjnpAo4rfMy8AEgz9NHO
7yjkMDj8w8iuY5GL01p3PStGHFne2FkONb8ByFIfY5VaCAQtqUUqwQcBNtYHkNNf
3MhL7hWXOCQpqA94PKEAXr6XxAH4jQ9wPxayL7CWHemarvlUKBtwcmx37ddDPupu
sn5DQA31D1Kc3nDzq5jL87rKnD9Pfl/kOG4sqFelBOuQ0vsnZvnid2DIFUCF4wo9
mfdEa8FHcTdYNRqW0FKTm1PsnpNzEevViwevQwU6VCScwTsGItzCn0MJY/DWwrrB
nKDoWS29fHZIt7WBtL5n4cczvVKpNK0yIXS3N53Dq3LHrukqG1/Sw9VBynzsRQvF
W6QKFtuubVszr/28186vpp8MVN6Ed1/k9A0ek3JPklrdhLYm88YvD5A8Iv6AjYoc
RFvHW78fwBbu0Xa69Sf5Q+KsXFg2TFsZuHof5QWDA9B9FhmkyrsvSbi37Mn3JC+e
MEO4TGZZ2QwZmgeQMu2RNpK6+ZUQT55FK91jZxltMPJXQmH77FzklqW5JxGCKMvb
0g53Xf7G4VzRbykwLOoZ1w3tbnhFToJvbp6Du4ziDTT6Tl8eQy0MC99TGPMcStpF
JsUbVXCg4JR/cWoA+UsE
=MEaq
-----END PGP SIGNATURE-----

--rnP2AJ7yb1j09OW/--
