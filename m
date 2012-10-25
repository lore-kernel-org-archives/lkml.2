Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975Ab2JYQGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:06:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50267 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759905Ab2JYQGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:06:53 -0400
Date: Thu, 25 Oct 2012 17:06:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca
Subject: Re: [PATCH v2 2/4] gpio: add viperboard gpio driver
Message-ID: <20121025160651.GO18814@opensource.wolfsonmicro.com>
References: <20120925085559.GL28670@sortiz-mobl>
 <201210251202.36708.poeschel@lemonage.de>
 <20121025140013.GK18814@opensource.wolfsonmicro.com>
 <201210251802.42349.poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nljfjKcp9HDtPSOP"
Content-Disposition: inline
In-Reply-To: <201210251802.42349.poeschel@lemonage.de>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nljfjKcp9HDtPSOP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 25, 2012 at 06:02:42PM +0200, Lars Poeschel wrote:

> On Thursday 25 October 2012 at 16:00:13, Mark Brown wrote:

> > Why would you want to implement this as a bus?  If you're not actually
> > rendering things down into a register and value on the bus then you
> > should be hooking in at the level before we do the marshalling since
> > that's totally irrelevant.  This should be done by making the
> > marashalling pluggable.

> Did you have a look at the code ? I want to render things down to registe=
rs=20

No.

> and values on the bus! In the one and only case a pin is set to be an out=
put=20
> and someone reads it's value, I don't want the bus to become active and=
=20
> instead read the value from the regmap cache.

Are you saying that whoever designed this USB device has done it so that
it takes a byte stream with something like RRVV where RR is the register
and VV is the value?  That's the marshalling, as you'll have seen that's
done before the buses see the data.

> > What do you actually need to read back here?

> Someone reads a gpio value register. To be able to decide if I really hav=
e to=20
> do the read on the usb bus or if I can use a cached value, I have to know=
 if=20
> the pin in question is an output or an input. To get this information I h=
ave=20
> to do another register read. If it's an output I give back the cached val=
ue,=20
> if it's an input I do the register read.

Is the I/O selection per GPIO or per device?

> > So just invalidate the cache and it'll get restored next time we look at
> > the register.

> Yes, this is exactly what I gave as an alternative in my second to last m=
ail.=20
> But this invalidates the whole register map although I just want to updat=
e=20
> one register value.

So add that functionality to the core if it's not there.=20

--nljfjKcp9HDtPSOP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiWOUAAoJELSic+t+oim9KOgP/3XO+biAMJFmOQm+RRqGUXRW
8L3d3uafXwRibbqmWFAtHakoOGoeS0PWjU8vL+LEEvQIIuQF3YqTOV/1ELTeonq3
DIe0Z9cDlUmWq4Coc1H7TKTp1F/3GPmjsXnvM17Z7YUogthnstvuGkKGtxHS9vGM
qLoKwj9pMjAsql4PMm+RB2dRImLiGP6OKGRdEfbK4FiHM9Naj9RKATLQHCVdCGWN
KOTmkG4qeXruKEftzFUdSiV1DZe/6i5UsTu3fZjtvVV3OT/CNzAlUZgDHPC+2mMG
WOWDocKtptPYPEUJKnkHxi9OTWWwhNDm+fVCNx7+hoG3HlXs3Chww20CP14f8BUu
FW4V+cXH++q2L73alz+Ff1kg0ZH4YFt0UhM7rzcFeRh6965fSGhY+CUNq7o/vf1j
VmBiTdlwKc78NixB8wglIs0c36ETipd3h691QViJ7WAHzu7PyB6CGTv5E+963nn2
qdqngxfGyOfNShdDv0qrIC1QKni+xMNq4rzikKqgzPTHt0hLT9zcT9SThUA7RZUe
gRclEfWS2SOplLm7yWypMaA0z5liYaDV3pafUA7KYNm4hFqSUZzTGKbl2ROvXMKn
oS2vHnt/JmrBhVZXSL5M8RWu76+4vdYrDwnU6yDAssUhI3krkzrjv66/MzseVkVn
KPiaXcEEAPp0mXEiP99o
=O1SD
-----END PGP SIGNATURE-----

--nljfjKcp9HDtPSOP--
