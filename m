Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab2IXOCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:02:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59952 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab2IXOC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:02:29 -0400
Date: Tue, 25 Sep 2012 00:02:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Amir Vadai <amirv@mellanox.co.il>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Roland Dreier <roland@purestorage.com>,
        Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20120925000217.947b8cd8dca6979bfedee2ca@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_00_02_17_+1000_VCVFN4dVBEP/WxHy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_00_02_17_+1000_VCVFN4dVBEP/WxHy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/infiniband/hw/mlx4/cm.c: In function 'id_map_alloc':
drivers/infiniband/hw/mlx4/cm.c:228:36: error: 'MAX_ID_MASK' undeclared (fi=
rst use in this function)

Caused by commit d7a4e9b679e9 ("IB/mlx4: Add CM paravirtualization") from
the infiniband tree interacting with commit "idr: rename MAX_LEVEL to
MAX_IDR_LEVEL" from the akpm tree.

I have added the following merge fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 24 Sep 2012 23:57:53 +1000
Subject: [PATCH] IB/mlx4: fix for MAX_ID_MASK to MAX_IDR_MASK name change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/infiniband/hw/mlx4/cm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/c=
m.c
index e25e4da..80079e5 100644
--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -225,7 +225,7 @@ id_map_alloc(struct ib_device *ibdev, int slave_id, u32=
 sl_cm_id)
 		ret =3D idr_get_new_above(&sriov->pv_id_table, ent,
 					next_id, &id);
 		if (!ret) {
-			next_id =3D ((unsigned) id + 1) & MAX_ID_MASK;
+			next_id =3D ((unsigned) id + 1) & MAX_IDR_MASK;
 			ent->pv_cm_id =3D (u32)id;
 			sl_id_map_add(ibdev, ent);
 		}
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_Sep_2012_00_02_17_+1000_VCVFN4dVBEP/WxHy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYGfpAAoJEECxmPOUX5FEkooQAIJ+MYKXHy558X4YkgGGgLCl
EYkurYQGsCR0cwLJ3BC2LbqiCWs9godb6E/tuA6MbgtV8cu4nueNU61OlsCbJlL9
eG/dMuP30i3FpCIzf7SDwFoPOhtrVddap+yv+9gFBcpp5sGMmSuaWyMLCTgzAfAf
wrimQ7KsQ+GMhNYLlkXDdLJxmH46aTQsNas/JkrB/vsIXSo5tvo1iNvTOxcB5wp3
2Nh31imYGwln+mzgTmnBnLirEKXHLGCHV+i/MpWRlafb1Ff2DFViOPuIo0WAQ7Na
vuRyisBaHXoIqw/A7ufs2smloP+c3uii6w3mV+y43rg6la5vV0PW/1JXwrplNE2t
YRnKG5+XhXhVLt3V19+a5Z2m40ZnEfvBG2/UFyoCyOh50HKw2Z5dbuy4IQMqbpDa
Y1RiDFwtV1BBnLWNagRL+Sa6e/OpP3Rapux6Lk/oGz9kQ8C0Q0o17vFTlRQIkCou
RAX90L5bVRA5at9iAeffZz6YxO2b0RZYkkksdEJpYqDo1PP2nK+EdpPldtx55XfV
2fZyL8Wyzj/zqwayE0g/UTNxy86U6jSqnvOai7sIh7HbuaNmbuvIPNzZXVGOz2o0
7l93kmpSzEXVsf+hrA0Pxc+qLRD4pX9Q9FzEG3ZNSBGiw0exAqN5abXSq4LDAzzZ
yiqiG9eYXlWDAbIPnZPk
=Puf3
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_00_02_17_+1000_VCVFN4dVBEP/WxHy--
