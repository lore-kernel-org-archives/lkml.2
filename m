Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab2EDS66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 14:58:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59406 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932101Ab2EDS6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 14:58:55 -0400
Date: Fri, 4 May 2012 19:58:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@ardb.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Igor Grinberg <grinberg@compulab.co.il>
Cc: linux-arm-kernel@lists.infradead.org, linux-embedded@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Handling of modular boards
Message-ID: <20120504185850.GO14230@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Thv7PGoFpDPJ7Oar"
Content-Disposition: inline
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Thv7PGoFpDPJ7Oar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Quite a few reference platforms (including Wolfson ones, which is why
I'm particularly interested) use replaceable modules to allow
configuration changes.  Since we can often identify the configuration at
runtime we should ideally do that but currently there's no infrastructure=
=20
to help with that, generally this seems to be done in arch code for the
machine but this doesn't scale when even the CPU might change and isn't
terribly device tree compatible either.

For reference the code for current Wolfson plugin modules is in
arch/arm/mach-s3c64xx/mach-crag6410-module.c.

The most obvious current fit here is the MFD subsystem but it feels like
we need some slightly different infastructure to what MFD currently
provides.  MFD is really set up to handle platform devices with a core
and linear ranges of resources fanning out from that core since they're
really oriented around chips.  In contrast these boards are more about
remapping random collections of potentially unrelated resources and
instantiating devices on all sorts of buses and share more with board
files.

I'm just starting to put some stuff together for this so I was wondering
if anyone had been thinking about this and had any bright ideas for how
to handle it, and also if people think that MFD is a good fit for this
or if we should split the silicon MFDs from these PCBs.

--Thv7PGoFpDPJ7Oar
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPpCbfAAoJEBus8iNuMP3dfkEP/RXH/DIzrKS0pEbgWJi5GTUX
9Z+ijMeWfyrx6bA0vGKVIbeyPwJzf1ziIL4W1GsEB8QRvrZj3zwCI3p7pVd0CjCn
Zyhog0EAOtmsfsn5Cs3u+7dCov39cfKKvfg8Zj3Ksmkp9A6AQbami403TwSUg6Ye
CLbm2ZcQZcLaqQpguzsXkkDxZSi90Oi+GCLMHAbVRRfZL6p3QPaJSXkaAuDtx6gR
0zUwszMaJoxRGndbOr9r2dJ5pBBs+IV2gjcffg651v3Kh4JGzIyOWWm8u25zufrq
VdI5zRnDlOAL3UJzeDMKHFuNczGgvuqMxWeSmKe91nYL+rg2i9Dw0qXU/ZngVSbi
ZlkqfXjq7GVwVAYkBvPK7yjM0Q87fOPTps+K5WIM1HQUASA+DH1vRNpbwaJ0sx6S
MlqvzD5J54U96My1+0h09V7WS96VwKgPBaSsdJURZcP/paZslTsyHDpz9lp6NOOx
nVJ6ip9KPxG8AGHKndjfyc0Kr1GhHip5NEmCIFNNzvc8obpSPRmBLBA5Zo8HmUC8
qfTP8mC8zbRB13fj2fssa40fl6FWtr5wXlc3q7Idkvg+f/1p5hb+AjJwBv41Tn76
Y7UP9g6WUPMidNB95zp1Yq3pYTV/IaBGxqXIcx1HjVcCx/RrC/l+7hkfWRTMfM/1
mLnymYQITdUjMWu9gnXn
=DmpE
-----END PGP SIGNATURE-----

--Thv7PGoFpDPJ7Oar--
