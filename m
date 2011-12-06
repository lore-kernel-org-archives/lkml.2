Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab1LFDNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 22:13:08 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:40774 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab1LFDNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 22:13:06 -0500
Date: Tue, 6 Dec 2011 14:12:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: linux-next: manual merge of the memblock tree with the vhost tree
Message-Id: <20111206141255.22281e0c2ff454259238d5a0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Dec_2011_14_12_55_+1100_wC+W//8i4yOX+S39"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Dec_2011_14_12_55_+1100_wC+W//8i4yOX+S39
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

[Tejun, I know you told me about these, but I am reporting them anyway
just for completeness.]

Today's linux-next merge of the memblock tree got a conflict in
arch/score/Kconfig between commit 4673ca8eb369 ("lib: move GENERIC_IOMAP
to lib/Kconfig") from the vhost tree and commit 77bd85cae44e ("score: Use
HAVE_MEMBLOCK_NODE_MAP") from the memblock tree.

Just context changes (and white space).  I fixed it up (see below) and can
carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/score/Kconfig
index 455ce2d,1b4d02b..0000000
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@@ -1,10 -1,12 +1,13 @@@
  menu "Machine selection"
 =20
  config SCORE
-        def_bool y
-        select HAVE_GENERIC_HARDIRQS
-        select GENERIC_IRQ_SHOW
-        select GENERIC_IOMAP
+ 	def_bool y
+ 	select HAVE_GENERIC_HARDIRQS
+ 	select GENERIC_IRQ_SHOW
+ 	select HAVE_MEMBLOCK
+ 	select HAVE_MEMBLOCK_NODE_MAP
+ 	select ARCH_DISCARD_MEMBLOCK
++	select GENERIC_IOMAP
 =20
  choice
  	prompt "System type"

--Signature=_Tue__6_Dec_2011_14_12_55_+1100_wC+W//8i4yOX+S39
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3Yg4AAoJEECxmPOUX5FEdsAP/3IEHh1CBrpeNWZTHoB6/n5I
Y0wtKjkPbw67vGflvx4WvsAnUP8jROg0OF+KmxyHJKo10DkQnhVfNGI/Jwb03lWT
v0V1vDytF8y/4lL+SkuAtrvk+LJ4tFOi5eDjnOXVnkWNbBvsVLgrxs/s0vda0PuW
q4dHHLnKmfX30YU8GyUgB0V6bCZjGgtb/0uDtSYlrJBjC7JlXC8kmdSKHVML33fH
nRBcueyj7r0N+tzZvWYK2apWxEOSws1hY79cc0vO5ZyA1uLpjXQ+hUga7O7bdQC6
oQKMyOu7u4Qet8bL4LWeogsVpRsMWc+IJ7xREpQBU8Tec7RosibEgNxAqlDD6j4j
S/5Q7KXxgVGraaYmI8jZqrepcrwoVPlT21xc2xB98mYS7rMkZgRjrOcReJiyPdgm
6Z+RA48n9+jS/L3GvjY+HmTYETYOwElHeXEQ/GsoVqHcp3TbxLL/XCNbjOw9Qy3H
eEmn/2FGB9XVSjZMQtAfHzVjVeV1etSWOsz88Psu9mFF5IBNqUIDxP3vQxlKFVpO
ZdWNkxGL+FhwI3y/vGe+/uLubgFDJV/CQP7/ZBGq2+IuEArELRFfbaKUt+jdjq1s
REFDycKBSkZ/wZbBX/IL3IbazmvAJHs36UWm5KWDwnS7NNgntL8eGvNt7zvE9pLy
rjqF2n7t3+Z14yvw2Rg6
=EVQP
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Dec_2011_14_12_55_+1100_wC+W//8i4yOX+S39--
