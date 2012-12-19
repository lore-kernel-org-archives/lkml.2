Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab2LSXRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:17:53 -0500
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:48471 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab2LSXRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:17:44 -0500
Date: Thu, 20 Dec 2012 00:09:45 +0100
From: Christophe TORDEUX <christophe@tordeux.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Tai-hwa Liang <avatar@sentelic.com>,
        Oskari Saarenmaa <os@ohmu.fi>, Paul Fox <pgf@laptop.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 01/01] Input multitouch: fix horizontal
 two-finger-scrolling on Sentelic touchpads
Message-ID: <20121219230945.GA25106@sherka.no-ip.biz>
References: <20121212012135.GA9043@sherka.no-ip.biz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20121212012135.GA9043@sherka.no-ip.biz>
X-PGP-Key: http://christophe.tordeux.net/data/pgp/c-tor2/pubkey.asc
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Christophe TORDEUX <christophe@tordeux.net>

Apply the following change to the Sentelic touchpad driver:
report only the position of the first finger as absolute non-MT=20
coordinates, instead of reporting both fingers alternatively. Actual MT=20
events are unaffected.

Signed-off-by: Christophe TORDEUX <christophe@tordeux.net>
----

This is a much simpler version of my patch. Basically, it makes little=20
sense to report both fingers alternatively, as long as it's non-MT=20
events. With this approach, storing coordinates of the previously=20
reported touch is not necessary. This patch is against kernel version=20
3.7. Works with a touchpad version STL3888_C0, very probably works on=20
all later version, and very probably does not impact any earlier=20
version. This patch has two effects:
1) fix horizontal and improve vertical scrolling, though maybe in a
coincidental way and 2) work towards making the non-MT absolute events
a purely legacy single finger fallback mode, without breaking anything.

diff -uprN -X vanilla/linux-3.7-rc8/Documentation/dontdiff vanilla/linux-3.=
7/drivers/input/mouse/sentelic.c linux-3.7/drivers/input/mouse/sentelic.c
--- vanilla/linux-3.7/drivers/input/mouse/sentelic.c	2012-12-15 13:51:58.76=
8136524 +0100
+++ linux-3.7/drivers/input/mouse/sentelic.c	2012-12-19 23:26:49.289517251 =
+0100
@@ -791,7 +791,7 @@ static psmouse_ret_t fsp_process_byte(st
 			fsp_set_slot(dev, 0, fgrs > 0, abs_x, abs_y);
 			fsp_set_slot(dev, 1, false, 0, 0);
 		}
-		if (fgrs > 0) {
+		if (fgrs =3D=3D1 || (fgrs =3D=3D 2 && !(packet[0] & FSP_PB0_MFMC_FGR2)))=
 {
 			input_report_abs(dev, ABS_X, abs_x);
 			input_report_abs(dev, ABS_Y, abs_y);
 		}

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQ0kk5AAoJEE/hdwZK2YythjQH/iH4Ac18TZvb2UYlhoVeaQ1a
oGT1j2QjThcP15cbHkmXKptok+t1oM62Hvxr3sEgyOu3u+lz8AkW0SMhBl9LWmc6
jLnWWekc3oOwl93Og1v6fQH0Y6RKqWXh66QnQDNIva3oUaNxwx0x1uMUg4+I3yI4
+ybmBcsZIEIWK/F704mWtvpIOHa8w1OgOys0SJoN3L5vUH6I37zABMbGTYPLsw+e
zCFlsBlrBVLNGqJoPZM/193wvwttYbywaUEAQBtoUeKhS6ap5vr1xNiAhkORaJeW
0Pgb4a6a1qp1O9p5y02CYlomu/XUwtzOg+I2g5BKaTbcKbGdDq9gU0tqJYryEtM=
=MV9i
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
