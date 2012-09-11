Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab2IKB3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 21:29:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60826 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab2IKB3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 21:29:35 -0400
Date: Tue, 11 Sep 2012 11:29:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        Yijing Wang <wangyijing@huawei.com>
Subject: linux-next: build failure after merge of the pci tree
Message-Id: <20120911112924.c2206bc738a2c29259f6e2d8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Sep_2012_11_29_24_+1000_iNe+q0uYS_AENYPQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Sep_2012_11_29_24_+1000_iNe+q0uYS_AENYPQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

After merging the pci tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/platforms/powernv/pci-ioda.c: In function 'pnv_pci_window_alig=
nment':
arch/powerpc/platforms/powernv/pci-ioda.c:1163:13: error: 'struct pci_dev' =
has no member named 'pcie_type'

Caused by commit ac161fbfdaa2 ("powerpc/powernv: I/O and memory alignment
for P2P bridges").  pcie_type was removed in commit b2ef39be5744 ("PCI:
Remove unused field pcie_type from struct pci_dev") (also in the pci
tree).

I have used the pci tree from next-20120910 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__11_Sep_2012_11_29_24_+1000_iNe+q0uYS_AENYPQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQTpP0AAoJEECxmPOUX5FEr4MP/2W9SM+iSjubcg3/8vXMIA8f
VR0r04cBnh11Lmj1Z9ucYJ52awAZgRwlKDBUfmjLUauCFugtB//qnoyP+ewtkadZ
4tMd698uyqXrihJLeSHgle8rAMMA/txaPm9fxOyj1y7RZ6YIBErssbuEDry3ejhH
sNHn/lDmuzZrwoR/O6ad+XCmibPJOb09AW87xn1srpGB9CPtt/LTjMDP/jXyHFvG
/UzBMARpzShs1Vso/s6ANK5u2Yg5cYBZ9J5QaRUwpnGCt1zaW+WfrQyXMr/04z0/
jhQGXutGug44PZ/wwqhhOEznSnHJFoRP07uOjTyfoNjla16qnepGqLt6oy6ykgdb
QXx1+bgiNxrKCjkGuCCVaNIPEqv3cNS+4SdfPeVzRL2qTt2LV6ogIWBxT3y2/kfO
bnhQE7ln1j14C0BpJRe3/U4e8q0xIFoahWeZcmQ3776wC7w/GVMKkRwhO7LRt08N
pX+is/IxTbL4tMJBTqza3v1VqIsJFZKa0Nm1dbuO3RuhlpGxe5BBD6jYkcbPZVz5
SWTUU67yjiZTx0yUDxsYfNLracmWQYUu/8T5lqBT+wGQ6KEhCDEllnX492HwoBq2
tQsU9Gck9SY3vqWQXSbM/hvWWoMoQV88GS5kH5+m9Dsk0kUE8dSw8ZWTyn2M1YmY
sPMWVZKx0255vrxvsVma
=IMl4
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Sep_2012_11_29_24_+1000_iNe+q0uYS_AENYPQ--
