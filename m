Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab2GVBEt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 21:04:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42459 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2GVBEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 21:04:47 -0400
Date: Sun, 22 Jul 2012 11:04:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: linux-next: manual merge of the drm tree with the pci tree
Message-Id: <20120722110435.a0872c4cb5be0de6a416b2fc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__22_Jul_2012_11_04_35_+1000_sy46jB5ciaKuPHGR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__22_Jul_2012_11_04_35_+1000_sy46jB5ciaKuPHGR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
include/linux/pci_regs.h between commit a0dee2ed0cdc ("PCI: misc pci_reg
additions") from the  tree and commit cdcac9cd7741 ("pci_regs: define
LNKSTA2 pcie cap + bits") from the drm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary (though I suspect that we may not need both of
PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 and  PCI_EXP_LNKCAP2).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/pci_regs.h
index 53274bf,7f04132..0000000
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@@ -542,7 -521,11 +542,12 @@@
  #define  PCI_EXP_OBFF_MSGA_EN	0x2000	/* OBFF enable with Message type A */
  #define  PCI_EXP_OBFF_MSGB_EN	0x4000	/* OBFF enable with Message type B */
  #define  PCI_EXP_OBFF_WAKE_EN	0x6000	/* OBFF using WAKE# signaling */
 +#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	44	/* v2 endpoints end here */
+ #define PCI_EXP_LNKCAP2		44	/* Link Capability 2 */
+ #define  PCI_EXP_LNKCAP2_SLS_2_5GB 0x01	/* Current Link Speed 2.5GT/s */
+ #define  PCI_EXP_LNKCAP2_SLS_5_0GB 0x02	/* Current Link Speed 5.0GT/s */
+ #define  PCI_EXP_LNKCAP2_SLS_8_0GB 0x04	/* Current Link Speed 8.0GT/s */
+ #define  PCI_EXP_LNKCAP2_CROSSLINK 0x100 /* Crosslink supported */
  #define PCI_EXP_LNKCTL2		48	/* Link Control 2 */
  #define PCI_EXP_SLTCTL2		56	/* Slot Control 2 */
 =20

--Signature=_Sun__22_Jul_2012_11_04_35_+1000_sy46jB5ciaKuPHGR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQC1GjAAoJEECxmPOUX5FEdb8QAJZfKRcBXEBPe6zoM1BJM5sd
fum3jmcjFgMOb+cAxZdqoiVZ0mPpYHbrJonItBKtvTGf3ewCOEn2C/7pR5Pi1Cum
ApMP2uaVgXqf5x6jOpGqD5M+OVRLj0//CFMQoddfnVhuf/2+KyIy9Dy2r9QZFc4A
NFzg+YRrI64OcC7fHnGs5dXFTKubTQC2WIpYiVGhKSIp/puxeeUVLIgzgi0JnBxk
BVdr4tT8XEOBU++VQ27f59w4KCGxmba0hkGwqVF4ZoIEv+mz4VrjO3xeujSPFXtP
70Kl9aX9NiVVcjwS09mESv1eLWt31E8MFuy1bHPnfiEXnTGR2dv770ktH4hjxiZi
dcQNEfMxwbqrbGDR1CyW84HyXPfjzojLjBheXkUWHGPVEhBGpnP4QIprUNOTdjEe
zT/T05AA9PAkqtb7hKki84ZsZG25AW8E2BFOKwJZp40ZB5fjfi/IwgqxfebKPDC1
VEBHrVI4QKtxR9+1t9NyoyDdQcFoJXSsmw0FCG65eWZoA84oMPvLsNJbpCoxrLDY
frEmvzq0Th7/V0WtGX7VWQkziYHgWafc4xX7hJ+YfqpjTRyj9EDY3GlwuybO9Rbi
FnFm0m1p9dXlMnwM3eXWzRr+Z86psU870cWtAD6AaF4fPwAyNyH57Scc2Yffom5g
u5GBkeJvgTtBG5ed5NR3
=fY8N
-----END PGP SIGNATURE-----

--Signature=_Sun__22_Jul_2012_11_04_35_+1000_sy46jB5ciaKuPHGR--
