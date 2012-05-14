Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab2ENKdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:33:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51082 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754997Ab2ENKdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:33:40 -0400
Date: Mon, 14 May 2012 11:33:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lrg@ti.com,
        b-cousson@ti.com, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/4] MFD: palmas PMIC device support
Message-ID: <20120514103334.GP31985@opensource.wolfsonmicro.com>
References: <1336960712-2812-1-git-send-email-gg@slimlogic.co.uk>
 <1336960712-2812-2-git-send-email-gg@slimlogic.co.uk>
 <20120514082832.GF31985@opensource.wolfsonmicro.com>
 <4FB0DDD7.8020803@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fjEAjMKpll6GDq3U"
Content-Disposition: inline
In-Reply-To: <4FB0DDD7.8020803@slimlogic.co.uk>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fjEAjMKpll6GDq3U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 14, 2012 at 07:26:31PM +0900, Graeme Gregory wrote:
> On 14/05/12 17:28, Mark Brown wrote:
> > On Mon, May 14, 2012 at 10:58:29AM +0900, Graeme Gregory wrote:

> >>  drivers/mfd/palmas-irq.c   |  241 +++++

> > The IRQ support here seems to be following a pretty common pattern for
> > dense IRQ maps - could we factor it out into regmap-irq?  It'd also be
> > nice if it were using an irq_domain - while it's far from essential it
> > is something Grant has been pushing and I believe it'll be required when
> > you do device tree support.

> The IRQ map is not dense. It is split into 4 registers which are not
> contiguous. I think the overhead of translating to 4 reqmap irqs would
> negate the point of using regmap irq. I can add to TODO to add this
> handling to regmap_irq.

If the register blocks are nicely spaced we can probably find a
framework way to do this. =20

> I am confused on the whole irq_domain business, is it replacement for
> sparse irq? I don't see many users in drivers/mfd and not much
> Documentation.

regmap-irq in -next as of today has an example of using them for this
type of device (and of course half the point of regmap-irq is that it
avoids individual drivers needing to worry so much about things like
this, they can just use data!).  I also posted a patch for wm831x though
that's got a bunch of noise in the function drivers due to passing the
interrupt numbers through as resources, the core should be fairly clear
though and is a bit more direct.

--fjEAjMKpll6GDq3U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsN94AAoJEBus8iNuMP3dfx4P/2JciwNFtQIGdZF3IjZRday4
XV33bZf+tYrZc48ge/go7P+nV3PDivIZ/CBpYXGeU/APyjCk2+cAvksQkNTgw9sl
uWph4NDYoZuAtkHh729gsYYPkm1SulhE/hkKEvZ/RpSFJj47twZvlfy3DZnfE9MM
Waoj2IjF0nYIgXY72RC9XnnBd6XLo2qqoX179s5B6yRwHSg1n2zAzep9HluwaNWH
LhFSsxxepPQgAkI/m7Iv8EO49ouOpaV0XYUNVtRh6utga/xcvZTg3jKbU/uIju4a
bT6JP784kapTCdIHX5EUYf+1V2j6PX4Lnbz9hdo7URdMJQ9FNFFGU1m09cw2Jcf9
4l0njMhkudSAykAkh8znMsjNT3QK4Jsd2EOe91CUwFkHsuQ2flG6aPWdqzuenIUH
QO16t27O6fJ/U+LCbxhsN05qUbGCaUmYVuBvXqoq9IQF68XuwT/6qKoTVadaz9ai
VqkCnVIN1i1eWD8qZC6Ae5u1+L/eZukSElpT+H8m2iZ5TQ6IFc+95z6SbzdopmD8
LwTlrngxPx4NuQduUiOhc0gpY/XW8QEJbwZBPuN+a06PZbYl8Hbg7PfLp/CDKIxG
c1JxvJvLPDpRgFuO9vGTEV5iBwIZEZoJ5coAVURh36YdWQ5hlSZ5KDA4LolpvIqM
4b1kPvVqwhZTuawgtR4T
=V6tX
-----END PGP SIGNATURE-----

--fjEAjMKpll6GDq3U--
