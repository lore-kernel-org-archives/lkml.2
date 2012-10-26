Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab2JZG0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:26:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36778 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab2JZG0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:26:32 -0400
Date: Fri, 26 Oct 2012 09:20:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Felipe Balbi <balbi@ti.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-input@vger.kernel.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121026062008.GA21734@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121024161429.GA16350@core.coreip.homeip.net>
 <CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
 <4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
 <20121024185818.GB772@arwen.pp.htv.fi>
 <20121025205901.GA3827@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <20121025205901.GA3827@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 25, 2012 at 09:59:01PM +0100, Mark Brown wrote:
> On Wed, Oct 24, 2012 at 09:58:19PM +0300, Felipe Balbi wrote:
>=20
> > need a way to tell drivers/base "hey, don't touch pinctrl at all because
> > I know what I'm doing" and that has to happen before probe() too,
> > otherwise it's already too late and, according to what you suggest,
> > drivers/base will already have touched pinctrl. The only way I see would
> > be to add an extra "dont_touch_my_pins" field to every driver structure
> > in the kernel. Clearly what you say is nonsense.
>=20
> I suspect that's not actually a big deal and that if we went down this
> route we'd have the driver take over control from the core code during
> probe() with the core still setting up the default state.
>=20
> Personally I do think we want to be factoring bolierplate out of
> drivers, if they're not doing anything constructive with pinctrl they
> should be able to avoid having code for it.  There definitely are issues
> to work through but it seems like we ought to be able to do something.

IMHO this will come back to bite you in the *ss. Specially when the same
driver is shared among multiple revisions of the same SoC or multiple
different SoCs.

Hypothetical situation: OMAP4 has keypad as the default pin mode and low
power is handled by the HW, so keypad could have pinctlr "boilerplate"
factored out. Then comes OMAP5 and low power mode has to be handled by
SW for whatever reason (maybe there are more than one low power mode).
Then we will need to patch omap4-keypad.c to remove "dont_touch_my_pins"
flag and add pinctrl support.

When you think of the possibilities of every single driver going
throught that it sounds a lot nicer to not make that decision IMHO and
keep pinctrl explicit.

This is not like module_*_driver() macro.

--=20
balbi

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiiu0AAoJEIaOsuA1yqRERi4P/25UPM0I00rC+y1mzIxVv9Uv
QUnLm6YLewXTTH/aEBQnJ7e6VCTuLfc8NXjSbGyvOxu1gESeSRPiBSr/meEwI2Cp
3aXxW/wt3Q4zSzbCzn6o1cN7Gk+2GQWs75kxVepvwMmgIuIg2b826yPFEzCu1DTo
YzEQz2oESCAGDk+ilLXxZ7J2Ozf6ZWHc8x2xSPQVLL4QgXUVo1ODIh0RSA95g6/4
pmjj0XtBoNkCSfZHfSa8PL/NISNok4vIanu8bH9TGCmoYOVJIp3ThWk+H6gnMasW
RqT6H6jMXc0+gRu+1irtnUXrNYyk/VdVvVomWDoGHQhXUuaMec8szm1CzvJpPY7v
mGVGZSiZaUrnOLYBtx5dYFlLxdkFDlo4Iaec5daBRBVmdoj27DtyRSdNwGqH3vj0
bW1sDGgld3ZSL2IbTdJkBdFVzUmPlpdFjWCTHpcQhW1BusL/kF4xM1ItxlXyZW1R
tVFEbKyt2zWy4OfSqmkzV6gp5/kDwCTSDYJeCgymsvYC4BRev/xU7buS5PZ5kAVx
6HMQwKWe4sGgFYJOv5Fd6MHAvTgtEU/CR9lbAe4fDnEfU5ro7ec/e3Z8evaNLGg0
mnsBd4o8wxNjAry1JuRffqrT7P5fcf0iU6DmHQooc1eD5Fq/RElgYp+JzvM7/4q5
YYJ5aOnic6wz5tKqtwWx
=oMXy
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
