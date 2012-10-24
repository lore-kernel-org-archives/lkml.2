Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935191Ab2JXQb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:31:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40656 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932242Ab2JXQb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:31:58 -0400
Date: Wed, 24 Oct 2012 17:31:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lars Poeschel <poeschel@lemonage.de>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca
Subject: Re: [PATCH v2 2/4] gpio: add viperboard gpio driver
Message-ID: <20121024163155.GH18814@opensource.wolfsonmicro.com>
References: <20120925085559.GL28670@sortiz-mobl>
 <201210161538.29571.poeschel@lemonage.de>
 <CACRpkdauWR-ndvPA4Q5k_boh1OvYpPWMcfSkCdvRTK9wjHLo3Q@mail.gmail.com>
 <201210231724.33927.poeschel@lemonage.de>
 <CACRpkdZ3=VFOHqmo=XbyDGUKoxFaG+PpzDUsBQTQ1O3F-DhTvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X+8siUETKMkW99st"
Content-Disposition: inline
In-Reply-To: <CACRpkdZ3=VFOHqmo=XbyDGUKoxFaG+PpzDUsBQTQ1O3F-DhTvg@mail.gmail.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X+8siUETKMkW99st
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 24, 2012 at 09:53:06AM +0200, Linus Walleij wrote:
> On Tue, Oct 23, 2012 at 5:24 PM, Lars Poeschel <poeschel@lemonage.de> wrote:

> > Ok, I tried to implement it (at least for the gpioa part of the driver).
> > It does not work. I got stuck. There are three problems I could not solve:

> So I'm looping in Mark Brown to get some hints whether the following
> can be resolved easily or needs to be given up on...

Some context would've been enormously useful for working out what the
discussion is all about...  this is *very* verbose and not at all clear.

> > Setting the direction to output is an atomic set direction and set value.
> > The register number is different from setting the value only. So after a
> > successful call, I want to update the cache of output value using
> > regcache_write. This is also not publicy available api. The only thing I could
> > do is invalidate the whole cache using regcache_mark_dirty. (3rd problem)

> Same thing.

The above doesn't sound like marking the register as dirty is going to
be helpful...  at most you'd want to discard the cache which is already
supported per register.  Marking the register as dirty would leave the
existing (presumably wrong if there's a problem) value in place in the
cache.  It's not at all clear to me that a cache is even useful for
these registers.

> > I attach my current working state here. This is NOT WORKING and only as
> > reference.

> So if you want to do this with regmap, I suggest the way forward would
> be to go solve it at the root by implementing something like
> drivers/base/regmap/regmap-usb-ctrl.c with your desired semantics
> and using that.

So the issue is that we're trying to use regmap for some USB device?

--X+8siUETKMkW99st
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiBfzAAoJELSic+t+oim9mLgQAJnejXNwc1SjCeKIOGH5v3M2
9B9L7Ntg7EA4f8UyR2UaHKxG+eoYtJxgj/oatohKdnXLglDsKwXgy23FsOagSLni
1EM+uRBQPl21pIIdrwjbSwo1Ns3CmCqnoPUzscXM4dhfI9AJTBH0V85aQQEe4JFJ
U5YW4mX8Ctjkm+7NV4wcYdxY1o5EiK3WsM4coGuhUUVqm4eR9O7laoTwhBu4MeYH
HxB5i5rmrrwnZiy0UyspkWYbMPcmtGKukacHSSI9m5md45qQzNuSFySKgAsXdPFX
jFeVEI7J9nMmDYH0EnsFdVaz+y51KIrnQ5y7XUCR6zOxxGU2Dx/ScpjjbU6WPj81
KHGC1PWwIXK+jEco2swTjIi5wW+VpHI8uioh0g8tzBrsOkmM+V6Fhhi7Xw0GYwlp
kKx9bpT4uM4oNyNwYVXTP7AK+BKEKcRzX4vDLbPAeNVcY6bCkuia1NWwkaHa7Ur7
v+PsLeG0nL7SO2m63R2FrL5LrliYaDpKhAVXdLFPDLZOFbPMs/dMJZPmtUfEJ6HG
zUsyVjaGK0TUc+P2RpsnMLulPh2E536gT5TV0n1xvE5BBtQi5YrmeAPJ3jF6VRm5
o2EiX1lRfjHr2KI5tHfi49nVQD088+eEiwWs4jSLZNlTT9hsXbsDZGy2WdoW09ng
Ho3z97yZ9kqOYen2EJ94
=qmTD
-----END PGP SIGNATURE-----

--X+8siUETKMkW99st--
