Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab2EJE0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 00:26:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55137 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2EJE0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 00:26:05 -0400
Date: Thu, 10 May 2012 14:25:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: linux-next: manual merge of the sound-asoc tree with the regmap
 tree
Message-Id: <20120510142552.35f8e15042053707a2086905@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_May_2012_14_25_52_+1000_EFVx=7tfgBGmFT+5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_May_2012_14_25_52_+1000_EFVx=7tfgBGmFT+5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sound-asoc tree got a conflict in
drivers/base/regmap/regmap.c between commit 6560ffd1ccd6 ("regmap: fix
possible memory corruption in regmap_bulk_read()") from the regmap tree
and commit edc9ae420f98 ("regmap: implement register striding") from the
sound-asoc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/base/regmap/regmap.c
index bb80853,8a25006..0000000
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@@ -775,11 -863,10 +863,12 @@@ int regmap_bulk_read(struct regmap *map
  			map->format.parse_val(val + i);
  	} else {
  		for (i =3D 0; i < val_count; i++) {
 +			unsigned int ival;
- 			ret =3D regmap_read(map, reg + i, &ival);
+ 			ret =3D regmap_read(map, reg + (i * map->reg_stride),
 -					  val + (i * val_bytes));
++					  &ival);
  			if (ret !=3D 0)
  				return ret;
 +			memcpy(val + (i * val_bytes), &ival, val_bytes);
  		}
  	}
 =20

--Signature=_Thu__10_May_2012_14_25_52_+1000_EFVx=7tfgBGmFT+5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPq0NQAAoJEECxmPOUX5FE82YP/i/IRCq3tFURewTneHggvPKE
0GW2liOdZKUnjjVwh7D+BhQWexQiuf7BxvQ3aZ0aXlzPeCOLo+vUVQzbomwj1E8p
nzoUOkRLjogAUrcIHoXA9IlvCFIQw5R9AYvymPs74po4Xfmzb23n1qM2ZsvwhsbO
eSnzrVhSucWrWDFWN74Rz0wjzfLqFeadI9s7OFbcDu/9Tnjg1/X3umZv7PO5XcQv
ggoPu/s7o7w3g6dEGIqjK7GvPx++lj/SFy/5gSzCkkcNWyLst8FqYSB4r+0pvgPA
M6zPWqXPSMmxmB32rbhrrSgXPiGJwVYnMQjiEUAfcqbrNVxhjv8fieWhvHVrNh5c
lybJ52aA5X+FPRzckH+xHEb8LqNQzHd33rI2kWARwsvaw5x0rowsmfAZYFZxaG9C
NQLCk9kRa7ZL/INu47H6GSP8kzpUH74xWjRwCz+pOVnTgYLhBWNNK1jtdUo+lfDy
HnBgAxq+xqvJ7jMUsmwEpNnm3KIKw1EhvBxruXj81TvWoqXH7YTZNw2juMu9T+d9
T6776SB8OPTe+lIdADOZ0bemnuiVYTF2n8zJuSEcpYKW/Zu6V2+wYc2YduIWL0f7
+lNbS+7HO8ak59Njc4v3HMtjhQriJF38I4gRMh6CoSoNztIFR07I7NJl9tfCmMWb
zqvTvbO0hc9W+dPmOeW+
=CC4o
-----END PGP SIGNATURE-----

--Signature=_Thu__10_May_2012_14_25_52_+1000_EFVx=7tfgBGmFT+5--
