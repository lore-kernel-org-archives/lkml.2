Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0C3MmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 08:42:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58215 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab0C3MmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 08:42:01 -0400
Date: Tue, 30 Mar 2010 14:41:58 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 13/24] mfd: fix dangling pointers
Message-ID: <20100330124158.GJ29472@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <1269094385-16114-14-git-send-email-w.sang@pengutronix.de> <20100325104137.GA3720@sortiz.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JsihDCElWRmQcbOr"
Content-Disposition: inline
In-Reply-To: <20100325104137.GA3720@sortiz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JsihDCElWRmQcbOr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 25, 2010 at 11:41:38AM +0100, Samuel Ortiz wrote:
> Hi Wolfram,
>=20
> On Sat, Mar 20, 2010 at 03:12:54PM +0100, Wolfram Sang wrote:
> > Fix I2C-drivers which missed setting clientdata to NULL before freeing =
the
> > structure it points to. Also fix drivers which do this _after_ the stru=
cture
> > was freed already.
> Patch applied, many thanks.

Thanks. Sadly some fixup will be needed:

We reached an agreement that a) setting the clientdata-pointer to NULL shou=
ld
be done in the i2c-core [1] and b) how to do it. Based on that, I will do t=
he
modification of the i2c-core for 2.6.34 (as it fixes the dangling pointers)=
 and
then create one single patch removing the then superflous calls to
i2c_set_clientdata for 2.6.35 (as it is a cleanup). As you already applied =
the
above patch to your branch: you don't have to revert, we will fix it for yo=
u in
the next round.

Sorry for the detour!

Kind regards,

   Wolfram

[1] http://thread.gmane.org/gmane.linux.drivers.i2c/5674/focus=3D5729

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--JsihDCElWRmQcbOr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkux8ZYACgkQD27XaX1/VRsWPQCeKipiGJ4vmu3Xb0myM+cG3Rx4
OYYAoL9SIRKKxnPXLO+9qOgDgedTzq54
=mQLF
-----END PGP SIGNATURE-----

--JsihDCElWRmQcbOr--
