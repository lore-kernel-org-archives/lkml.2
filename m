Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab2K0PSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:18:04 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:53481 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab2K0PSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:18:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, Tomi Valkeinen <tomba@iki.fi>,
        Alex Courbot <acourbot@nvidia.com>,
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
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
Date: Tue, 27 Nov 2012 16:19:03 +0100
Message-ID: <677017301.WgMsY3RUrt@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121121130039.GA12191@avionic-0098.adnet.avionic-design.de>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <50ACC341.3090204@ti.com> <20121121130039.GA12191@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1928603.KVLQF3Dj6Q"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1928603.KVLQF3Dj6Q
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Thierry,

On Wednesday 21 November 2012 14:00:39 Thierry Reding wrote:
> On Wed, Nov 21, 2012 at 02:04:17PM +0200, Tomi Valkeinen wrote:
> > On 2012-11-21 13:40, Thierry Reding wrote:
> > > On Wed, Nov 21, 2012 at 01:06:03PM +0200, Tomi Valkeinen wrote:
> > (sorry for bouncing back and forth with my private and my @ti addresses.
> > I can't find an option in thunderbird to only use one sender address,
> > and I always forget to change it when responding...)
> > 
> > >> My suggestion would be to go forward with an in-driver solution, and
> > >> look at the DT based solution later if we are seeing an increasing
> > >> bloat in the drivers.
> > > 
> > > Assuming we go with your approach, what's the plan? We're actually
> > > facing this problem right now for Tegra. Basically we have a DRM driver
> > > that can drive the panel, but we're still missing a way to hook up the
> > > backlight and panel enabling code. So we effectively can't support any
> > > of the LVDS devices out there without this series.
> > 
> > Could you describe the hardware setup you have related to the LCD and
> > backlight? Is it a public board with public schematics?
> 
> I don't think any of the schematics are public. The Tamonten Evaluation
> Carrier is available publicly from our website and the schematics are
> available on demand as well. If required I can probably arrange to send
> you a copy.
> 
> > I've understood that you don't have anything special in your board, just
> > an LCD and a backlight, and the power sequences are related to powering
> > up the LCD and the backlight, without anything board specific. If so,
> > there's no need for board specific code, but just improving the panel
> > and backlight drivers to support the models you use.
> 
> Correct. Basically we have two GPIOs that each enable the panel or the
> backlight respectively and one PWM to control the brightness. Are the
> panel drivers that you refer to those in drivers/video? I'm not sure if
> adding more ad-hoc drivers there just to move them to a generic
> framework in the next cycle is a good idea. I'd rather spend some time
> on helping to get the framework right and have drivers for that instead.

Thanks :-) It should be pretty easy to add support for an enable GPIO to the 
DPI panel driver that I've posted as part of the CDF RFC v2.

> From what I understand by looking at the OMAP display drivers, they also
> provide the timings for the displays. Steffen's videomode helpers can be
> used to represent these easily in DT, but I suppose if all of those per-
> panel specifics are represented in the drivers then that won't be needed
> anymore either.

For DPI panels it might still make sense to provide the timings through DT or 
platform data, as the driver might grow huge otherwise. Panel drivers that 
support a couple (dozens) of different models could hardcode the timings.

> > > As I understand it, what you propose is similar to what ASoC does. For a
> > > specific board, you'd have to write a driver, presumably for the new
> > > panel/display framework, that provides code to power the panel on and
> > > off. That means we'll have to have a driver for each panel out there
> > > basically, or we'd need to write generic drivers that can be configured
> > > to some degree (via platform data or DT). This is similar to how ASoC
> > > works, where we have a driver that provides support for a specific codec
> > > connected to the Tegra SoC. For the display framework things could be
> > > done in a similar way I suppose, so that Tegra could have one display
> > > driver to handle all aspects of powering on and off the various panels
> > > for the various boards out there.
> > 
> > I think we should only need the board drivers for very special cases. If
> > there's just a panel and a backlight, without any special dynamic muxing
> > or other trickery needed, I don't see a need for a board driver. I
> > presume this is the case for most of the boards.
> 
> For Tegra ASoC, the way to provide for this is to allow a specific board
> to introduce a separate compatible value to enable per-board quirks or
> special handling if it cannot be supported by the generic driver and
> configuration mechanisms.
> 
> > > Obviously, a lot of the code will be similar for other SoCs, but maybe
> > > that's just the way things are if we choose that approach. There's also
> > > the potential for factoring out large chunks of common code later on
> > > once we start to see common patterns.
> > > 
> > > One thing that's not very clear is how the backlight subsystem should be
> > > wired up with the display framework. I have a patch on top of the Tegra
> > > DRM driver which adds some ad-hoc display support using this power
> > > sequences series and the pwm-backlight.
> > 
> > I think that's a separate issue: how to associate the lcd device and
> > backlight device together. I don't have a clear answer to this.
> > 
> > There are many ways the backlight may be handled. In some cases the
> > panel and the backlight are truly independent, and you can use the other
> > without using the other (not very practical, though =).
> 
> At least for DT I think we can easily wire that up. I've actually posted
> a patch recently that does so. I think in most cases it makes sense to
> control them together, such as on DPMS changes, where you really want to
> turn both the backlight and the LCD off, independent of how they are
> tied together.
> 
> > But then with some LCDs the backlight may be controlled by sending
> > commands to the panel, and in this case the two may be quite linked.
> > Changing the backlight requires the panel driver to be up and running,
> > and sometimes the sending the backlight commands may need to be (say,
> > DSI display, with backlight commands going over the DSI bus).
> > 
> > So my feeling is that the panel driver should know about the related
> > backlight device. In the first case the panel driver would just call
> > enable/disable in the backlight device when the panel is turned on.
> 
> Exactly.
> 
> > In the second case of the DSI panel... I'm not sure. I've implemented it
> > so that the panel driver creates the backlight device, and implements
> > the backlight callbacks. It then sends the DSI commands from those
> > callbacks.
> 
> That certainly sounds like the right approach to me.
> 
> > > From reading the proposal for the panel/display framework, it sounds
> > > like a lot more is planned than just enabling or disabling panels, but
> > > it also seems like a lot of code needs to be written to support things
> > > like DSI, DBI or other control busses.
> > > 
> > > At least for Tegra, and I think the same holds for a wide variety of
> > > other SoCs, dumb panels would be enough for a start. In the interest of
> > > getting a working solution for those setups, maybe we can start small
> > > and add just enough framework to register dumb panel drivers to along
> > > with code to wire up a backlight to light up the display. Then we could
> > > possibly still make it to have a proper solution to support the various
> > > LVDS panels for Tegra with 3.9.
> > 
> > Yes, we (Laurent and me) both agree that we should start simple.
> > 
> > However, the common panel framework is not strictly needed for this. I'm
> > not sure of the current architecture for Tegra, but for OMAP we already
> > have panel drivers (omap specific ones, though). The panel drivers may
> > support multiple models, (for example,
> > drivers/video/omap2/displays/panel-generic-dpi.c).
> > 
> > I don't see any problem with adding small Tegra specific panel drivers
> > for the time being, with the intention of converting to common panel
> > framework when that's available.
> 
> I can take a look at how such a driver could be implemented, but again,
> I'm a bit reluctant to add something ad-hoc now when maybe we can have
> it supported in a proper framework not too far away in the future.
> 
> > Of course, the DT side is an issue. If you now create DT bindings for a
> > temporary model, and need to change it again later, you'll have some
> > headaches trying managing that without breaking the old bindings... This
> > is why I haven't pushed DT bindings for OMAP, as I know I have to change
> > them in the near future.
> 
> We're already keeping back on this and none of the patches that define
> the bindings have been merged yet. Although bindings have been known to
> change every once in a while even for code that is already in mainline.

-- 
Regards,

Laurent Pinchart

--nextPart1928603.KVLQF3Dj6Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJQtNnnAAoJEIkPb2GL7hl1DAoIAKHM7QM/gRSR+qst0vjtA3is
Gnkso6maXe3RRq1rxmYWBoR2GWA1bbGUmCHWR85/0f2pE7sfDKgT2goyIeqRm0yF
JYrGVp++qAUoW4rEz3eQHldWEaf5TdqEBBvUxxWKFLH+gWUg5BCdCj6MMEdnWAt9
8/uGRxCZoKIwQLR+CTWz+04uidYgcYBvtZ2/mGHG4cgZQElSYNAAQIPTHYYDkllv
z0HBk/UrXwuhqrhDLSfeIY0FN/wVzXnrC/Ax9/dWyiy9EKBkkqPCLNk6cY3peWQK
Ro5GpvhZ5HJMd7A3pD2bJTF5r4xVuUVmxVdTs3QY6c3ezhPui/gIhaeLh1lz3nQ=
=xBpb
-----END PGP SIGNATURE-----

--nextPart1928603.KVLQF3Dj6Q--

