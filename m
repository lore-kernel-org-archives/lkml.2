Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2FYCbW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 22:31:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36862 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab2FYCbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 22:31:20 -0400
Date: Mon, 25 Jun 2012 12:31:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Huang Ying <ying.huang@intel.com>, Zheng Yan <zheng.z.yan@intel.com>
Subject: linux-next: manual merge of the pci tree with Linus' tree
Message-Id: <20120625123108.06ef7f883a323df5221edc98@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__25_Jun_2012_12_31_08_+1000_nryVGxTThuz.9sEG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Jun_2012_12_31_08_+1000_nryVGxTThuz.9sEG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

Today's linux-next merge of the pci tree got a conflict in
drivers/pci/pci.c between commit c2fb8a3fa255 ("USB: add
NO_D3_DURING_SLEEP flag and revert 151b61284776be2") from Linus' tree and
commit 448bd857d48e ("PCI/PM: add PCIe runtime D3cold support") from the
pci tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pci/pci.c
index 77cb54a,3f8b74f..0000000
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@@ -1744,11 -1803,10 +1803,15 @@@ int pci_prepare_to_sleep(struct pci_de
  	if (target_state =3D=3D PCI_POWER_ERROR)
  		return -EIO;
 =20
+ 	/* D3cold during system suspend/hibernate is not supported */
+ 	if (target_state > PCI_D3hot)
+ 		target_state =3D PCI_D3hot;
+=20
 +	/* Some devices mustn't be in D3 during system sleep */
 +	if (target_state =3D=3D PCI_D3hot &&
 +			(dev->dev_flags & PCI_DEV_FLAGS_NO_D3_DURING_SLEEP))
 +		return 0;
 +
  	pci_enable_wake(dev, target_state, device_may_wakeup(&dev->dev));
 =20
  	error =3D pci_set_power_state(dev, target_state);

--Signature=_Mon__25_Jun_2012_12_31_08_+1000_nryVGxTThuz.9sEG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP581sAAoJEECxmPOUX5FEtx4P/2JqCen8p5UdQpCkMTvi7GMb
IubYUUkTBPLOIywkUvw8ncp97UZ6u7qaf494odaKdVIuZ86kNlBQ3DPmlZQe7/lS
WUNHeJCYcm2p2MhUWhiQhCrLVbH1BR5a3CqYWXpignpXskG13vjVmO4jhWRlGDbi
VmiLo2BbfCrTSFW7pHr/ZskaplHgU3Y4xu0QJTNvQTh7WZEinM4TimjtFbjvEIE9
ed8vlBqogONVGsMUZSozlvFrKA0b5ZaDNUtq7DxACctZxzCxHXx7nbJfK43dnpYO
skG7pT+ANiursXhC4BcOVwvf8zPS13HzZ9VPnM+1g7kMAbDIjrGX60z8OFnXg1Dh
QsfZbrvkgEcayjExoPS28khLWukWZdMF4HV5W3MAIdW88dtWFRsfnSE3Hp/vP4kY
eR2pxX6EHj1tT6tlZ3lMvlPOlf98Z63UXwdhMKZwNILtX19I5IMOqaqE2LuXfbod
tkokHhvvr9KxWPYNQP+bQTlFvnHLs4Y6embMZqWYWOkmOKFhDeDsH/V23tegGUWi
XITf1RX5PpgOfGSzttHbrVzSkK/B2sy+f/IMOBJcaMEgB4OUMMULbR7t6YxeVx0C
510d0k1rZyVCDArXZzipYc+mtoll0HqhfdhiwD2PD3/ZXumg5Z6CIpir5w7Tkh6Y
WWSL2yYf0kr4DjE44Ki8
=MtbU
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Jun_2012_12_31_08_+1000_nryVGxTThuz.9sEG--
