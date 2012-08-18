Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab2HRJwX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 05:52:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51605 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab2HRJwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 05:52:22 -0400
Date: Sat, 18 Aug 2012 11:52:12 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: vitalywool@gmail.com, khali@linux-fr.org, ben-linux@fluff.org,
        grant.likely@secretlab.ca, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com, jonsmirl@gmail.com
Subject: Re: [PATCH RESEND 2/2] i2c: pnx: Fix read transactions of >= 2 bytes
Message-ID: <20120818095212.GC24812@pengutronix.de>
References: <1344411752-23469-1-git-send-email-stigge@antcom.de>
 <1344411752-23469-2-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c3bfwLpm8qysLVxt"
Content-Disposition: inline
In-Reply-To: <1344411752-23469-2-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--c3bfwLpm8qysLVxt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 08, 2012 at 09:42:32AM +0200, Roland Stigge wrote:
> On transactions with n>=3D2 bytes, the controller actually wrongly clocks=
 in n+1
> bytes. This is caused by the (wrong) assumption that RFE in the Status Re=
gister
> is 1 iff there is no byte already ordered (via a dummy TX byte). This lea=
d to
> the implementation of synchronized byte ordering, e.g.:
>=20
> Dummy-TX - RX - Dummy-TX - RX - ...
>=20
> But since RFE actually stays high after some Dummy-TX, it rather looks li=
ke:
>=20
> Dummy-TX - Dummy-TX - RX - Dummy-TX - RX - (RX)
>=20
> The last RX byte is clocked in by the bus controller, but ignored by the =
kernel
> when filling the userspace buffer.
>=20
> This patch fixes the issue by asking for RX via Dummy-TX asynchronously.
> Introducing a separate counter for TX bytes.
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>
>=20
> ---
> Applies to v3.6-rc1
>=20
> This patch for i2c-pnx affects PNX4008 and LPC32xx (and LPC31xx, not yet =
in
> mainline). Can you please test?
>=20
> Thanks in advance!

I assume you checked this on LPC32xx? I'll wait a bit more but tend to
take the patch anyhow, even if there is no explicit ACK from PNX.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--c3bfwLpm8qysLVxt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAvZcwACgkQD27XaX1/VRvxbQCghFPkAvS7ICRYxWSfNNfDPKNR
yhkAoLY/nVswtaEiUCFrIaUMBDfuh6a4
=Hsg8
-----END PGP SIGNATURE-----

--c3bfwLpm8qysLVxt--
