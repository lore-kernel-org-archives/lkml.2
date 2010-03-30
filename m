Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab0C3Mti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 08:49:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52752 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab0C3Mtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 08:49:36 -0400
Date: Tue, 30 Mar 2010 14:49:32 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: Re: [PATCH 18/24] rtc: fix dangling pointers
Message-ID: <20100330124932.GM29472@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <1269094385-16114-19-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UUMz/kfoogzZ9WLZ"
Content-Disposition: inline
In-Reply-To: <1269094385-16114-19-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UUMz/kfoogzZ9WLZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 20, 2010 at 03:12:59PM +0100, Wolfram Sang wrote:
> Fix I2C-drivers which missed setting clientdata to NULL before freeing the
> structure it points to. Also fix drivers which do this _after_ the struct=
ure
> was freed already.
>=20
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>

please drop this this patch. We reached an agreement that a) setting the
clientdata-pointer to NULL should be done in the i2c-core [1] and b) how to=
 do
it. Based on that, I will do the modification of the i2c-core for 2.6.34 (a=
s it
fixes the dangling pointers) and then create one single patch removing the =
then
superflous calls to i2c_set_clientdata for 2.6.35 (as it is a cleanup). If =
you
already applied the above patch to your branch, you don't have to revert; we
will fix it for you in the next round.

Sorry for the detour!

Kind regards,

   Wolfram

[1] http://thread.gmane.org/gmane.linux.drivers.i2c/5674/focus=3D5729

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--UUMz/kfoogzZ9WLZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkux81wACgkQD27XaX1/VRtx5wCfZgJACPD30QCZN1KMxLrVxLM/
cA8AoK1bGXV51a1vgcx8HLAsA59LAEEc
=c4Fm
-----END PGP SIGNATURE-----

--UUMz/kfoogzZ9WLZ--
