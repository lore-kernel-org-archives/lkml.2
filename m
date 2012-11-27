Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab2K0OqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:46:23 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:43945 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab2K0OqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:46:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
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
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
Date: Tue, 27 Nov 2012 15:47:16 +0100
Message-ID: <21841685.UCqg4y24QZ@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121121114018.GA31576@avionic-0098.adnet.avionic-design.de>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <50ACB59B.4090404@iki.fi> <20121121114018.GA31576@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3396082.iqF65RYg1O"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3396082.iqF65RYg1O
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Thierry,

Sorry for the late reply.

On Wednesday 21 November 2012 12:40:18 Thierry Reding wrote:
> On Wed, Nov 21, 2012 at 01:06:03PM +0200, Tomi Valkeinen wrote:
> > On 2012-11-21 06:23, Alex Courbot wrote:
> > > On Wednesday 21 November 2012 05:54:29 Grant Likely wrote:
> > >>> With the advent of the device tree and of ARM kernels that are not
> > >>> board-tied, we cannot rely on these board-specific hooks anymore but
> > >> 
> > >> This isn't strictly true. It is still perfectly fine to have board
> > >> specific code when necessary. However, there is strong encouragement to
> > >> enable that code in device drivers as much as possible and new board
> > >> files need to have very strong justification.
> > > 
> > > But doesn't introducing board-specific code into the kernel just defeats
> > > the purpose of the DT? If we extend this logic, we are heading straight
> > > back to board-definition files. To a lesser extent than before I agree,
> > > but the problem is fundamentally the same.
> > 
> > I don't think so. I'll reiterate my opinion on this subject, as a
> > summary and for those who haven't read the discussions of the earlier
> > versions of the series. And perhaps I'll even manage to say something
> > new =).
> > 
> > 
> > First about the board specific code. I think we may need some board
> > specific code, even if this series was merged. Let's call them board
> > drivers. These board drivers would only exist for boards with some weird
> > setups that cannot be expressed or managed with DT and normal drivers.
> > 
> > I think these cases would be quite rare, as I can't even come up with a
> > very good example. I guess most likely these cases would involve some
> > small trivial chips for muxing or such, for which it doesn't really make
> > sense to have a real driver.
> > 
> > Say, perhaps a board with two LCDs connected to one video output, and
> > only one LCD can be enabled at a time, and you need to set some mux chip
> > to route the signals to the correct LCD. In this case I'd see we should
> > have hotplug support in the display framework, and the board driver
> > would act on user input (sysfs file, perhaps), plugging in/out the LCD
> > device depending on the user input.
> > 
> > 
> > As for expressing device internal details in the DT data, as done in
> > this series, I don't like it very much. I think the DT data or the board
> > file should just describe which device is the one in question, and how
> > it's connected to other components on the board. The driver for the
> > device should handle everything else.
> > 
> > As Alex pointed out, there may be lots of devices that work the same way
> > when enabled, but require slightly different power-on/off sequences. We
> > could have these sequences in the driver itself, either as plain code,
> > or in a table of some sort, possibly using the power sequence framework
> > presented in this series. The correct code or sequence would be ran
> > depending on the particular model of the device.
> > 
> > I think this approach is correct in the sense that this is what drivers
> > are supposed to do: handle all the device internal matters. But this
> > raises the problem of bloating the kernel with possibly lots of
> > different power sequences, of which only a few would be used by a board,
> > and all the rest would just be waste of memory.
> > 
> > Regarding this problem I have the following questions, to which I don't
> > have clear answers:
> > 
> > - How much of this device specific data is too much? If a driver
> > supports 10 different models, and the sequences for each model take 100
> > bytes, this 1000 bytes doesn't sound too much. But where's the limit?
> > And even if one driver only has 1kB of this data, what if we have lots
> > of similar drivers?
> > 
> > - How many bytes does a power sequence presented in this series take, if
> > the sequence contains, say, 5 steps, with gpio, delay, pwm, delay and
> > regulator?
> > 
> > - How likely is it that we'll get lots of different models? A hundred
> > different models for a backlight PWM with different power-on/off
> > sequences already sounds a really big number. If we're only going to
> > have each driver supporting, say, no more than 10 models, perhaps the
> > problem is not even an issue in practice.
> > 
> > - Are there ways to limit this bloat in the driver? One obvious way
> > would be to discard the unused sequences after driver probe, but that
> > only works for platform devices. Although, I guess these sequences would
> > mostly be used by platform drivers? If so, then the problem could be
> > solved by discarding the data after probe. Another would be to load the
> > sequences from a file as firmware, but that feels quite an awful
> > solution. Anybody have other ideas?
> > 
> > One clear positive side with in-driver approach is that it's totally
> > inside the kernel, and can be easily reworked in the future, or even
> > changed to a DT-based approach as presented in this series if that seems
> > like a better solution. The DT based approach, on the other hand, will
> > be more or less written to stone after it's merged.
> > 
> > 
> > So, I like the framework of expressing the sequences presented in this
> > series (except there's a problem with error cases, as I pointed out in
> > another post), as it can be used inside the drivers. But I'm not so
> > enthusiastic about presenting the sequences in DT.
> > 
> > My suggestion would be to go forward with an in-driver solution, and
> > look at the DT based solution later if we are seeing an increasing bloat
> > in the drivers.
> 
> Assuming we go with your approach, what's the plan? We're actually
> facing this problem right now for Tegra. Basically we have a DRM driver
> that can drive the panel, but we're still missing a way to hook up the
> backlight and panel enabling code. So we effectively can't support any
> of the LVDS devices out there without this series.
> 
> As I understand it, what you propose is similar to what ASoC does. For a
> specific board, you'd have to write a driver, presumably for the new
> panel/display framework, that provides code to power the panel on and
> off. That means we'll have to have a driver for each panel out there
> basically, or we'd need to write generic drivers that can be configured
> to some degree (via platform data or DT). This is similar to how ASoC
> works, where we have a driver that provides support for a specific codec
> connected to the Tegra SoC. For the display framework things could be
> done in a similar way I suppose, so that Tegra could have one display
> driver to handle all aspects of powering on and off the various panels
> for the various boards out there.

The common display framework (CDF) includes a driver for dumb parallel panels 
called panel-dpi. It doesn't handle complex power on/off sequences yet as I 
haven't run into any need for them, but that's definitely something we could 
add, possibly using Alexandre's code to express the sequences. Similarly to 
Tomi, my preferences go for including the sequences in drivers.

> Obviously, a lot of the code will be similar for other SoCs, but maybe
> that's just the way things are if we choose that approach. There's also
> the potential for factoring out large chunks of common code later on
> once we start to see common patterns.

I don't mind duplicating some code in different drivers as a first step. 
Factoring out common code in a second step is easier (at least for me) than 
trying to figure out what the common code would look like before the first 
driver is even written.

> One thing that's not very clear is how the backlight subsystem should be
> wired up with the display framework. I have a patch on top of the Tegra
> DRM driver which adds some ad-hoc display support using this power
> sequences series and the pwm-backlight.

I've touched the backlight API a bit, from both the provider and consumer 
points of view, and my feeling is that the API will need to be reworked to 
neatly integrate with the CDF. The backlight API currently depends on fbdev, 
that's something we should aim to remove. Proposals are welcome :-) Should we 
create a separate mail thread for this ?

> From reading the proposal for the panel/display framework, it sounds
> like a lot more is planned than just enabling or disabling panels,

That's correct. CDF implements several other panel control operations (to 
retrieve the list of modes supported by the panel for instance), and more 
operations will be needed in the future. I've decided to only implement in the 
RFC operations that I need for the platforms I work on, and let other 
developers propose additional operations depending on their use cases.

> but it also seems like a lot of code needs to be written to support things
> like DSI, DBI or other control busses.

I don't think we need that much code there. The most common control busses for 
display hardware are DSI, DBI, I2C, SPI and plain GPIOs. The last three 
control busses are well supported in the Linux kernel, I've implemented DBI 
support as part of the CDF RFC, and DSI support is missing. If you look at the 
DBI bus implementation the amount of code isn't overly large.

> At least for Tegra, and I think the same holds for a wide variety of other
> SoCs, dumb panels would be enough for a start. In the interest of getting a
> working solution for those setups, maybe we can start small and add just
> enough framework to register dumb panel drivers to along with code to wire
> up a backlight to light up the display. Then we could possibly still make it
> to have a proper solution to support the various LVDS panels for Tegra with
> 3.9.
> 
> I'm adding Laurent on Cc since he's probably busy working on a new
> proposal for the panel/display framework. Maybe he can share his thought
> on this.
>
> All of the above said, I'm willing to help out with the coding if that's
> what is required to reach a solution that everybody can be happy with.

That's much appreciated. If that means a couple additional hours of sleep per 
week for me I'll be extremely thankful :-)

-- 
Regards,

Laurent Pinchart

--nextPart3396082.iqF65RYg1O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJQtNJ6AAoJEIkPb2GL7hl1OqMIAKrpAhIunni9mhXCOKsBgpYj
jkg0QjJgPi6vwgvhSlVMz/y4WrKuDsWrs5db5muOpNZ9slDzPBbwm1PAiN+PIiE3
HOg1lKfCUJIPU9lRUw1/T8pCEscdRLzV2imLUyLDOYKhTvL/figxQ8nDylHcbRY9
+3CIdRvNIljczh1kmFPlpJB3MSmh320jO0Ms354uRX2/Mo6EVzoxtMvr3TTFiphn
qYUW0wUx18zdzgX03ri+5aijNzoEQIOlEc2rwmCQJQmN4USb1ZkoULAPf6RgdY2Z
jBx65krhBy2gTkQ97bMy54VpKCkF3dUe890zBL+MJC7PG2r3VkqsSVbsOE77JQo=
=xm0u
-----END PGP SIGNATURE-----

--nextPart3396082.iqF65RYg1O--

