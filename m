Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031280Ab2B2TG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:06:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55022 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030667Ab2B2TG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:06:28 -0500
Date: Wed, 29 Feb 2012 20:06:21 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Oskar Schirmer <oskar@scara.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Darius Augulis <augulis.darius@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH] i2c/imx: fix imx driver to work though signal is pending
Message-ID: <20120229190621.GD30545@pengutronix.de>
References: <1329999551-32171-1-git-send-email-oskar@scara.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wtrm9ATX0sn6fFKv"
Content-Disposition: inline
In-Reply-To: <1329999551-32171-1-git-send-email-oskar@scara.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Wtrm9ATX0sn6fFKv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2012 at 12:19:11PM +0000, Oskar Schirmer wrote:
> Interrupt a test application for I2C based mc13xxx driven
> touch panel, SIGINT, causes open event file descriptor to be
> closed, which in turn causes I2C activity to mask PMIC local
> interrupts. This eventually ends up in i2c_imx_bus_busy to
> wait for some busy flag to toggle, but while waiting it would
> find a signal pending and break. The final symptom is the
> device is not closed down cleanly and thus not reopenable.
>=20
> Do without check for pending signal.
>=20
> Signed-off-by: Oskar Schirmer <oskar@scara.com>

Thanks. Picked to my for-3.4 branch. I'd like to have some more test covera=
ge,
then we can send it back via a stable-release. If you think it should go in=
to
3.3 directly, please let me know.

Oh, and it got acked by Marc Kleine-Budde via phone :)

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Wtrm9ATX0sn6fFKv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk9Ody0ACgkQD27XaX1/VRthOwCfaoVTegQZx4qonG84FybCC6Bm
r9IAoMLr8dPBmqfsZuyNHB8mXR6hV1Gc
=pzem
-----END PGP SIGNATURE-----

--Wtrm9ATX0sn6fFKv--
