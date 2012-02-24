Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2BXMSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 07:18:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44072 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab2BXMSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 07:18:05 -0500
Date: Fri, 24 Feb 2012 13:17:53 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Feng Tang <feng.tang@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c-eg20t: Rework pch_i2c_wait_for_bus_idle to
 reduce wait time
Message-ID: <20120224121753.GE2479@pengutronix.de>
References: <1329725656-32715-1-git-send-email-alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uTRFFR9qmiCqR05s"
Content-Disposition: inline
In-Reply-To: <1329725656-32715-1-git-send-email-alexander.stein@systec-electronic.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uTRFFR9qmiCqR05s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 20, 2012 at 09:14:16AM +0100, Alexander Stein wrote:
> If you insert several i2c transfers, the driver might start the next one
> while the STOP bit of the previous transfer is still on the bus, marking
> the bus as busy.
> pch_i2c_wait_for_bus_idle does an msleep(20) delaying the next transfer
> by >=3D20ms. Reduce wait time by actively waiting 5 us once, then using
> usleep_range.
>=20
> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>

Tomoya, are you happy with it? (I hope he reads the list, since his
companies mailserver doesn't seem to accept my mails).

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--uTRFFR9qmiCqR05s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk9Hf/EACgkQD27XaX1/VRsJBwCfQcJt+ZL0iuZoBYyAOdvX4CiQ
sO4An3T1JN+rCq+8KmpM22VrMrEWrfc7
=cnOu
-----END PGP SIGNATURE-----

--uTRFFR9qmiCqR05s--
