Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab2IZCDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 22:03:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47977 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2IZCDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 22:03:30 -0400
Date: Wed, 26 Sep 2012 12:03:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sujith Manoharan <c_manoha@qualcomm.com>,
        Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: linux-next: manual merge of the wireless-next tree with the pci
 tree
Message-Id: <20120926120317.63d0b4acb0502bc4c2ffe4b8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Sep_2012_12_03_17_+1000_2dSLfQ2kut7sfoXy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Sep_2012_12_03_17_+1000_2dSLfQ2kut7sfoXy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
drivers/net/wireless/ath/ath9k/pci.c between commit 08bd108096b6 ("ath9k:
Use PCI Express Capability accessors") from the pci tree and commit
046b6802c8d3 ("ath9k: Disable ASPM only for AR9285") from the
wireless-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/ath/ath9k/pci.c
index c4f6980,c0c5996..0000000
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@@ -123,10 -128,12 +123,11 @@@ static void ath_pci_aspm_init(struct at
  	if (!parent)
  		return;
 =20
- 	if (ath9k_hw_get_btcoex_scheme(ah) !=3D ATH_BTCOEX_CFG_NONE) {
- 		/* Bluetooth coexistance requires disabling ASPM. */
+ 	if ((ath9k_hw_get_btcoex_scheme(ah) !=3D ATH_BTCOEX_CFG_NONE) &&
+ 	    (AR_SREV_9285(ah))) {
+ 		/* Bluetooth coexistance requires disabling ASPM for AR9285. */
 -		pci_read_config_byte(pdev, pos + PCI_EXP_LNKCTL, &aspm);
 -		aspm &=3D ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
 -		pci_write_config_byte(pdev, pos + PCI_EXP_LNKCTL, aspm);
 +		pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL,
 +			PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
 =20
  		/*
  		 * Both upstream and downstream PCIe components should

--Signature=_Wed__26_Sep_2012_12_03_17_+1000_2dSLfQ2kut7sfoXy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYmJlAAoJEECxmPOUX5FE4oQP/1hLBLpukEoA0bNHYUSu+7wu
ZhLNXKifBtUBOzSdZ9krWnro+pJbo49acN0NNCZAaz15YsVBW30I5dFJdFvggq3A
0YYtiLVHymagNRBJeqCajh9N4NbPPpgPr+nyiaJs0OeyYYQ2/1KFZENKr/E1wc1o
CwdkgosDBBdK6/usj8pblRTVOB9AVfhQVEi0T1gr+mLLH1r8j4WCfjV0CA1a40M1
OebF7EkqMWXnZAaBeN6+uc435RlcIzaiXsfyDWEpauL0+MQAc003JO752Q8JkgYE
PF5rUrF04DaA4OVnNuhoPGs4lgAfzwOlEWkLMSVsL0Qi+GZTnA73Oq7QCIxpD6kV
UlU/BWSiJXCPL734gBOaq8xRFZ7BIHb3uREcf7m9HqQyttkprREvVN255BAkoWdj
jGswBDsuQQkhcDXKO8IQxcb5CD66/xpIZFW+AHzKSNcVorHdk6qL0nSL/W1eMg88
w4NvRQk/HpUyOyh7PXil6PNKYJpQohnhnRoSIK0T1JAge5zTo2CwnSOxlrA1cH6M
9rm81i4QoBFTSQQYr44wQlUBUlrOOqk8lDJcSAS9YpunzZiVneQjka677R5BK8n3
sHegHHs/vqcyXvtC++KNF7QuFYE24asGFJ7Fyt3TlBsriogjAFCbXPaKiwDeY8Y4
S2gP4RXXT7jmDAjg+nhq
=e1t0
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Sep_2012_12_03_17_+1000_2dSLfQ2kut7sfoXy--
