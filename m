Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2LXASf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 19:18:35 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38906 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab2LXASd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 19:18:33 -0500
Date: Mon, 24 Dec 2012 11:18:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Dan Williams <djbw@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: linux-next: manual merge of the slave-dma tree with the
 driver-core.current tree
Message-Id: <20121224111824.249481eabcf2543dc71f8932@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Dec_2012_11_18_24_+1100_A0NaU8Rgrj8=Uva3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Dec_2012_11_18_24_+1100_A0NaU8Rgrj8=Uva3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

Today's linux-next merge of the slave-dma tree got a conflict in
drivers/dma/ioat/dma_v3.c between commit b9016739011f ("Drivers: dma:
remove __dev* attributes") from the driver-core.current tree and commit
370e97b07d80 ("ioat: Add alignment workaround for IVB platforms") from
the slave-dma tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/dma/ioat/dma_v3.c
index e5fc944,e52cf1e..0000000
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@@ -1187,7 -1224,27 +1224,27 @@@ static bool is_snb_ioat(struct pci_dev=20
  	}
  }
 =20
+ static bool is_ivb_ioat(struct pci_dev *pdev)
+ {
+ 	switch (pdev->device) {
+ 	case PCI_DEVICE_ID_INTEL_IOAT_IVB0:
+ 	case PCI_DEVICE_ID_INTEL_IOAT_IVB1:
+ 	case PCI_DEVICE_ID_INTEL_IOAT_IVB2:
+ 	case PCI_DEVICE_ID_INTEL_IOAT_IVB3:
+ 	case PCI_DEVICE_ID_INTEL_IOAT_IVB4:
+ 	case PCI_DEVICE_ID_INTEL_IOAT_IVB5:
+ 	case PCI_DEVICE_ID_INTEL_IOAT_IVB6:
+ 	case PCI_DEVICE_ID_INTEL_IOAT_IVB7:
+ 	case PCI_DEVICE_ID_INTEL_IOAT_IVB8:
+ 	case PCI_DEVICE_ID_INTEL_IOAT_IVB9:
+ 		return true;
+ 	default:
+ 		return false;
+ 	}
+=20
+ }
+=20
 -int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 +int ioat3_dma_probe(struct ioatdma_device *device, int dca)
  {
  	struct pci_dev *pdev =3D device->pdev;
  	int dca_en =3D system_has_dca_enabled(pdev);

--Signature=_Mon__24_Dec_2012_11_18_24_+1100_A0NaU8Rgrj8=Uva3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ159QAAoJEECxmPOUX5FELKIP/jIhnH+voQLSSyP0UoNhSkL9
5KjVD1FEzt+fsDhSE7ZLFdMvL0faSVMKqiWQiHNoX0eBwsVVT0dTo2cW9a4/9rev
qo801WCIJNTUFkrSZEJJ+bpBUoa5Q3oAvd5zKk6tqc2uM21Yw1QIj6N4VCao6cRn
kWmlauW4t+yxiDHUCZ7/SwyGwlUeR6REJ4TXlwjy5o+kLPFKAVfY0tqLWcglBHBS
uHsgZxBiXjCXV6YRcRM+DTNfqiVxgkNV6Ek6BlETpcH2cbENFTyWTdFbCBV9K/jP
46YTEi3Eo55eBacCyhsQ6OpCCNUWjKApmHTfuPvt8uv2XIF+fdUj0vtteLk/5+eK
qIOXsDH8pRzYBUp9ZR6DZr08INgRyYHfdui2oFLslROGd5WH1cY9KRKOrGTdLohz
j3CvQBuRGegfM+XRR3EY1g+u0vFoi/4rx3QpG3W5t7X8w3HRzeXTSsNMP6z9xoC2
7IYwQ430/OS4MErhG/ZJSqrraxK+U0ql0/fwtaSbJ1sZd1sJjj9ryhPZ/Qz3pSSB
lPxBkcgivKlaId4xTeayPZvT83dpTvJj79S5i+M++bSYHMj/w5Z1ciOYXTB9t2wF
qE/2sZgSNf5EmgOGr91Tt7fpYOtGUrUoO9pqgpcr0FuQSqK5fCJfG1cXOo4nCtMJ
ao5Sjq0OfGHS5yOYq9WK
=n/hA
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Dec_2012_11_18_24_+1100_A0NaU8Rgrj8=Uva3--
