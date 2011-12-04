Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab1LDM7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 07:59:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42323 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab1LDM7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 07:59:33 -0500
Date: Sun, 4 Dec 2011 13:59:28 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Heiko Schocher <hs@denx.de>
Cc: linux-watchdog@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Wolfgang Denk <wd@denx.de>,
        Stefan Roese <sr@denx.de>
Subject: Re: [PATCH] RFC, watchdog: add generic wdt driver API
Message-ID: <20111204125928.GB5788@pengutronix.de>
References: <1322992423-21683-1-git-send-email-hs@denx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <1322992423-21683-1-git-send-email-hs@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 10.1.0.3
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 04, 2011 at 10:53:43AM +0100, Heiko Schocher wrote:
> This driver implements a character device with major number 10 and minor
> number 130.  It is a software abstraction of the hardware watchdog
> with two different APIs.  While the driver periodically triggers the
> hardware watchdog, the software can setup independent timeout periods.
>=20
> "REGULAR API"
> provides a facility to setup a watchdog behaviour shared by all
> processes using the driver.  This interface uses read, write and
> ioctl calls.
>=20
> "CHAIN API"
> can be used to register configurable "watchdog chains" from
> kernel and/or user space. This interface uses ioctl calls only.
>=20
> more info about this two APIs are found in
> Documentation/watchdog/wd-api.txt
>=20
> Different hardware layers can attached to this driver. As this
> is an RFC add in this patch also, as an example for an hardware
> layer, support for the arm davinci internal WDT.
>=20
> Signed-off-by: Heiko Schocher <hs@denx.de>
> Cc: linux-watchdog@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Wolfgang Denk <wd@denx.de>
> Cc: Stefan Roese <sr@denx.de>
>=20
> ---
> This patch is a port from Linux 2.4 and thought as an RFC, so comments
> are greately appreciated. First question is, has this watchdog driver
> API a chance to go in mainline? If so, what is the direction to
> go to push it ...

I don't see this flying. We finally have a watchdog framework in the kernel
which covers the long existing API used by existing drivers. If I understoo=
d it
right, this additional API needs new drivers for all the watchdogs? Also, I
didn't fully get what you are missing from the combination of the current A=
PI
and additional userspace-handling? (check [1] for one example, not really
covering your use case but showing a potential way maybe) Didn't look much =
at
the code, but glimpsing says it needs some cleanups regarding comments and
excessive debug output.

Regards,

   Wolfram

[1] http://lists.freedesktop.org/archives/systemd-devel/2011-November/00380=
2.html

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7bbrAACgkQD27XaX1/VRvlqgCfYk6kRdyi0oQ1vpqDeyZahXcb
PuQAn1esGX8zXO9bOJLHneIG5Q7uEJlQ
=A9NP
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
