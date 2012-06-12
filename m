Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab2FLEyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 00:54:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51143 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2FLEyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 00:54:50 -0400
Date: Tue, 12 Jun 2012 14:54:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (pci tree
 related)
Message-Id: <20120612145441.400975347f06785d391d0f8f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Jun_2012_14_54_41_+1000_rGOhTANsKHYm/glm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Jun_2012_14_54_41_+1000_rGOhTANsKHYm/glm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

arch/sparc/kernel/pci.c: In function 'pci_scan_one_pbm':
arch/sparc/kernel/pci.c:689:21: error: 'struct pci_pbm_info' has no member =
named 'pci_last_busn'

Caused by commit 2c7f691b032b ("sparc/PCI: register busn_res for root buses=
").

I have added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 12 Jun 2012 14:48:39 +1000
Subject: [PATCH] sparc/PCI: fix typo

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/kernel/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 74e4bf3..4f92a9a 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -686,7 +686,7 @@ struct pci_bus * __devinit pci_scan_one_pbm(struct pci_=
pbm_info *pbm,
 	pci_add_resource_offset(&resources, &pbm->mem_space,
 				pbm->mem_space.start);
 	pbm->busn.start =3D pbm->pci_first_busno;
-	pbm->busn.end	=3D pbm->pci_last_busn;
+	pbm->busn.end	=3D pbm->pci_last_busno;
 	pbm->busn.flags	=3D IORESOURCE_BUS;
 	pci_add_resource(&resources, &pbm->busn);
 	bus =3D pci_create_root_bus(parent, pbm->pci_first_busno, pbm->pci_ops,
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__12_Jun_2012_14_54_41_+1000_rGOhTANsKHYm/glm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP1suRAAoJEECxmPOUX5FEja0P/RogqQHbl5fKJhFPbjjscHVt
wB6g9C9dir1MmI3KIVH33pz2HaRXpMuZOruZbLSN7rD2NeitxKnx/9zHL5QeWe6F
iiBBiCkgDqxB3RTHehncEgpk7vvHwNanNEQeJ3NC/HoqiNqTWTiwL5KhQAVuRcN4
Zy1fQhVo10vIwpEJBEUJB+44GWroO//tcQZGtGI5f5BylWNOCjjYKgn2V7oqHO/5
Hkm0LeeGQ+VCexC9l+tXrg2heMlnxIITmVuoxAD5Xm+ECQA4rTz9aFNjPVPQAHjN
KBGVxgDaU6RQlJstRvgKuecK5+KKL1ieYJLy4K9jo8Vjh0oyofAJacrzUJgdk/r3
Z7ct6td5FLMvVUhV8SjEgDfpvletDDSyNE410tl7kZjvpFkvDClWbftS20pQtBvc
5bMQXYDgjk2VDDKfI3dN4vaGkuipipxCicmMnVNkVNHpyWL8OYGbxCWAkYQdDOxk
JHFdMkaEunO26sLoe5gq5CFXzoR7JVIX0XrERy6U874g7+byR76agS6knauvRlwn
vCeqeO7vjEkf5bFKqkSCNPw2hTFE0OW7XNX54AhAyCJFpyKlAdhqxCFR27MIUCNr
WNci01ICom+ryehZrHvmdWHTOXwjA1CA0bqfgPwFNFLrYcNNArP5YCbpv7BP/CUM
uNK5Y+tgWkvAqxOnH8vq
=AtQy
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Jun_2012_14_54_41_+1000_rGOhTANsKHYm/glm--
