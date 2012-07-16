Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab2GPGEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 02:04:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48857 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2GPGD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 02:03:59 -0400
Date: Mon, 16 Jul 2012 16:03:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlNqdXIgQnLDpm5kZWxhbmQi?= 
	<sjur.brandeland@stericsson.com>
Subject: linux-next: manual merge of the remoteproc tree with Linus' tree
Message-Id: <20120716160345.d5e88e6e53483a9c08ba3a75@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Jul_2012_16_03_45_+1000_5ugmUwpxGOhnH4RD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Jul_2012_16_03_45_+1000_5ugmUwpxGOhnH4RD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ohad,

Today's linux-next merge of the remoteproc tree got a conflict in
drivers/remoteproc/remoteproc_core.c between commits e981f6d41acd
("remoteproc: fix print format warnings") and 30338cf09f82 ("remoteproc:
fix missing fault indication in error-path") from Linus' tree and commits
bd4849848773 ("remoteproc: Pass struct fw to load_segments and
find_rsc_table") and 72854fb042b1 ("remoteproc: Move Elf related
functions to separate file") from the remoteproc tree.

I fixed them up (see below) and can carry the fixes as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/remoteproc/remoteproc_core.c
index 66324ee,f4d6f7b..0000000
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@@ -1018,9 -784,7 +784,7 @@@ static int rproc_fw_boot(struct rproc *
  	if (ret)
  		return ret;
 =20
- 	ehdr =3D (struct elf32_hdr *)fw->data;
-=20
 -	dev_info(dev, "Booting fw image %s, size %d\n", name, fw->size);
 +	dev_info(dev, "Booting fw image %s, size %zd\n", name, fw->size);
 =20
  	/*
  	 * if enabling an IOMMU isn't relevant for this rproc, this is
@@@ -1032,19 -796,12 +796,14 @@@
  		return ret;
  	}
 =20
- 	/*
- 	 * The ELF entry point is the rproc's boot addr (though this is not
- 	 * a configurable property of all remote processors: some will always
- 	 * boot at a specific hardcoded address).
- 	 */
- 	rproc->bootaddr =3D ehdr->e_entry;
+ 	rproc->bootaddr =3D rproc_get_boot_addr(rproc, fw);
 =20
  	/* look for the resource table */
- 	table =3D rproc_find_rsc_table(rproc, fw->data, fw->size, &tablesz);
+ 	table =3D rproc_find_rsc_table(rproc, fw, &tablesz);
 -	if (!table)
 +	if (!table) {
 +		ret =3D -EINVAL;
  		goto clean_up;
 +	}
 =20
  	/* handle fw resources which are required to boot rproc */
  	ret =3D rproc_handle_boot_rsc(rproc, table, tablesz);

--Signature=_Mon__16_Jul_2012_16_03_45_+1000_5ugmUwpxGOhnH4RD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQA67BAAoJEECxmPOUX5FE7OcP/0Ut1K4RfS/Y28S16Ve1XNJJ
HIYK6RGycLZkJrJPQCXXEgjnZR2n+oRcV2RuVatSP8cCaAMR/Z1l1aoZ8gQa13lq
ShqejHjbZanhQR3w4I4Ep8EfEzyyMv2GNvGpL9jHWmNtYs2LxdGoZFn9yt3NDUk8
THBLY5UPLiRPAqF6T8JsahZ5TjpSX9YQ8GZzbFeBnYebRojAExK2g+Na2EbKpnKJ
ETU1+ZhosEC+O/9TtmcZNFkm85cOr6sSAVlxc2Sc7nYO9cAL7AYFX3abyZn3ZvUm
VdPfZoHxNKRKsB39JVMtmQTqVmPVMlLMdTaMzttpOprYA3imlClHLKHorwR3h+2q
V/mYglznAE+8WMTrk8xondF+fSQvomvvto54xDrl1TZfzBYrVzDMhpXMkausD5wU
xkR1uiZYZkJyonLmR0Img0ct+sAvUyKumABb7BQ+xYO6teCaxELnbPUpUmsluFP+
TPo+mY6qeJLWgQgZ0hCzYVVKpMWrkAyNZFY5ZxfE6zq8y/kcDULlynbUgXSI3lCD
HuuDv+Lx2T+GikFm8Z9rJcgD8Nwd9RNKTeQkDU00Ua51/lEFNaA/vB1IRVGeVhv1
jZt+WrbcrQnBw7d0I9PulZNilu5POV9baH5/p2h4JWsb+virdWkopR5wVrn1Vq2a
2gZTkZnD1AQy3WQ+yGrM
=d3HD
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Jul_2012_16_03_45_+1000_5ugmUwpxGOhnH4RD--
