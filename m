Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab2KUNA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:00:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49675 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2KUNAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:00:53 -0500
Date: Wed, 21 Nov 2012 14:00:39 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Tomi Valkeinen <tomba@iki.fi>, Alex Courbot <acourbot@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, Mark Zhang <markz@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
Message-ID: <20121121130039.GA12191@avionic-0098.adnet.avionic-design.de>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
 <1353149747-31871-2-git-send-email-acourbot@nvidia.com>
 <20121120215429.B621F3E1821@localhost>
 <13540495.epaCf4JVn9@percival>
 <50ACB59B.4090404@iki.fi>
 <20121121114018.GA31576@avionic-0098.adnet.avionic-design.de>
 <50ACC341.3090204@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <50ACC341.3090204@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:IKhT7Mc67j9+VJJ35oJl05s0Jil5ttouvJoRylrzfXm
 wANCDUvqOJBEYUY1cnprcbFg0gsnh/nN8DluQpyBhZG2vyXSft
 rH0KsZhUT4uPUM3zcSEVtqaaDcaVvsX1jeHZ9cu6qYgosJDdAa
 s1bxId4HMu8BZEvgmaVISquNSpT/B4rDUR0zDMHUynUKAQo42w
 VWh2tEe5EPnm6Kc6Dzzjszrbgx0YtBARjvcTzA5fuE6ffkiuuS
 wzR4AGWx6pU7tEqo9s16cQYy2kTNxTwTx9WgchKXIzmlyGi6CO
 Dv3yQXtokEXXPWCNirhSq64WDCIU82+kawPVN6eOk0qw+URUJI
 +FNOmIH9BmGLcHsopN97016lIx3F15CUKyudGbuALHa5nUzxgM
 zqy04ElFy2UrVsUQhT/zfMNqkOVaIch6H/BWwOYvmFW+3uDR9F
 HRPQm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 21, 2012 at 02:04:17PM +0200, Tomi Valkeinen wrote:
> On 2012-11-21 13:40, Thierry Reding wrote:
> > On Wed, Nov 21, 2012 at 01:06:03PM +0200, Tomi Valkeinen wrote:
>=20
> (sorry for bouncing back and forth with my private and my @ti addresses.
> I can't find an option in thunderbird to only use one sender address,
> and I always forget to change it when responding...)
>=20
> >> My suggestion would be to go forward with an in-driver solution, and
> >> look at the DT based solution later if we are seeing an increasing blo=
at
> >> in the drivers.
> >=20
> > Assuming we go with your approach, what's the plan? We're actually
> > facing this problem right now for Tegra. Basically we have a DRM driver
> > that can drive the panel, but we're still missing a way to hook up the
> > backlight and panel enabling code. So we effectively can't support any
> > of the LVDS devices out there without this series.
>=20
> Could you describe the hardware setup you have related to the LCD and
> backlight? Is it a public board with public schematics?

I don't think any of the schematics are public. The Tamonten Evaluation
Carrier is available publicly from our website and the schematics are
available on demand as well. If required I can probably arrange to send
you a copy.

> I've understood that you don't have anything special in your board, just
> an LCD and a backlight, and the power sequences are related to powering
> up the LCD and the backlight, without anything board specific. If so,
> there's no need for board specific code, but just improving the panel
> and backlight drivers to support the models you use.

Correct. Basically we have two GPIOs that each enable the panel or the
backlight respectively and one PWM to control the brightness. Are the
panel drivers that you refer to those in drivers/video? I'm not sure if
adding more ad-hoc drivers there just to move them to a generic
framework in the next cycle is a good idea. I'd rather spend some time
on helping to get the framework right and have drivers for that instead.

=46rom what I understand by looking at the OMAP display drivers, they also
provide the timings for the displays. Steffen's videomode helpers can be
used to represent these easily in DT, but I suppose if all of those per-
panel specifics are represented in the drivers then that won't be needed
anymore either.

> > As I understand it, what you propose is similar to what ASoC does. For a
> > specific board, you'd have to write a driver, presumably for the new
> > panel/display framework, that provides code to power the panel on and
> > off. That means we'll have to have a driver for each panel out there
> > basically, or we'd need to write generic drivers that can be configured
> > to some degree (via platform data or DT). This is similar to how ASoC
> > works, where we have a driver that provides support for a specific codec
> > connected to the Tegra SoC. For the display framework things could be
> > done in a similar way I suppose, so that Tegra could have one display
> > driver to handle all aspects of powering on and off the various panels
> > for the various boards out there.
>=20
> I think we should only need the board drivers for very special cases. If
> there's just a panel and a backlight, without any special dynamic muxing
> or other trickery needed, I don't see a need for a board driver. I
> presume this is the case for most of the boards.

For Tegra ASoC, the way to provide for this is to allow a specific board
to introduce a separate compatible value to enable per-board quirks or
special handling if it cannot be supported by the generic driver and
configuration mechanisms.

> > Obviously, a lot of the code will be similar for other SoCs, but maybe
> > that's just the way things are if we choose that approach. There's also
> > the potential for factoring out large chunks of common code later on
> > once we start to see common patterns.
> >=20
> > One thing that's not very clear is how the backlight subsystem should be
> > wired up with the display framework. I have a patch on top of the Tegra
> > DRM driver which adds some ad-hoc display support using this power
> > sequences series and the pwm-backlight.
>=20
> I think that's a separate issue: how to associate the lcd device and
> backlight device together. I don't have a clear answer to this.
>=20
> There are many ways the backlight may be handled. In some cases the
> panel and the backlight are truly independent, and you can use the other
> without using the other (not very practical, though =3D).

At least for DT I think we can easily wire that up. I've actually posted
a patch recently that does so. I think in most cases it makes sense to
control them together, such as on DPMS changes, where you really want to
turn both the backlight and the LCD off, independent of how they are
tied together.

> But then with some LCDs the backlight may be controlled by sending
> commands to the panel, and in this case the two may be quite linked.
> Changing the backlight requires the panel driver to be up and running,
> and sometimes the sending the backlight commands may need to be (say,
> DSI display, with backlight commands going over the DSI bus).
>=20
> So my feeling is that the panel driver should know about the related
> backlight device. In the first case the panel driver would just call
> enable/disable in the backlight device when the panel is turned on.

Exactly.

> In the second case of the DSI panel... I'm not sure. I've implemented it
> so that the panel driver creates the backlight device, and implements
> the backlight callbacks. It then sends the DSI commands from those
> callbacks.

That certainly sounds like the right approach to me.

> > From reading the proposal for the panel/display framework, it sounds
> > like a lot more is planned than just enabling or disabling panels, but
> > it also seems like a lot of code needs to be written to support things
> > like DSI, DBI or other control busses.
> >=20
> > At least for Tegra, and I think the same holds for a wide variety of
> > other SoCs, dumb panels would be enough for a start. In the interest of
> > getting a working solution for those setups, maybe we can start small
> > and add just enough framework to register dumb panel drivers to along
> > with code to wire up a backlight to light up the display. Then we could
> > possibly still make it to have a proper solution to support the various
> > LVDS panels for Tegra with 3.9.
>=20
> Yes, we (Laurent and me) both agree that we should start simple.
>=20
> However, the common panel framework is not strictly needed for this. I'm
> not sure of the current architecture for Tegra, but for OMAP we already
> have panel drivers (omap specific ones, though). The panel drivers may
> support multiple models, (for example,
> drivers/video/omap2/displays/panel-generic-dpi.c).
>=20
> I don't see any problem with adding small Tegra specific panel drivers
> for the time being, with the intention of converting to common panel
> framework when that's available.

I can take a look at how such a driver could be implemented, but again,
I'm a bit reluctant to add something ad-hoc now when maybe we can have
it supported in a proper framework not too far away in the future.

> Of course, the DT side is an issue. If you now create DT bindings for a
> temporary model, and need to change it again later, you'll have some
> headaches trying managing that without breaking the old bindings... This
> is why I haven't pushed DT bindings for OMAP, as I know I have to change
> them in the near future.

We're already keeping back on this and none of the patches that define
the bindings have been merged yet. Although bindings have been known to
change every once in a while even for code that is already in mainline.

Thierry

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQrNB3AAoJEN0jrNd/PrOh5DYQAIzlPEji9P1q3ToLewnuGdmP
WlCds86dAUJ3kKINOs8PMaNWWb4DzZvfV5NRTUhof1LiKh28ZcnovgOpxaM2aYDQ
p7VwqyiTtT5xcx50Ekae++ZrXGivooLddQCk5tVADX080R+6VWGSRrWRCW04EPJ1
9JGKe16l/U+rZrgh/vHA5lTlPUlFLNe3NR02fSUFVZygUwWB+q6z4ERuuyR/Aa87
w4lEDRcKDjwy3xPrSlYml/BmzRANMengCEHnnbYsLGeH34v1S36U3B2xz9b/KvA4
N60ECKlWEHklVv3+xf+2BG4dNi4/+oGc8OL3zvIzq0DErsSH+2q6lNW2US96yIv1
sBqgYpGUkejRqkBWt1mTUfjvywY6W5ThR/xetOSw80YAjT83W78cie3Lt5b95STo
KQ7S0sDh5cRwfRRxUpKf+DWSI9dwMlsu3ZXRCRvsZ2TzMdb7mkIzJ5SLVJ09AQ55
56sB4d+VflXHz91tEwBxVR+SX2JN6hIjdE7yWc4guyiDdETuW+I0DdtcujhpBrKX
BqwY/rtC1e0f5bsOO74L9519xvYzI/HsgcMLbQHjTdVYhbY/ncVPkpa22XkIy1GK
IsUfMWLbAAIYGbjpmxhdWeOs6kHgz/57Zpik6EHWE4AJGttzQ036A2mZjLLnRoq8
hX9HSMkH4J41Bj9SpWMd
=wZk1
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
