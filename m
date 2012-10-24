Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab2JXRFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:05:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42563 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756276Ab2JXRFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:05:07 -0400
Date: Wed, 24 Oct 2012 19:57:49 +0300
From: Felipe Balbi <balbi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-input@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121024165749.GB32220@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121022155028.GA13791@core.coreip.homeip.net>
 <508660D4.9030507@ti.com>
 <20121023200249.GA2712@core.coreip.homeip.net>
 <CACRpkdYwA7O8AqB8YFCK-c3e6-7FcbhMOiPEUq-cKJni_PO-Ow@mail.gmail.com>
 <20121024161801.GB16350@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5I6of5zJg18YgZEa"
Content-Disposition: inline
In-Reply-To: <20121024161801.GB16350@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 24, 2012 at 09:18:01AM -0700, Dmitry Torokhov wrote:
> On Wed, Oct 24, 2012 at 02:54:23PM +0200, Linus Walleij wrote:
> > On Tue, Oct 23, 2012 at 10:02 PM, Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> >=20
> > > I have seen just in a few days 3 or 4 drivers having exactly the same
> > > change - call to devm_pinctrl_get_select_default(), and I guess I will
> > > receive the same patches for the rest of input drivers shortly.
> > > This suggests that the operation is done at the wrong level. Do the
> > > pin configuration as you parse DT data, the same way you set up i2c
> > > devices registers in of_i2c.c, and leave the individual drivers that =
do
> > > not care about specifics alone.
> >=20
> > Exactly this can be done with pinctrl hogs.
> >=20
> > The problem with that is that it removes the cross-reference
> > between the device and it's pinctrl handle (also from the device
> > tree). Instead the pinctrl handle gets referenced to the pin controller
> > itself. So from a modelling perpective this looks a bit ugly.
> >=20
> > So we have two kinds of ugly:
> >=20
> > - Sprinke devm_pinctrl_get_select_default() over all drivers
> >   which makes pinctrl handles properly reference their devices
> >=20
> > - Use hogs and loose coupling between pinctrl handles and their
> >   devices
> >=20
> > A third alternative as outlined is to use notifiers and some
> > resource core in drivers/base/*
>=20
> OK, so with drivers/base/, have you considered doing default pinctrl
> selection in bus's probe() methods? Yo would select the default
> configuration before starting probing the device and maybe select idle
> when probe fails or device is unbound? That would still keep the link
> between device object and pinctrl and there less busses than device
> drivers out there.

it starts to become confusing after a while. I mean, there's a reason
why all drivers explictly call pm_runtim_enable(), right ?

=46rom a first thought, one could think of just yanking that into bus'
probe() as you may suggest, but sometimes the device is already enabled,
so we need extra tricks:

pm_runtime_set_active();
pm_runtime_enable();
pm_runtime_get();

the same could happen with pinctrl eventually. What if a device needs to
do something else (an errata fix as an example) before requesting
pinctrl's default state ?

--=20
balbi

--5I6of5zJg18YgZEa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiB4NAAoJEIaOsuA1yqREAMkP/ipXmBlxueN8Im1ahubV0l98
9BE60/Y1t6w77cJwWhc6A+e22JtRK4k0PutGi/MlU9yu+aVJxToPPOd1HIgoNf7D
MWoWsvGdG0+zTLQnHRl3lLOeHYQYNHDj5r42+NXVDPxfsbvHbsO6+ehsAZtcjLsR
g8Kx6fDtCZidOsc7acx5G2mOJOUSR/G11E/hQArM+UlbE8a4qVtq3WAcnrBkjYeF
QpK/43LHGCP4hLyUiQ016EAJ4E/vUB73FwSv7RYv9Q7ElD9XvvhrPG2z3uPNuq2V
XX6rK+9p3QQTf31JEZsRoOQcuQ5cwIeyCarH0zprM9lFjvhzS86ApYO/K4g8Y/n8
yqc/ZlmWDzhhCyHWFfr7K+dGVoO6B3Tc3UdXMWkW0TfeK1P+Aewtbhg6ZLSgT/hg
jOINksB7sQDxYBFW2aJ0fETRmoAHuU6EaMZINW7mb0+x9Xvu3aRegQ9vNb4oAFzo
v1Cp21mF4TT0jCAyisRLRl16qqeyyoZsmBhc1hlvPXU+zcgWUbfAu1WB2wYtUdis
7Bc7H141IWjnBBl2wDbn94n24kF8A2Kzl/WdWaq+aUmdSPsDkcVSyUZ8OKan/q2X
0cZShIlOM+zaDMwbfjzchn0dOC1fvoFxfAgM50WJadQSQ9ao91dlLiKtRm0AQ9Gx
tO6YVfnEMDR0P9DtmuvK
=0MoT
-----END PGP SIGNATURE-----

--5I6of5zJg18YgZEa--
