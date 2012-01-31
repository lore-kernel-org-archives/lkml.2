Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab2AaDAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 22:00:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41238 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab2AaDAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 22:00:05 -0500
Date: Tue, 31 Jan 2012 13:59:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the regmap tree with Linus' tree
Message-Id: <20120131135950.0da0eb3e0da92b9a3b658354@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__31_Jan_2012_13_59_50_+1100_/miLUupKmmc114HT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__31_Jan_2012_13_59_50_+1100_/miLUupKmmc114HT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

Today's linux-next merge of the regmap tree got a conflict in
drivers/base/regmap/regmap.c between commit 421e8d2de3bd ("regmap: Reset
cache status when reinitialsing the cache") from Linus' tree and commit
a24f64a64837 ("regmap: Reset device debugfs when reinitialising the
cache") from the regmap tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/base/regmap/regmap.c
index 2cf4bbc,efe287e..0000000
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@@ -284,9 -347,8 +347,11 @@@ int regmap_reinit_cache(struct regmap *
  	map->precious_reg =3D config->precious_reg;
  	map->cache_type =3D config->cache_type;
 =20
 +	map->cache_bypass =3D false;
 +	map->cache_only =3D false;
 +
+ 	regmap_debugfs_init(map);
+=20
  	ret =3D regcache_init(map, config);
 =20
  	mutex_unlock(&map->lock);

--Signature=_Tue__31_Jan_2012_13_59_50_+1100_/miLUupKmmc114HT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPJ1kmAAoJEECxmPOUX5FEopIP/RX4+9sTGfEu9e8u3P9UBwaX
4eS5A9e62nUecFlbxnmyvR5KNHyp1vH1G3DQrvO+TVb4Tnf+uK57a/reHRg7CTSs
ZMzQj/c1F8A9uusZ/dAXzVFqVsXR/1byfCMidHqttSwZ1GSOHUbGRc8a7/UQ1gDR
9YvFfTEOwWwzuq09HruA2z5QdttEhhDl1/zJTAGxyc5xNwtyzFCFBwVsBgtNEXLu
o9KNktswQ7KBWhtflZXQxSq5zmDi/UGMsqsibz2i0TRj+NPzEYx+7+YH/J8soqU6
Hp1GENyImZmCciJ1b66HHIuYDLz+P1OpgBaRJVDWNBwse414Xh9gNKBuRLx9R765
4gqtPiZcMNS0hSaS9cxDzxB9VvSupbAWonUS2UC2Pr7/MPMOimHWoxbfJuerXa76
k2AhESrtY+GBs5e/z5ghjrk5L1OUz0gonyIFRnoWraBb26+DWA3n2k6Plo5NoZ23
3G/+E6767f171roxFuKoLtzjPOfNvuOqn07BZ0SD3l/5DqZPJOiPbk2yZdCww0QA
ulK0gX6+66sCvrDCDXDFaSBcFhA1eQOcICwmb857uLylM1Gl/oOBp0lL+5dyvaGq
kI8K//idON9IOSUagtoONXxIdhOB8laxamoRYVz8JGb+xQ2smjSb2BQLn8ic4dpG
YnxiBwWqiFHivIXjds84
=k/LI
-----END PGP SIGNATURE-----

--Signature=_Tue__31_Jan_2012_13_59_50_+1100_/miLUupKmmc114HT--
