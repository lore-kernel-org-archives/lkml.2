Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab2IMH2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:28:24 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:49238 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756241Ab2IMH1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:27:18 -0400
Message-ID: <1347521231.7471.51.camel@lappyti>
Subject: Re: [PATCH v6 1/4] Runtime Interpreted Power Sequences
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Alex Courbot <acourbot@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
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
Date: Thu, 13 Sep 2012 10:27:11 +0300
In-Reply-To: <20120913071829.GE6180@pengutronix.de>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
	 <1464760.6eqxJ2IzZ2@percival> <1347517377.7471.23.camel@lappyti>
	 <2689722.93BQTh4lSC@percival> <1347519249.7471.42.camel@lappyti>
	 <20120913070012.GC6180@pengutronix.de> <1347519807.7471.45.camel@lappyti>
	 <20120913071829.GE6180@pengutronix.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-k/2ptgd5nhGu/j+xHFPM"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-k/2ptgd5nhGu/j+xHFPM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-09-13 at 09:18 +0200, Sascha Hauer wrote:
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
> > > > direct memory read/writes so you can twiddle registers directly.
>=20
> These memory writes can be avoided when these registers are abstracted
> as a regular gpio/regulator/pwm driver.

Only if they are gpios/regulators/pwms. Yes, I agree most of the
possible things to configure would be among those (or perhaps
pinmuxing). But there's always the odd one that's not one of those.

> > Do you have examples of board specific power sequences or such?
>=20
> Sure, tons of. One board needs a gpio to be set high to enable backlight,
> the next one to low, a regulator has to be enabled, and to avoid
> flickering a certain timing has to be ensured. This is all highly board
> specific.

Okay. In my experience these have always been device specific. In the
case of backlight, the backlight device requires one gpio to be set
high, other one low, etc.

Can you share a bit more what kind of HW configuration you have that
requires this? The backlight is not a single piece of HW added to the
board (or embedded into a panel module), but consists of multiple HW
blocks integrated in a custom way to the board?

 Tomi


--=-k/2ptgd5nhGu/j+xHFPM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQUYrPAAoJEPo9qoy8lh711dIQAJzA+buJca5+Q6nt7q63/8NU
+iWHANBqlnI+j9ipnsK4jzLI+ibBmWhtmgWBPa9B04Ju9keyvdSKlujPpngnIlyE
s7zrTsabhj7jQJcNuKoy4xseApsg3gELj2uJYCvCvIdaH/kX2MCnHsThbccKRVMm
neX8+XrUJJXD2K5xAZmn9XWX0IX+JkzLOdg/b6trVjyPiA3uRnLs+zpEUGyE1bQ6
ZS+FnP7aXUoNXTTm+sDOTcp05/4faLTqCd9RoVA7VUIFsH+BbmwThluuvThypzu+
IAiR2LDuc9JrbNIuLsjO24jr+IJSa7pkYdx1CTapjTJE6INAQrVykA8xf3YB+ZJN
C6IoUrok7Wle1pdh657pGaSzYmY4VmCPz3VS2uOV6COB6mkRfkdi2YoLmqWoj2Ww
ZUlL6sUFVnPKMaxfF1j9vqZFdInnk9bhS6FpGt8YabBdQAcTBPmaBUTG6fWFWWxy
O0gQ4y14ptx8HWuNkuq6Q6fw9Zzxl5rvZeHTDxpU61b89zHtPzTLtPa7TKC6my+A
lzEOBlMK0XtkR9GC/hhRMbRJsBHVXJM4TCHBeKBqTnDwIN8B594RtLy7gjkgAUkK
sJHBQ+YX9uhpWetfDhFkbnRixLn+e0Kfuu6imzOLqqPTlsci5UgokX5LCyqiX4m8
iguQYW51jH6DcZGzzi8h
=UOzy
-----END PGP SIGNATURE-----

--=-k/2ptgd5nhGu/j+xHFPM--

