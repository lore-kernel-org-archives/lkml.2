Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab0CULbr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 07:31:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49411 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab0CULbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 07:31:46 -0400
Date: Sun, 21 Mar 2010 12:31:14 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 12/24] media/video: fix dangling pointers
Message-ID: <20100321113114.GB26984@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <1269094385-16114-13-git-send-email-w.sang@pengutronix.de> <201003202302.49526.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
In-Reply-To: <201003202302.49526.hverkuil@xs4all.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Hans,

> > Fix I2C-drivers which missed setting clientdata to NULL before freeing =
the
> > structure it points to. Also fix drivers which do this _after_ the stru=
cture
> > was freed already.
>=20
> I feel I am missing something here. Why does clientdata have to be set to
> NULL when we are tearing down the device anyway?
>=20
> And if there is a good reason for doing this, then it should be done in
> v4l2_device_unregister_subdev or even in the i2c core, not in each driver=
s.

Discussion to take this into the i2c-layer has already started. Regarding V=
4L,
I noticed there is a v4l2_i2c_subdev_init() but no v4l2_i2c_subdev_exit(), =
so I
grepped what drivers are doing. There are some which set clientdata to NULL=
, so
I thought this was accepted in general.

> And why does coccinelle apparently find this in e.g. cs5345.c but not in
> saa7115.c, which has exactly the same construct? For that matter, I think

It was the to_state()-call inside kfree() which prevented the match. I would
need to extend my patch for V4L, it seems.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkumA4IACgkQD27XaX1/VRuJKACfYtVBg2DgQcE85z2GznQ4PTFK
OaMAnign0fO1MzKYEi6BQ0BQ5cvBIkoD
=4EBn
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
