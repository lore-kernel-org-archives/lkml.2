Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab1IPDcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 23:32:25 -0400
Received: from home.keithp.com ([63.227.221.253]:43711 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab1IPDcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 23:32:05 -0400
From: Keith Packard <keithp@keithp.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-dev@lists.linaro.org,
        "Clark\, Rob" <rob@ti.com>, Archit Taneja <archit@ti.com>
Subject: Re: Proposal for a low-level Linux display framework
In-Reply-To: <1316107275.23214.99.camel@deskari>
References: <1316088425.11294.78.camel@lappyti> <yunboul7sx7.fsf@aiko.keithp.com> <1316100594.23214.65.camel@deskari> <yun8vpp7qk7.fsf@aiko.keithp.com> <1316107275.23214.99.camel@deskari>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 15 Sep 2011 19:55:37 -0500
Message-ID: <yunfwjxwbjq.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Sep 2011 20:21:15 +0300, Tomi Valkeinen <tomi.valkeinen@ti.com> =
wrote:

> 2) panel drivers, handles panel specific things. Each panel may support
> custom commands and features, for which we need a dedicated driver. And
> this driver is not platform specific, but should work with any platform
> which has the output used with the panel.

Right, we've got DDC ports (which are just i2c) and DisplayPort aux
channel stuff.

The DDC stuff is abstracted out and shared across the drivers, but the
DisplayPort aux channel code is not -- it's duplicated in every output
driver.=20

> DSI bus is a half-duplex serial bus, and while it's designed for
> displays you could use it easily for any communication between the SoC
> and the peripheral.

Yeah, HDMI uses DDC for all kinds of crazy stuff in the CE world.

> The point is that we cannot have standard "MIPI DSI command mode panel
> driver" which would work for all DSI cmd mode panels, but we need (in
> the worst case) separate driver for each panel.

It sounds like we do want to share code for those bits, much like we
have DDC split out now. And, we should do something about the
DisplayPort aux channel stuff to avoid duplicating it everywhere.

I'm not sure a common interface to all of these different
channels makes sense, but surely a DSI library and an aux channel
library would fit nicely alongside the existing DDC library.

I suspect helper functions would be a good model to follow, rather than
trying to create a whole new device infrastructure; some of the
communication paths aren't easily separable from the underlying output
devices.

Oh, I think you're also trying to get at how we expose some of these
controls outside of the display driver -- right now, they're mostly
exposed as properties on the output device. Things like backlight
brightness, a million analog TV output values, dithering control and
other more esoteric controls.

DRM properties include booleans, enumerations, integer ranges and chunks
of binary data. Some are read-only (like EDID data), some are writable
(like overscan values).

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOcp6JQp8BWwlsTdMRAiLoAJ9dqKSIWK/PUo3pI53f0SS8zB3/nwCgvGp7
fMEoV8AmSOXLkfh8XG7NFVg=
=SEWx
-----END PGP SIGNATURE-----
--=-=-=--
