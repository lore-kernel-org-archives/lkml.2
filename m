Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab2BILob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 06:44:31 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:50161 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756700Ab2BILoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 06:44:30 -0500
Subject: OMAP4 HDMI PHY bug work-around for stable
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vWDozE+asA7fLExxzMhi"
Date: Thu, 09 Feb 2012 13:44:25 +0200
Message-ID: <1328787865.1909.64.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vWDozE+asA7fLExxzMhi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

There is a hardware bug on OMAP4, which may cause the HDMI output to
break irreversibly. A work-around for the bug has been merged into
mainline, but is missing from stable.

I've backported the necessary patches on top of 3.0, 3.1 and 3.2 stable
trees, and pushed the following branches to:

git://gitorious.org/linux-omap-dss2/linux.git

fixes/for-3.0-stable
fixes/for-3.1-stable
fixes/for-3.2-stable

3.0 and 3.1 branches additionally contain a patch "OMAP: DSS2: HDMI: use
default dividers", which fixes a problem with the HDMI clock divider.
Without that the HDMI output won't start at all on those versions.

The branches contain the following backported patches:

      OMAP: DSS2: HDMI: use default dividers
      OMAP: 4430SDP/Panda: use gpio_free_array to free HDMI gpios
      OMAP: 4430SDP/Panda: rename HPD GPIO to CT_CP_HPD
      OMAPDSS: remove wrong HDMI HPD muxing
      OMAP: 4430SDP/Panda: setup HDMI GPIO muxes
      OMAP: 4430SDP/Panda: add HDMI HPD gpio
      OMAPDSS: HDMI: PHY burnout fix

Of those, the actual fix is in the last one, but as the GPIOs for HDMI
were a mess, they needed some cleanup patches before the fix could be
made.

I'm not familiar with the process with stable kernels, so are the
branches above fine to get them merged? Or should I send the patches
with git-send-email?

 Tomi


--=-vWDozE+asA7fLExxzMhi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPM7GZAAoJEPo9qoy8lh719ooQAJ3DlH97yecbChhZY/O2bqAc
R5iRhMP7UWp+DwS/h40WBdBEFoVI+iuVNdRzcqp64lt/+LAI+f+ExXTtaGaVfKGv
oev+v6OrUOOYJIoMUIH4KJBvpsOERetueAQKXMvKlResJpdzk9wBcuM8P51+l3kE
f/GOxbfuGpwVmAlXw9rcbMaTj9IUp+MWL2EyN4gZWIfT5O2DlH3LgB/Li6MExWxA
XyefZ4Xzr9WeHm+8xn4pv2ndEPhLpQWN3pPBGa2uOdg0DY4tTDzJBPOAs9ItASQF
lXoKbwpOwxHFBJnpWJDYg9yNVjBtplFg68SGbzkEK5gzjQrFErcl4/19EQryVvUW
57u012W3uXTBGcckkTw5vobJeOm8B2CTtks7U/FdZyYdx1l9chSv9/Rk5PviPZqT
I2YxmcmsKlcK89JEBO8yf+KueJhQ0weDClgYm51/FX46qs7Bce7bIJ0pMiA10cpP
Ghw1kfxDGfQwVSF8Q/pqHQELoopydguirxFaDKqPq7WGjIaIghDTPCK/jjBhfQol
BlpCjLrlGQqJwlj9v7/5yZ9l2h2gggIKQ0/pTPDz/g1DI0Wi6YSELOgLDQAEfWl1
KCxrPPmBYaydsXdtuHqIyFnYwrt+Qoh4visfB0Bj7Uv9wLe4k9F/glxIGjOf1awf
UdyB0ToVbaM/Zm/6gU73
=dg9R
-----END PGP SIGNATURE-----

--=-vWDozE+asA7fLExxzMhi--

