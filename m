Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab2KULkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 06:40:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62940 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab2KULkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 06:40:36 -0500
Date: Wed, 21 Nov 2012 12:40:18 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tomi Valkeinen <tomba@iki.fi>
Cc: Alex Courbot <acourbot@nvidia.com>,
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
Message-ID: <20121121114018.GA31576@avionic-0098.adnet.avionic-design.de>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
 <1353149747-31871-2-git-send-email-acourbot@nvidia.com>
 <20121120215429.B621F3E1821@localhost>
 <13540495.epaCf4JVn9@percival>
 <50ACB59B.4090404@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <50ACB59B.4090404@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:fCnI0ukNsA+xdjHFLoAV5WzXwuwXbHr3IA8Fd4gYhpJ
 KoFkjI1BBt8DefH3ECiN53uVRzWUfjnpTivAtsJ+96xmv+l9AL
 dcfxtIT9WD7b+uIwjoPPXVNFbfO7FJPOA2G/+CgBBkfvKRBjqj
 fSQ0KY4kTeasNqO8jL7BtV3CodfPl9MO0nlV4HRP6bSp5jLnvQ
 Qs7lxObuhO2L6Cgo9R7xeXqmowJa23clp8vyCNrfPV1T0+xRMc
 cX4Y+zL4z0KGkbFB3dG+xbvJ2/FD4xmSCyLOSlC64a+4szC20g
 bCmJ/6R47TbsrO9LkgxXm0kHfytzn/YPyvaVsKLRGHt54LJUrY
 eHbLEgqJ+KdF4B0R9CmToY+UKNKaWtyHRLuAqCZkk2hehVM1vl
 YER5Orb8lU3g+g4GyVPUJvG+1KRpDqR0Rfv+pYHd7urlzT8KsP
 IA8ts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 21, 2012 at 01:06:03PM +0200, Tomi Valkeinen wrote:
> On 2012-11-21 06:23, Alex Courbot wrote:
> > Hi Grant,
> >=20
> > On Wednesday 21 November 2012 05:54:29 Grant Likely wrote:
> >>> With the advent of the device tree and of ARM kernels that are not
> >>> board-tied, we cannot rely on these board-specific hooks anymore but
> >>
> >> This isn't strictly true. It is still perfectly fine to have board
> >> specific code when necessary. However, there is strong encouragement to
> >> enable that code in device drivers as much as possible and new board
> >> files need to have very strong justification.
> >=20
> > But doesn't introducing board-specific code into the kernel just defeat=
s the=20
> > purpose of the DT? If we extend this logic, we are heading straight bac=
k to=20
> > board-definition files. To a lesser extent than before I agree, but the=
 problem=20
> > is fundamentally the same.
>=20
> I don't think so. I'll reiterate my opinion on this subject, as a
> summary and for those who haven't read the discussions of the earlier
> versions of the series. And perhaps I'll even manage to say something
> new =3D).
>=20
>=20
> First about the board specific code. I think we may need some board
> specific code, even if this series was merged. Let's call them board
> drivers. These board drivers would only exist for boards with some weird
> setups that cannot be expressed or managed with DT and normal drivers.
>=20
> I think these cases would be quite rare, as I can't even come up with a
> very good example. I guess most likely these cases would involve some
> small trivial chips for muxing or such, for which it doesn't really make
> sense to have a real driver.
>=20
> Say, perhaps a board with two LCDs connected to one video output, and
> only one LCD can be enabled at a time, and you need to set some mux chip
> to route the signals to the correct LCD. In this case I'd see we should
> have hotplug support in the display framework, and the board driver
> would act on user input (sysfs file, perhaps), plugging in/out the LCD
> device depending on the user input.
>=20
>=20
> As for expressing device internal details in the DT data, as done in
> this series, I don't like it very much. I think the DT data or the board
> file should just describe which device is the one in question, and how
> it's connected to other components on the board. The driver for the
> device should handle everything else.
>=20
> As Alex pointed out, there may be lots of devices that work the same way
> when enabled, but require slightly different power-on/off sequences. We
> could have these sequences in the driver itself, either as plain code,
> or in a table of some sort, possibly using the power sequence framework
> presented in this series. The correct code or sequence would be ran
> depending on the particular model of the device.
>=20
> I think this approach is correct in the sense that this is what drivers
> are supposed to do: handle all the device internal matters. But this
> raises the problem of bloating the kernel with possibly lots of
> different power sequences, of which only a few would be used by a board,
> and all the rest would just be waste of memory.
>=20
> Regarding this problem I have the following questions, to which I don't
> have clear answers:
>=20
> - How much of this device specific data is too much? If a driver
> supports 10 different models, and the sequences for each model take 100
> bytes, this 1000 bytes doesn't sound too much. But where's the limit?
> And even if one driver only has 1kB of this data, what if we have lots
> of similar drivers?
>=20
> - How many bytes does a power sequence presented in this series take, if
> the sequence contains, say, 5 steps, with gpio, delay, pwm, delay and
> regulator?
>=20
> - How likely is it that we'll get lots of different models? A hundred
> different models for a backlight PWM with different power-on/off
> sequences already sounds a really big number. If we're only going to
> have each driver supporting, say, no more than 10 models, perhaps the
> problem is not even an issue in practice.
>=20
> - Are there ways to limit this bloat in the driver? One obvious way
> would be to discard the unused sequences after driver probe, but that
> only works for platform devices. Although, I guess these sequences would
> mostly be used by platform drivers? If so, then the problem could be
> solved by discarding the data after probe. Another would be to load the
> sequences from a file as firmware, but that feels quite an awful
> solution. Anybody have other ideas?
>=20
> One clear positive side with in-driver approach is that it's totally
> inside the kernel, and can be easily reworked in the future, or even
> changed to a DT-based approach as presented in this series if that seems
> like a better solution. The DT based approach, on the other hand, will
> be more or less written to stone after it's merged.
>=20
>=20
> So, I like the framework of expressing the sequences presented in this
> series (except there's a problem with error cases, as I pointed out in
> another post), as it can be used inside the drivers. But I'm not so
> enthusiastic about presenting the sequences in DT.
>=20
> My suggestion would be to go forward with an in-driver solution, and
> look at the DT based solution later if we are seeing an increasing bloat
> in the drivers.

Assuming we go with your approach, what's the plan? We're actually
facing this problem right now for Tegra. Basically we have a DRM driver
that can drive the panel, but we're still missing a way to hook up the
backlight and panel enabling code. So we effectively can't support any
of the LVDS devices out there without this series.

As I understand it, what you propose is similar to what ASoC does. For a
specific board, you'd have to write a driver, presumably for the new
panel/display framework, that provides code to power the panel on and
off. That means we'll have to have a driver for each panel out there
basically, or we'd need to write generic drivers that can be configured
to some degree (via platform data or DT). This is similar to how ASoC
works, where we have a driver that provides support for a specific codec
connected to the Tegra SoC. For the display framework things could be
done in a similar way I suppose, so that Tegra could have one display
driver to handle all aspects of powering on and off the various panels
for the various boards out there.

Obviously, a lot of the code will be similar for other SoCs, but maybe
that's just the way things are if we choose that approach. There's also
the potential for factoring out large chunks of common code later on
once we start to see common patterns.

One thing that's not very clear is how the backlight subsystem should be
wired up with the display framework. I have a patch on top of the Tegra
DRM driver which adds some ad-hoc display support using this power
sequences series and the pwm-backlight.

=46rom reading the proposal for the panel/display framework, it sounds
like a lot more is planned than just enabling or disabling panels, but
it also seems like a lot of code needs to be written to support things
like DSI, DBI or other control busses.

At least for Tegra, and I think the same holds for a wide variety of
other SoCs, dumb panels would be enough for a start. In the interest of
getting a working solution for those setups, maybe we can start small
and add just enough framework to register dumb panel drivers to along
with code to wire up a backlight to light up the display. Then we could
possibly still make it to have a proper solution to support the various
LVDS panels for Tegra with 3.9.

I'm adding Laurent on Cc since he's probably busy working on a new
proposal for the panel/display framework. Maybe he can share his thought
on this.

All of the above said, I'm willing to help out with the coding if that's
what is required to reach a solution that everybody can be happy with.

Thierry

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQrL2iAAoJEN0jrNd/PrOhgnwP+gLTl+P2KDOOR0ReanApXMIo
wb+D1JnN2VFu0/ejP3kvOV6jvwhU8iQ90Zozia61tcsUluZvNWj4jy1qL0ewSm4y
8K/nZDx3CR45UHcRELT4YWbxeCtGXMZ03o6c0oV9bqM+TtAMV3CwEelOOQ29JNvQ
Mi6lF3ZeKXNiBDCLgY4LbhmTZKc52s36sfWT3V42TRvO5Ft97uYCNeCeTC++kmmi
f+dGb2prZN2BEL5jmNsGCpkE1uftQr+t9MYcK4kDmt2TkUpeFxpCExhhgDyIPJ9w
uAZD8dc9u+50gjk2GgWi+6DZRXzdONletF+8xz6epnc070C7eZ41bZ4J3f3Ublpx
DpLBdpF04l0OtdFxpQIhfeXLAVbIDYRZ0PLWpZuJx+1IjZpJH1GWZJo2IVm39USP
BcCBlmTBgavqQ4gS1+vpNeMowb7o51JbwcqnpcXfWdAkttxpPcv+bwKtb2+KdZcO
9D2yhd477LAk5wnzt7+f96tyY/8kpEUeBV5nxPbYKXyVfL1WRjNtr653YykEzbjf
FquaG/TW7SlJwBYBIKTxfnCHKc+vR0OipFDa2TDUsgYiaYoPypP2QVBAkKVD5Jd7
0sO2oI5WSVhFQj5UXxtptmtZIKDqKmFrbweQoJUb2F4kUwnVQ/6qUtFtasws2Zqe
fQrTJdvrhFNtkjhTC+C6
=iR/N
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
