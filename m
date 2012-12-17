Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab2LQKN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 05:13:27 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55553 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab2LQKNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 05:13:25 -0500
Date: Mon, 17 Dec 2012 12:05:31 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, Evgeniy Polyakov <zbr@ioremap.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PULL] fbdev changes for 3.8
Message-ID: <20121217100531.GA21416@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <50CAFDFF.3070802@ti.com>
 <CA+55aFz9+3mOZcjJ9C-izKkidT9mxeO7xUubJER0OTjcZjE=2A@mail.gmail.com>
 <20121215222431.GA7153@redhat.com>
 <20121216174613.GA18490@atomide.com>
 <20121216203536.GR4989@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <20121216203536.GR4989@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Dec 16, 2012 at 12:35:37PM -0800, Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [121216 09:49]:
> > * Dave Jones <davej@redhat.com> [121215 14:27]:
> > > On Sat, Dec 15, 2012 at 01:11:04PM -0800, Linus Torvalds wrote:
> > >  > On Fri, Dec 14, 2012 at 2:22 AM, Tomi Valkeinen <tomi.valkeinen@ti=
=2Ecom> wrote:
> > >  > > Hi Linus,
> > >  > >
> > >  > > Florian, the fbdev maintainer, has been very busy lately, so I o=
ffered to send
> > >  > > the pull request for fbdev for this merge window.
> > >  >=20
> > >  > Pulled. However, with this I get the Kconfig question
> > >  >=20
> > >  >    OMAP2+ Display Subsystem support (OMAP2_DSS) [N/m/y/?] (NEW)
> > >  >=20
> > >  > which doesn't make a whole lot of sense on x86-64, unless there's
> > >  > something about OMAP2 that I don't know.
> > >  >=20
> > >  > So I'd suggest making that OMAP2_DSS be dependent on OMAP2. Or at
> > >  > least ARM. Because showing it to anybody else seems insane.
> > >  >=20
> > >  > Same goes for FB_OMAP2 for that matter. I realize that it's likely
> > >  > nice to get compile testing for this on x86-64 too, but if that's =
the
> > >  > intent, we need to think about it some more. I don't think it's go=
od
> > >  > to ask actual normal users questions like this just for compile
> > >  > coverage.
> > >=20
> > > This OMAP stuff has been creeping into x86 builds for a while.
> > > Grep from my current build config ..
> > >=20
> > > # CONFIG_OMAP_OCP2SCP is not set
> > > # CONFIG_KEYBOARD_OMAP4 is not set
> > > # CONFIG_OMAP2_DSS is not set
> > > # CONFIG_OMAP_USB2 is not set
> > >=20
> > > There was some other arm-ism that does the same that I' currently for=
getting,
> > > or maybe that got fixed..
> >=20
> > Those are all omap internal devices and should be all marked with
> > depends on ARCH_OMAP2PLUS.
> >=20
> > It's a different story for external devices that may be used on other
> > architectures.
> >=20
> > I only came up with one reason to compile internal devices for other
> > architectures: In some cases the driver subsystem maintainer may want to
> > be able to compile test subsystem wide changes without having to compile
> > for each target separately. But for those cases it's trivial to carry a
> > compile test patch that just drops the depends Kconfig entries.
>=20
> And here's a patch to limit the omap drivers above to omap only.
>=20
> Regards,
>=20
> Tony
>=20
>=20
> From: Tony Lindgren <tony@atomide.com>
> Date: Sun, 16 Dec 2012 12:28:46 -0800
> Subject: [PATCH] ARM: OMAP: Fix drivers to depend on omap for internal de=
vices
>=20
> These devices are not available on other architectures, so
> let's limit them to omap.
>=20
> If the driver subsystem maintainers want to build test
> system wide changes without building for each target,
> it's easy to carry a test patch that just strips out the
> depends entries from Kconfig files.
>=20
> Signed-off-by: Tony Lindgren <tony@atomide.com>
>=20
> --- a/drivers/bus/Kconfig
> +++ b/drivers/bus/Kconfig
> @@ -6,6 +6,7 @@ menu "Bus devices"
> =20
>  config OMAP_OCP2SCP
>  	tristate "OMAP OCP2SCP DRIVER"
> +	depends on ARCH_OMAP2PLUS
>  	help
>  	  Driver to enable ocp2scp module which transforms ocp interface
>  	  protocol to scp protocol. In OMAP4, USB PHY is connected via
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -544,6 +544,7 @@ config KEYBOARD_OMAP
> =20
>  config KEYBOARD_OMAP4
>  	tristate "TI OMAP4+ keypad support"
> +	depends on ARCH_OMAP2PLUS
>  	select INPUT_MATRIXKMAP
>  	help
>  	  Say Y here if you want to use the OMAP4+ keypad.
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -6,6 +6,7 @@ comment "USB Physical Layer drivers"
> =20
>  config OMAP_USB2
>  	tristate "OMAP USB2 PHY Driver"
> +	depends on ARCH_OMAP2PLUS
>  	select USB_OTG_UTILS
>  	help
>  	  Enable this to support the transceiver that is part of SOC. This

for Keypad, PHY and OCP2SCP I would rather not as I want to use
linux-next for compile testing our stuff in all arches.

--=20
balbi

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQzu5rAAoJEIaOsuA1yqREQ4gP/121MLTcDArWZWrCzE8duOeP
mDfhN10Q4u2UFhSAuKaN0Jms4l+W5/vcui1WRypxPL8WbPUMEy+JT2VMDjK+ZwN5
OZvR3D70bp2hpXbG5orQgMHlX354AuxdIjCydtaqtEF+ENab175I8VCWdo9CoJ8O
iTnQCWuKzT+51m4LHN2z/Zq0Ej2tRbQ92pcV/2W/P+kuUtZRTUC9yOhxfBOyh0UH
RtK/E/VKxlnEKr2/n7Ol+1uuifkxCB2mBM8FiuCZVV8LANhrpGi3rQ/zkn5w1brP
PYDd3POIIQfhEUuH98zPYXU+nUe4qXJov/QOQgrI/W/vTF4x6im8Jh3DNl4+VtPc
02Mr95JQtlgvhkW+qDUNdhO0yASay7mDguoUXYEv0oF/jgKdcOhGZDKziXL7zix7
CAq8iLw858cc6B8aVAcUQthj8H1a2ybz4J8bwxBW5BbaSJRGzGzENNOJsOn4H80Z
PoIrQOHnX9GJ92nL127F+szQXHqtvIVCJ146jGM429XAgajBsxHJseSITuDCM3mT
o4JUR26Sl/tDDaM0H/hUoUerhBc53rdtgMrN+wlTAJ3+Fzt9DTUR0DMfYFEZ89un
MyuNmsUEKv3nW7cE1UbN3/y7200xvLCDzftYEcb8qvzLS5R6S2iMVkAbjQYInFPB
3gR27mvPboghOYNhAKHP
=7xuI
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
