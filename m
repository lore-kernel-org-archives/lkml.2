Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab1LGGFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 01:05:45 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:54342 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab1LGGFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 01:05:44 -0500
Date: Wed, 7 Dec 2011 17:05:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: build failure after merge of the final tree (pci tree
 related)
Message-Id: <20111207170533.3dea865573c916e79d274eca@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__7_Dec_2011_17_05_33_+1100_EHATYxG8VV9PKEIs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Dec_2011_17_05_33_+1100_EHATYxG8VV9PKEIs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

arch/sparc/kernel/pci.c: In function 'pci_scan_one_pbm':
arch/sparc/kernel/pci.c:697:7: error: incompatible type for argument 5 of '=
pci_create_root_bus'
include/linux/pci.h:665:17: note: expected 'struct list_head *' but argumen=
t is of type 'struct list_head'

Caused by commit fa3cec8aff53 ("sparc/PCI: convert to pci_create_root_bus
()"). Same typo as for the powerpc tree. :-(  Please double check the
rest of those changes, please.

I applied the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 7 Dec 2011 17:02:12 +1100
Subject: [PATCH] sparc/PCI: fix up typo from pci_create_root_bus conversion

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/kernel/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 0905dbd..bb8bc2e 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -694,7 +694,7 @@ struct pci_bus * __devinit pci_scan_one_pbm(struct pci_=
pbm_info *pbm,
 	pci_add_resource(&resources, &pbm->io_space);
 	pci_add_resource(&resources, &pbm->mem_space);
 	bus =3D pci_create_root_bus(parent, pbm->pci_first_busno, pbm->pci_ops,
-				  pbm, resources);
+				  pbm, &resources);
 	if (!bus) {
 		printk(KERN_ERR "Failed to create bus for %s\n",
 		       node->full_name);
--=20
1.7.7.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_Dec_2011_17_05_33_+1100_EHATYxG8VV9PKEIs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3wItAAoJEECxmPOUX5FEBVkP/irjvBl21fENPbEP321JKaTg
U03zwoXQIlQ8gnjMAx5ccWl6EmzvfnpR4ucSfeRC5Btra3hz7v9K5AOhc9ept1sF
nQBxulFxSA58J9Pg8BANrfihGU+nJ7f/HPWNrdc9T/iUSQwYqOwOcFoneJ0ML1Uu
nlI64h8P1KbQWKK1V3IozZmpaUFgOBQPHnA4QijhpRRhWPe1LhwS+ecK+6CjUZat
wF/vQ7DxsCq6ZtColw+UP5K4J+FpoX8Az/++iUspUDMbzkil4uK6KC91xe65rVDm
kAMaKUVw7xGb/6859dQLhaF3GK17rv0JHCCVEgXmJtAgYt/cLtDrBL+HLnDBGKjm
GixgtBYrAikS97omBc6tmgMFlzHH0GIxaNoLBEGl1sOnEeZMAKlTlOMWUSQeUOyz
FTfhxx8fEmssJvhDf2QGlYV0w9gaqUPZA5n9zrBooCjxzH2UZ2fXe5NKpeBrknzH
l57wiHi79esg+W2HwcGt3CbZvZCB3oh4OPzkbFcfYZFBt63X6NXjaEN79M0Xcr0b
HqDHECbB1vbm4j8NWWHjZxALBMHSPKNDQzJ1ylAYvHXQKYOWcnHi6HCmZe4PUki7
HsYsANwfmzSg8NTOc2bhZu4rfvLasalhcXGSr2PmbpcUmYT8pUMYY7vg7nD8uGtv
gHPcEezStKRxVGtkW3ds
=K2L/
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Dec_2011_17_05_33_+1100_EHATYxG8VV9PKEIs--
