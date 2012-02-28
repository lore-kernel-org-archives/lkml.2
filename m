Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab2B1F7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 00:59:44 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45074 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab2B1F7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 00:59:13 -0500
Date: Tue, 28 Feb 2012 16:58:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20120228165857.5abb225e1748d40f9c5d61e8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__28_Feb_2012_16_58_57_+1100_fQw_qo8cNF1j9UCW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Feb_2012_16_58_57_+1100_fQw_qo8cNF1j9UCW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/base/regmap/regcache-lzo.c: In function 'regcache_lzo_sync':
drivers/base/regmap/regcache-lzo.c:344:2: error: implicit declaration of fu=
nction 'for_each_set_bit_cont' [-Werror=3Dimplicit-function-declaration]
drivers/base/regmap/regcache-lzo.c:345:41: error: expected ';' before '{' t=
oken
drivers/base/regmap/regcache-lzo.c:340:6: warning: unused variable 'ret' [-=
Wunused-variable]
drivers/base/regmap/regcache-lzo.c:338:15: warning: unused variable 'val' [=
-Wunused-variable]
drivers/base/regmap/regcache-lzo.c:368:1: warning: no return statement in f=
unction returning non-void [-Wreturn-type]

Caused by commits ac8d91c80190 ("regmap: Supply ranges to the sync
operations" and a0941e562e80 ("regmap: Fix x86_64 breakage") from the
regmap tree interacting with commits "bitops: rename for_each_set_bit_cont()
in favor of analogous list.h function" and "bitops: remove
for_each_set_bit_cont()" from the akpm tree.

I have applied this fix up patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 28 Feb 2012 16:15:35 +1100
Subject: [PATCH] regmap: cope with bitops API change (for_each_set_bit_cont)

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/base/regmap/regcache-lzo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache-lzo.c b/drivers/base/regmap/regca=
che-lzo.c
index 8d00615..77dc532 100644
--- a/drivers/base/regmap/regcache-lzo.c
+++ b/drivers/base/regmap/regcache-lzo.c
@@ -341,7 +341,7 @@ static int regcache_lzo_sync(struct regmap *map, unsign=
ed int min,
=20
 	lzo_blocks =3D map->cache;
 	i =3D min;
-	for_each_set_bit_cont(i, lzo_blocks[0]->sync_bmp,
+	for_each_set_bit_from(i, lzo_blocks[0]->sync_bmp,
 			      lzo_blocks[0]->sync_bmp_nbits) {
 		if (i > max)
 			continue;
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__28_Feb_2012_16_58_57_+1100_fQw_qo8cNF1j9UCW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTG0hAAoJEECxmPOUX5FEtTwP/315IU/PgcnCSmTSlCq/Om5K
aGURmxT3mZcF2364jx8fAnfmf7lY4Fv9m73d8rWPHqK+b1lc1XKeqrXUMLWojwSw
pE7vemcpGACiIAT4z7uE5HY9b2r9S2jMJpa3RpK6HHdzTjEqsHHUogP/GgDCYUCn
xDebZ56NSPRJvt5sfaxQ/z3TqxRqyV/5RliB4WoSbZbDeXt8hrrz55wG7Fic++D5
f6UgyJdQ3hKoMBrJ/+Osk4duOqjIKMWR0vv7/7a/9CNu4BuPRvtgCoAye7iZDK+6
hKFQ/9wI03bnvzvvSMsM9FLGEmMO4d1etVarlJOTiEp30r7u1yZVLXCIkuhRCdPV
U7LrL+nqqN1nYB8BmCVZwjzQ3P3IiwHdC1xVBw2zVguXHBDz/0VwHEQoLsR8O8qd
wRzxOAFeOjZ2cCIA3d1W6ixMIdZcw8OIcv5mwp2oIOmK/36atfcpvW4kuumOEcb1
plrsM0SMqj3yK8MPf0sZMurZfjuttqSZOKOZ27mB9J2+wea3yrtAyf5OPyCo6Bog
aQ45JSQGL/RBpPyjS3A+5vpJdRTL3toMu4yaLJGCiOEqDCNz+e/Qm9Z11HbYvoxr
3KfZB59RIG9L5MLavTSQ5RiIRmOfdszUeUM/icFBf1Uv4sdnJtyxS3T9W936dKlu
nr9lhe71ByWGENAI2VpF
=Hg9y
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Feb_2012_16_58_57_+1100_fQw_qo8cNF1j9UCW--
