Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777Ab1LFATF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 19:19:05 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:32777 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697Ab1LFATE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 19:19:04 -0500
Date: Tue, 6 Dec 2011 11:18:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Bjorn Helgaas" <bhelgaas@google.com>
Subject: linux-next: build failure after merge of the pci tree
Message-Id: <20111206111852.6931fd03f0b1a86e318a29e3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Dec_2011_11_18_52_+1100_v0.M4vDb4rBJ4mb0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Dec_2011_11_18_52_+1100_v0.M4vDb4rBJ4mb0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

After merging the pci tree, today's linux-next build
(powerpc_ppc64_defconfig) failed like this:

arch/powerpc/kernel/pci_64.c: In function 'pcibios_map_io_space':
arch/powerpc/kernel/pci_64.c:201:2: error: implicit declaration of function=
 'pcibios_phb_map_phb_io_space' [-Werror=3Dimplicit-function-declaration]

Caused by commit fb8fca4ff3f7 ("powerpc/PCI: split PHB part out of
pcibios_map_io_space()").

arch/powerpc/kernel/pci-common.c: In function 'pcibios_scan_phb':
arch/powerpc/kernel/pci-common.c:1726:7: error: incompatible type for argum=
ent 5 of 'pci_create_root_bus'
include/linux/pci.h:665:17: note: expected 'struct list_head *' but argumen=
t is of type 'struct list_head'

Caused by commit 3c73944e7ace ("powerpc/PCI: convert to
pci_create_root_bus()").

I have used the pci tree from next-20111205 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_Dec_2011_11_18_52_+1100_v0.M4vDb4rBJ4mb0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3V9sAAoJEECxmPOUX5FEu88QAI23j/h/q51Myq5MHYnUuhgR
NbxTR7kdM1BLX5LNv2pDdDXdzWLwKJlmdxSx3neVmviCMSUdvnho4SyAkQEUXO/R
0jyNU1ys9DAdJUmUNMADZqd5aylMAqrQRufPWG0CPAF7z7CRnyfO+Nc7q815GKUW
/4vUtMK3VfDYk2ar7nHpjbsdaky5bEjL+ZxzyatHvLgtnvEHmJ+xM/TZpJurVtJ7
Sc4BbDw7FMrdMas5g6SbOkUif0ecs3FQnX/sWohbW75EaoTsFkVk0o8vtB2v1dhj
EnQR/oUoJ4OxZPaftx3s9aZhuaiwk80RiUnXlVwsmYqsiBcxXyGIEUeAt2CRwcwD
fmdpesYIPUH2kRAPi6Y9JhnpgWRVRBBZ8n+g+7tkR79F650l9oyy5NnonbHWB3yX
2gnHKu4be+HE09J9wIx+c/Zi/VKiL8RGFtrQ90P48HPNlrIrN1lPPK997HtpB66t
vCaPQGGvQuZM8aGPussFdevlw0GEdkb60qM/ZpH4tMyBV+7Wfy4L1IVu/9GHs2UR
/d57FvEzFTA4k+GHhyizE+JkaBNpLQa+fnCuyAezUm4riTgsPnlxfA2Op8B24Mlz
FiDMotjA8SDmlhwMfNctcjDk6mBr/USoswvGLUhvOWLv4QXb3sL9NXPgEdi+khfz
BC27HZrPCqoNhebz1V9j
=RPFV
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Dec_2011_11_18_52_+1100_v0.M4vDb4rBJ4mb0--
