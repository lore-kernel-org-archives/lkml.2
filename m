Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab2IMIAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:00:31 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:35845 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756458Ab2IMIA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:00:28 -0400
Message-ID: <1347523218.3014.4.camel@deskari>
Subject: Re: [PATCH v6 1/4] Runtime Interpreted Power Sequences
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Alex Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Date: Thu, 13 Sep 2012 11:00:18 +0300
In-Reply-To: <20120913072920.GA11459@avionic-0098.mockup.avionic-design.de>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
	 <1464760.6eqxJ2IzZ2@percival> <1347517377.7471.23.camel@lappyti>
	 <2689722.93BQTh4lSC@percival> <1347519249.7471.42.camel@lappyti>
	 <20120913070012.GC6180@pengutronix.de> <1347519807.7471.45.camel@lappyti>
	 <20120913072920.GA11459@avionic-0098.mockup.avionic-design.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ui745hhkG/aZkdLkg0wX"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ui745hhkG/aZkdLkg0wX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-09-13 at 09:29 +0200, Thierry Reding wrote:
> On Thu, Sep 13, 2012 at 10:03:27AM +0300, Tomi Valkeinen wrote:
> > On Thu, 2012-09-13 at 09:00 +0200, Sascha Hauer wrote:
> > > On Thu, Sep 13, 2012 at 09:54:09AM +0300, Tomi Valkeinen wrote:
> > > > On Thu, 2012-09-13 at 15:36 +0900, Alex Courbot wrote:
> > > > > On Thursday 13 September 2012 14:22:57 Tomi Valkeinen wrote:
> > > > > =20
> > > > > > However, I fear these board specific things may be quite a bit =
anything,
> > > > > > so it may well be pwm, gpios and regulators are not enough for =
them. For
> > > > > > example, there could be an FPGA on the board which requires som=
e
> > > > > > configuration to accomplish the task at hand. It could be rathe=
r
> > > > > > difficult to handle it with a generic power sequence.
> > > > >=20
> > > > > Right. Note that this framework is supposed to be extended - I wo=
uld like to=20
> > > > > at least add regulator voltage setting, and maybe even support fo=
r clocks and=20
> > > > > pinmux (but that might be out of place).
> > > >=20
> > > > Yes, that's one concern of mine... I already can imagine someone
> > > > suggesting adding conditionals to the power sequence data. Perhaps =
also
> > > > direct memory read/writes so you can twiddle registers directly. An=
d so
> > > > on. Where's the limit what it should contain? Can we soon write ful=
l
> > > > drivers with the DT data? =3D)
> > >=20
> > > I have this concern aswell, that's why I'm sceptical about this patch
> > > set. But what are the alternatives? Adding power code to the drivers =
and
> > > thus adding board specific code to them is backwards.
> >=20
> > As was pointed out in earlier posts in this thread, these are almost
> > always device specific, not board specific.
> >=20
> > Do you have examples of board specific power sequences or such?
>=20
> It is true that most (perhaps all) power sequences can be associated
> with a specific device, but if we go and implement drivers for these
> kinds of devices we will probably end up with loads of variations of
> the same scheme.
>=20
> Lets take display panels as an example. One of the devices that we build
> has gone through two generations so far and both are slightly different
> in how they control the panel backlight: one has an external backlight
> controller, the other has the display controller built into the panel.
> However, from the board's perspective the control of the backlight
> doesn't change, because both devices get the same inputs (an enable pin
> and a PWM) that map to the same pins on the SoC.

We had something a bit similar in Nokia. First versions had an
"independent" backlight controlled via pwm. Later versions had a
backlight that is controlled by the panel IP, so it was changed by
sending DSI commands to the panel.

> This may not be a very good example because the timing isn't relevant,
> but the basic point is still valid: if we provide a driver for both
> panel devices, the code will be exactly the same. So we end up having to
> refactor to avoid code duplication and use the same driver for a number
> of backlight/panel combinations. Which in itself isn't very bad, but it
> also means that we'll probably get to see a large number of "generic"
> drivers which aren't very generic after all.
>=20
> Another problem, which also applies to the case of power-sequences, is
> that often the panel and backlight are not the same device. So you could
> have the same panel with any number of different backlight controllers
> or vice-versa any number of different panels with the same backlight
> controller.

Yes, I think the backlight and the panel should be considered separate
devices. Just like, say, a touch screen and a panel may happen to be in
the same display module, a backlight and a panel can be in the same
display module. They are still separate, independent things, although
they are, of course, used together.

 Tomi


--=-ui745hhkG/aZkdLkg0wX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQUZKSAAoJEPo9qoy8lh710MAP/3AaXXuE/5Zq5G6MBYH3yRJh
M7aAeXPf7Qtc4BlwlVqclv5rQmVz91TBvhJ63TJ8qZyMKhRlUxfE3TRCE5UjHzzo
eSrt9H9+qp4EsphQyct1WdMYXRh8Dd5qQj5OsY5VRs4T/bvPMDiwU16gMqMzTGFR
6D4qTtVTdLSlu0ULsmBzIQ9vazz9SQC/tWWNqhQKC8HebP1BCKL7FuIGJFaHEjXm
sWxuZbROBu0yZwMFm0XinT73OcREhy1BoesYEgBt6BW4zg5dG1f6fhgcwDv44hjB
fa26VZi0/UhVFAqO6pS4WA32WHHUIQFshi9aJp8baX4Jg7HPTbs5gCOM2D8wqfYU
/SWJFNFHZYSjfUHC48t01W/2FB1vL1obSw1gfm4IPNOS5zxYaP5TsH5ywnt0k1/6
lnMgMAcwrrYJoQWYdjAqgoaJfCN/lEDpbSjWBDdY+GAKZOoRkmmJn96kUI8W8MSV
RwU+uoy6B/MPpe1fo80ylFd2Ca5mcselKYvxgq6Al8ucKpTYpSs8pF8rR+H8eSBr
Kwf8WHccOZdJ6sfUXXjHItx08qfDYcbYU2LgOYHHzdR9bmlo4NOanR5Sw2Nb2mn7
i1ke6ngIyvH3t4OBVFd0waZzRAb3JL25VHwZIOsucAy48FAAQeihbKkydgSxO71Y
p2BymixnKKH7aGVj5Lzz
=zIAT
-----END PGP SIGNATURE-----

--=-ui745hhkG/aZkdLkg0wX--

