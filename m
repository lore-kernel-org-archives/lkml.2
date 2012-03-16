Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab2CPGqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 02:46:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45826 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab2CPGp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 02:45:57 -0400
Date: Fri, 16 Mar 2012 17:45:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the arm-soc tree with the s5p tree
Message-Id: <20120316174546.5121be30a86c2937579bd3f5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Mar_2012_17_45_46_+1100_HyhwGTXh6bqEvy5="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Mar_2012_17_45_46_+1100_HyhwGTXh6bqEvy5=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-exynos/common.c between commit 1d7233ac478a ("Merge branch
'next/soc-exynos5250-arch-gpio' into for-next") from the s5p tree and
commit 853a0231e057 ("Merge branch 'samsung/soc' into next/soc2") from
the arm-soc tree.

These merge commits both looks suspect, but I fixed it up as best I could
(see below).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos/common.c
index 4e1d0b7,e6cc50e..0000000
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@@ -593,6 -586,14 +593,13 @@@ static int __init exynos4_l2x0_cache_in
  	if (soc_is_exynos5250())
  		return 0;
 =20
 -	int ret;
+ 	ret =3D l2x0_of_init(L2_AUX_VAL, L2_AUX_MASK);
+ 	if (!ret) {
+ 		l2x0_regs_phys =3D virt_to_phys(&l2x0_saved_regs);
+ 		clean_dcache_area(&l2x0_regs_phys, sizeof(unsigned long));
+ 		return 0;
+ 	}
+=20
  	if (!(__raw_readl(S5P_VA_L2CC + L2X0_CTRL) & 0x1)) {
  		l2x0_saved_regs.phy_base =3D EXYNOS4_PA_L2CC;
  		/* TAG, Data Latency Control: 2 cycles */

--Signature=_Fri__16_Mar_2012_17_45_46_+1100_HyhwGTXh6bqEvy5=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYuGaAAoJEECxmPOUX5FE+YMP+gOkwptMErpznr7+0Euu0h1K
ylJU+jgfpPLanJrfcS/wzFRjLOGCy6V4+f8zK5DxEnnGi6FG1JnAToSOsa1Lf8bs
fqCiC2UaFfYj8S/q3UXpb0VEF18fuH+usWB94DTZ+godzE6TAfYGnuq1N0/VquzA
wVDzrESy62pzybyxruwjXW+kEuUB7zWQC2+OteARYhczXJBsSCkPo0JwayoD4+z1
goiAjELtMjINzcJnlpx/opae/U9pzwlbzQxFc1lnXUZcOBS/rOFSKVEULrEM8Ztq
r1wTl0L8EAva1J4wbSEVYAyLEFHd+TELGx3scKRl+EaK5++LC29f6GwkOvTR4Psp
Fmxg0ve3iIoKHeqRyEM0/GO8dPrgdcwijZRew2C7ziEf0FcsW6wAkUE73dgBqa5q
7yeOox5Fbx4ANYQI3+XPJDMqPbJBqnI4/k4bgVS6RrpD+zkCs/Q4EAs+HQuS2uj/
VfCwn0ycVlnKJBvfpeyjVCLcdN7Tv9x0c8CKrotIosuXZILDCEO0xsjm5zrLxkRo
tIsqGaoW44E1zxVHRzCD06c/Ujc4ZwcgHmuUhMWH1RX7wlErTXz13DKIU8JhElKz
ttPvrCqw/VwcL+pBtX33tUrzTcC7JkcLxsC31JKaoP83vr2RWbZPw1RNzFYD02J6
sITk/BKJJCvNRoHtSRNi
=RL4u
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Mar_2012_17_45_46_+1100_HyhwGTXh6bqEvy5=--
