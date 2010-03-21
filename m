Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab0CUCJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 22:09:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40762 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab0CUCJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 22:09:41 -0400
Date: Sun, 21 Mar 2010 03:09:33 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 13/24] mfd: fix dangling pointers
Message-ID: <20100321020933.GB26625@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <1269094385-16114-14-git-send-email-w.sang@pengutronix.de> <20100320172241.GD1549@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <20100320172241.GD1549@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Mark,

> but it really does seem like this is something that the I2C core ought
> to handle - the assignment to null is boiler plate code that's getting
> added to the overwhelming majority of I2C devices in their teardown
> path, it'd seem a lot more sensible for the core to just trash driver
> data after the driver is unbound if it's important that this happens.

While working on this, I got the same impression that it should be handled =
at
core-level. I wondered if functions ala i2c_alloc_clientdata() and
i2c_free_clientdata() could help. But seeing the myriad ways of setting up
private data in those drivers, I thought this to be the next step after
cleaning up the status quo, because it surely needs discussion. I wanted to
write about all this in the introductory message but sadly forgot. Thanks f=
or
starting the discussion, very welcome.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkulf90ACgkQD27XaX1/VRt09gCgjSrBPxPmyQsA+FPnAYKGUqVW
MjgAn3DFPETnj7nqH76Qp2QjJxdK4koV
=9unb
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
