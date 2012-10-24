Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965323Ab2JXTQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:16:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49022 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756276Ab2JXTQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:16:34 -0400
Date: Wed, 24 Oct 2012 22:10:42 +0300
From: Felipe Balbi <balbi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-input@vger.kernel.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121024191042.GC772@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121024161801.GB16350@core.coreip.homeip.net>
 <20121024165749.GB32220@arwen.pp.htv.fi>
 <64355430.MNHe7H1cg3@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Content-Disposition: inline
In-Reply-To: <64355430.MNHe7H1cg3@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 24, 2012 at 10:58:53AM -0700, Dmitry Torokhov wrote:
> On Wednesday, October 24, 2012 07:57:49 PM Felipe Balbi wrote:
> > Hi,
> >=20
> > On Wed, Oct 24, 2012 at 09:18:01AM -0700, Dmitry Torokhov wrote:
> > > On Wed, Oct 24, 2012 at 02:54:23PM +0200, Linus Walleij wrote:
> > > > On Tue, Oct 23, 2012 at 10:02 PM, Dmitry Torokhov
> > > >=20
> > > > <dmitry.torokhov@gmail.com> wrote:
> > > > > I have seen just in a few days 3 or 4 drivers having exactly the =
same
> > > > > change - call to devm_pinctrl_get_select_default(), and I guess I=
 will
> > > > > receive the same patches for the rest of input drivers shortly.
> > > > > This suggests that the operation is done at the wrong level. Do t=
he
> > > > > pin configuration as you parse DT data, the same way you set up i=
2c
> > > > > devices registers in of_i2c.c, and leave the individual drivers t=
hat
> > > > > do
> > > > > not care about specifics alone.
> > > >=20
> > > > Exactly this can be done with pinctrl hogs.
> > > >=20
> > > > The problem with that is that it removes the cross-reference
> > > > between the device and it's pinctrl handle (also from the device
> > > > tree). Instead the pinctrl handle gets referenced to the pin contro=
ller
> > > > itself. So from a modelling perpective this looks a bit ugly.
> > > >=20
> > > > So we have two kinds of ugly:
> > > >=20
> > > > - Sprinke devm_pinctrl_get_select_default() over all drivers
> > > >=20
> > > >   which makes pinctrl handles properly reference their devices
> > > >=20
> > > > - Use hogs and loose coupling between pinctrl handles and their
> > > >=20
> > > >   devices
> > > >=20
> > > > A third alternative as outlined is to use notifiers and some
> > > > resource core in drivers/base/*
> > >=20
> > > OK, so with drivers/base/, have you considered doing default pinctrl
> > > selection in bus's probe() methods? Yo would select the default
> > > configuration before starting probing the device and maybe select idle
> > > when probe fails or device is unbound? That would still keep the link
> > > between device object and pinctrl and there less busses than device
> > > drivers out there.
> >=20
> > it starts to become confusing after a while. I mean, there's a reason
> > why all drivers explictly call pm_runtim_enable(), right ?
>=20
> Right. Because not all of them support runtime PM and quite usually their
> PM methods are not ready to go until initialization is complete. And agai=
n,
> the driver here controls its own behavior.

likewise not all devices will need pin muxing, those which do (granted,
an increasing number of them since transistor size continue to shrink,
allowing chip manufacturers to pack more features inside a single die,
while the number of external pins/balls remain the same), will call
pinctrl to setup muxing right.

> > From a first thought, one could think of just yanking that into bus'
> > probe() as you may suggest, but sometimes the device is already enabled,
> > so we need extra tricks:
> >=20
> > pm_runtime_set_active();
> > pm_runtime_enable();
> > pm_runtime_get();
> >=20
> > the same could happen with pinctrl eventually. What if a device needs to
> > do something else (an errata fix as an example) before requesting
> > pinctrl's default state ?
>=20
> That is a valid concern and we'll need to find a compromise here. As I sa=
id,

WHAT ?? Silicon erratas are not a valid concern ? Power waste isn't a
valid concern ? Tell that to the millions of devices shipped with Linux
everyday. Power usage if it's the top concern in any product, is right
there as the top five. Likewise for silicon erratas.

Let's face it, just like SW, HW has bugs; the difference is that no
company will continue to do several spins of an ASIC just because some
SW engineer doesn't get concerned about a silicon bug. It's just too
expensive to re-spin the ASIC. And even if we get another revision of
the ASIC, we still need to support the older version as there might be
cellphones, laser welding machines, IPTVs and whatever product already
shipped.

> I am not saying that no driver should ever touch pinctrl. I can see, for
> example, input drivers actually disabling pins until they are ->open()ed,
> in addition of doing that at [runtime] suspend/resume. But it would be ni=
ce
> if we could have "dumb" drivers not care about pins.

Like I replied on another sub-thread, this will just create exceptions
to the rule which is far more messy than having a couple of extra lines
of code in a few drivers. We can even argue that eventually all drivers
will need to toggle pins in runtime in order to save that extra
microwatt of runtime power consumption, so why bother adding exceptions ?

In fact, we already have the exception: drivers which don't need to
fiddle with pin muxing, just don't use pinctrl. The ones you're
receiving today are the one which, for whatever reason, need to make
sure pin muxing is right. If it's not toggling in runtime, it might just
be because $AUTHOR decided that it would be best to do thing in small
steps (don't we all agree with that ?). Maybe he thought that changing
pins in runtime could cause problems, so let's get bare minimum in
mainline and work towards optimizations in parallel.

All in all, I don't see why you're complaining so much about a couple of
lines of code. Even if it needs to be added to all drivers in tree. So
what ? As long as pinctrl works fine in multiple platforms, what is done
for e.g. OMAP2 should work fine in OMAP3/4/5. An even more complex
example: what works on OMAP, should work on Exynos, Tegra, etc, if the
same driver is used accross those platforms.

--=20
balbi

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiD0yAAoJEIaOsuA1yqREwJAP/A26vzUAro0LLA4VS11bijV4
uJNkzWUvhS0ZN9YCDlU4DVcGUWbuaH5CHFAk0jqHfq8X3caIFRMqxPd84b4Isc7M
gQn2Jp+RaPsp5aNttMNOexn9OsM0G8ZD5Ro3zoPueP09GPCQ4+Tb4sfp4a59a4d3
fNEZfvqXdrxfK25e5n45Gs38n5zyNpGbZXaXwjvHFNx1pCG1I4WeHNKeJZ6hNscX
Kzm1u0u4K2CvTkJrU87B6tMqLg3v4mjUH2cvLmZ2i7yL6G/ZL9qDMx7OuM/sZiK1
TGy17zZurJ4qb8WVZyz57Y7AmwtvON1twtRR8BqLQ6PpRBPsrUNoJ67BJrsVOKc3
hoqFFOi5D6qokaCF4OmQ3Yj7S/Q5zYZs9g+79E36jUQxFFChFz4oURJZBqEWxWcB
7U7uoVQwQ8n9cufxdzErfaUImGFE2RtmkIwUTm/frA9Nj7X5ktCqY2z4vlzPOAKs
wTS+qSVVw8wF5oauwc1SqH7Sz+/mStaklUeHrU6UuTwdx+l8wWw5VtRIZqgcgVM4
zwEyZJ3gs7yqW9m5C2O50caMqfXOtdFjLq+nkOQUS5SKR3BVSV1wiSIh66/MgDH1
c034rvZkJh1XdOL5Hc4GEw9DDR2L30+0Rq1QB5WSbG8Z278QA34Zsu2J0pyYiLew
BVFR5Xz+mEEKasPlbu9L
=EAwv
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
