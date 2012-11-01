Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab2KANMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 09:12:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53513 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab2KANMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 09:12:34 -0400
Date: Thu, 1 Nov 2012 15:06:36 +0200
From: Felipe Balbi <balbi@ti.com>
To: Koen Kooi <koen@dominion.thruhere.net>
CC: "Cousson, Benoit" <b-cousson@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>, <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        <linux-omap@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Message-ID: <20121101130636.GB12489@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <50918223.6080003@ti.com>
 <8AD2F7AF-8315-442B-A394-1A38DAB29F52@antoniou-consulting.com>
 <20121031212639.GQ12739@atomide.com>
 <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com>
 <20121031221402.GA29490@arwen.pp.htv.fi>
 <E4EE0D1F-C7AC-4620-86F2-D9C7C56E279F@antoniou-consulting.com>
 <50924DA3.1060901@ti.com>
 <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com>
 <50925C49.7060004@ti.com>
 <CBDE21C5-1980-4BDC-9153-7653A07D0024@dominion.thruhere.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oC1+HKm2/end4ao3"
Content-Disposition: inline
In-Reply-To: <CBDE21C5-1980-4BDC-9153-7653A07D0024@dominion.thruhere.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oC1+HKm2/end4ao3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 01, 2012 at 01:00:21PM +0100, Koen Kooi wrote:
> tl;dr: please suggest an actual solution that allows plug&play when
> plugging in multiple capes and applying power after that. Preferably
> one that doesn't pass the buck to u-boot.

I can think of a few ways:

1) ship your distribution with all necessary drivers and let udev handle
	driver probing.

	clearly this will require constant updates for the distribution
	as new capes are developed. But IIUC, that's the same with
	Arduino where new "libraries" are added to the Arduino OS.

2) ship with drivers for EEPROMs only and setup a repository of drivers

	this would require every driver to be packaged separately, then
	you create a setup where bone's userland will use EEPROMs data
	to figure out which drivers it needs, pass that information to
	SDK via USB, then SDK downloads all necessary/missing packages,
	sends them to bone via USB and all packages are installed on the
	bone.

	Note that since packages would be 'installed', this would be a
	one-time-only thing.

3) realize that if your user can build an FPGA cape, s/he can most
	likely write code and adding/recompiling kernel shouldn't be the
	biggest of his/her worries

	(no comments to this one, I understand it's not feasible)

in any case, capebus sounds like something which is hugely unnecessary.

ps: at least for the I2C subsystem, i2c-core can detect for you if your
driver provides ->detect() method.

> Op 1 nov. 2012, om 12:26 heeft "Cousson, Benoit" <b-cousson@ti.com> het v=
olgende geschreven:
> >>> FWIW, we do have a similar, but simpler, problem with the beagle /
> >>> beagle-xm and panda / panda-es. But for the moment we are just
> >>> using a different DTS for each board.
> >>=20
> >> A different DTS for each board combination... There alot more capes
> >> for the bone that they are for the beagle & the panda.  And more
> >> are going to come, but not necessarily from people that have any
> >> connection to TI or CCO.
> >=20
> > Sure, but my point is that your solution will not solve our problem
> > :-)
> > This is a generic problem that you address with a very custom /
> > specific approach.
> >=20
> >> You still haven't described how I could solve the issue of
> >> conflicting capes using a single DTS.
> >=20
> > Well I don't have the solution otherwise I will have done it already
> > :-)
> > My point is that the solution has to be in the DT core if not in the
> > bootloader.
>=20
> <snarky comment>So when we at beagleboard.org handled the beagleboard
> and beagleboard xM expansionboards in the bootloader (detection,
> muxing, etc) we were told it was wrong and we should handle it in the
> kernel and if we waited a bit, DT would solve everything. And now that
> we actually handle it in the kernel you are saying that it is wrong
> and we should handle it in the bootloader and that DT won't solve
> everything. I guess someone will now tell us that uEFI will fix
> everything.</snarky comment>
>=20
> Apart from that, you and others still fail to tell us how you want to
> handle a user (or customer) that buys a beaglebone, an LCD cape, a
> weatherstation cape and a geiger counter cape and plugs those together
> and powers them on. With the evil TI vendor tree and extra patches the
> boardfile reads the eeproms and tries its best to instantiate all the
> platform data. One of the capes won't have working LEDs since
> appending to the leds-gpio struct is pretty much impossible in this

couldn't you just instantiate multiple leds-gpio device ?

> situation. But it gets a picture on the screen, blinks LEDs and does
> largely what the user expects.
>=20
> With capebus we get:
>=20
> 1) da8xx-fb which lacks DT bindingsp[1] receives plaftorm data to
> match the LCD

this is something which could be fixed at the driver level, right ? :-)

> 2) the i2c sensors on the weathercape are registered

that will work with or without capebus.

> 3) the one-wire bus on the weathercape gets registered

also should work with or without capebus.

> 4) the LEDs on the lcd cape get registered5

also works with or without capebus.

> 5) the LED on the geigercape gets registered and adds a custom trigger

also works with or without capebus.

> 6) the ADC, which again, lacks DT bindings[2], receives plaftorm data
> and a custom IIO binding

driver problem.

> 7) pinctrl sets the pinmuxes for the above

also works with or without capebus.

> In other words: plug & play, even for devices with drivers that are
> still lacking DT support.=20

I _do_ agree with you that we could have a "grace period" where DT and
non-DT would boot together, but apparently that's not something which
isn't trivial to do.

I guess Benoit might also be concerned that if we add such an
infrastructure than conversion to DT will never finish heh.

> Now please explain to me why you think it's such an awesome idea that
> the users will need to find the right dtsi files (multiple revisions
> of the lcd cape exist), include them in the dts, run dtc, add a few
> missing semicolons, run dtc again, copy it over to /boot and reboot to
> have a change of making it work?

that shouldn't be necessary. At least for all the I2C devices, you can
just implement ->detect() and it will just work. Maybe similar tricks
can be done for 1-wire and SPI, I haven't looked into the details of
those buses to be sure, though.

> I know you can't escape that for new or custom capes, but I do want
> all the capes my company assembles work out of the box.

then push all drivers to mainline and start shipping your boards with
those drivers enabled.

> (Cross)compiling a kernel is a bridge too far for 95% of the intended
> audience.

Agreed, but that doesn't prevent you from either shipping distribution
with drivers enabled or providing pre-compiled modules.

> With capebus most capes can be supported by editing the DTS, your
> bootloader proposal involves updating u-boot for every new cape as
> well. That is downright scary. The RMA department will get flooded.

that's not true at all. If capebus can do all that from within kernel,
it surely can do the same (with a few changes here and there) from
within bootloader.

> More importantly: capebus is generic enough to work on beagleboard,
> beagleboard xm, panda, panda es and even raspberry-pi. Basically on
> any DT capable platform.

that doesn't matter much I guess. MTP is so cool that works on Exynos,
OMAP, Tegra, x86, Cris, AVR, etc etc etc and we still don't have an MTP
stack inside the kernel (ok a bit sarcastic... but you get the drift,
hopefully).

--=20
balbi

--oC1+HKm2/end4ao3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQknPcAAoJEIaOsuA1yqREjWcP/2AAhjzPNC4Yd/ouXXlrAeLW
GQMGvgnv7pSEc5NTFnNaIt1MD7jVzJBRLSnyElS/VMcSXNrehy58JOViBxLCYzIc
xasIsQfNNPUz1a+x5Wgqr9TACWH76lQJLSwGJSjv2UBXuY3A+BxuuE3MZaN5EPeD
aHK+GWEVUdrbH+eL2Mnmslic4ES8HCOIeWh+c+qLKdkYp5QWpNY2LUz6uqWAChEO
SMGOZldBmBmyC85OeGcv9l5UTwik/DjgVkaN+/Ge8JrAH/W5Y6Dz7dayf1x8AHvQ
EtCzeJwM1zvB7+uAb+iSOX/5r4iKpWmfJyABJ96CecZ8DNMwgU4ZlEld/B2Ok7S6
PyDCXKi7NOKk2lAgLH3wmFrXebC9+sEV2uQaD05CXjQDQBN/73CjBorKb1JvBsgb
fJnJ4ljijTRH3CC1eDDk3+UHXTcK5I6MlUr0K74W+F2e6+ym3dZuJIXBYF1kVZZP
FyfPqf2Miyz7f+Vzz/JHUNU1f2DvAYi5EfugZ9ESFMmyfAbcIayvp0Wg2UdC11bI
ryUKfOIVJ1FKm+UXauYXhh1Dw0KgxIfDu+eyXVwNmGXanHBFQUh+stDPoRjMMDRe
WTlxfPwEkSUV9Ugxks+r43if4M2a+g+d2n0fSKqtBTPeX068kHroXmW5dFWRwc1D
i7mekPQxJUFwvtiulvhA
=BZNN
-----END PGP SIGNATURE-----

--oC1+HKm2/end4ao3--
