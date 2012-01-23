Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab2AWBJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 20:09:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46254 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab2AWBJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 20:09:55 -0500
Date: Mon, 23 Jan 2012 12:09:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henning Heinold <heinold@inf.fu-berlin.de>,
        Varun Wadekar <vwadekar@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>
Subject: linux-next: manual merge of the crypto tree with the tegra tree
Message-Id: <20120123120933.6d4c9cc7050fce2e9fbc9d3a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Jan_2012_12_09_33_+1100_rZmz2td+CPsy00N0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Jan_2012_12_09_33_+1100_rZmz2td+CPsy00N0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

Today's linux-next merge of the crypto tree got a conflict in
arch/arm/mach-tegra/fuse.c between commit b2609c7c7237 ("ARM: tegra:
fuse: add functions to access chip revision") from the tegra tree and
commit e87e06cd8cc0 ("arm: tegra: export tegra_chip_uid") from the crypto
tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

By the way, adding the EXPORT_SYMBOL() really now only needs export.h not
module.h (assuming that the crypto tree has a recent enough base).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/fuse.c
index 17fdd40,ea49bd9..0000000
--- a/arch/arm/mach-tegra/fuse.c
+++ b/arch/arm/mach-tegra/fuse.c
@@@ -119,7 -55,32 +120,8 @@@ unsigned long long tegra_chip_uid(void
  {
  	unsigned long long lo, hi;
 =20
 -	lo =3D fuse_readl(FUSE_UID_LOW);
 -	hi =3D fuse_readl(FUSE_UID_HIGH);
 +	lo =3D tegra_fuse_readl(FUSE_UID_LOW);
 +	hi =3D tegra_fuse_readl(FUSE_UID_HIGH);
  	return (hi << 32ull) | lo;
  }
+ EXPORT_SYMBOL(tegra_chip_uid);
 -
 -int tegra_sku_id(void)
 -{
 -	int sku_id;
 -	u32 reg =3D fuse_readl(FUSE_SKU_INFO);
 -	sku_id =3D reg & 0xFF;
 -	return sku_id;
 -}
 -
 -int tegra_cpu_process_id(void)
 -{
 -	int cpu_process_id;
 -	u32 reg =3D fuse_readl(FUSE_SPARE_BIT);
 -	cpu_process_id =3D (reg >> 6) & 3;
 -	return cpu_process_id;
 -}
 -
 -int tegra_core_process_id(void)
 -{
 -	int core_process_id;
 -	u32 reg =3D fuse_readl(FUSE_SPARE_BIT);
 -	core_process_id =3D (reg >> 12) & 3;
 -	return core_process_id;
 -}


--Signature=_Mon__23_Jan_2012_12_09_33_+1100_rZmz2td+CPsy00N0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPHLNNAAoJEECxmPOUX5FEPhYP/1/Sun9hE98frLTKxuqAZeCH
jh5+EF57aN7Y0lcXztYFzgzqVSIDm2L58pGxTfwVZTvP3r0lAA1A3DQ+qUHPHNKF
eorrZoYss+/6cZFtmbvzywcvQP0dNl4dA9QdO50unH2tcyQbJkqfQE+Gr9pWGdAa
fOdhXkugYxK1T5eZ6DroMBYIt7NHvlmxlE0EHYlcSH05yPzzned7j7vDhvWL+CdS
+s5H9kA4uwByMIpV9sw/bxQVLnFIy87Oj19dEKMfRuKrOsEerNUDzWvy8gbyJNMP
yMmDuZ5lqL6ay6N5D85E5R634iN6VFWBBF1JGUQwzf8rvruKl1+vgHPfn8ejosgS
x3OuptrB9pCXzoOOUusWsGSGXZIE0rUNX2xRBKxkSOmweIPRQ9IrXAKdU6rfelGs
5i7x6z/O2AtMT8bjApRkGpH9vP9ZRlLw75qDQYyVeatpXYLErGsS81XYa6QWaig5
soigboareuByQSDZx3L8YGg8fY2sq7i9J+Q4exlDaK4YXGZcBNLk3fXaNjNOCqLP
nLl58qWc+CFaqfoHJo6kIYi7V3qHX6RY+pQIWwnotQIjBnGOgNADiyHv5MDxUvdr
Uf9LmcpdKc1zNwFk7THtk1EQPp3AMZgmU//azcyWOMeZnSMUJkJQ3jG36u9yJBjl
c3uPyDX7aA9PdmuHDKVH
=ucWc
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Jan_2012_12_09_33_+1100_rZmz2td+CPsy00N0--
