Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063Ab1LPCak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 21:30:40 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:36517 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452Ab1LPCai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 21:30:38 -0500
Date: Fri, 16 Dec 2011 13:30:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joerg Roedel <joro@8bytes.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: linux-next: manual merge of the iommu tree with the pci-current
 tree
Message-Id: <20111216133026.8bac235bb8495cfd8669b761@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Dec_2011_13_30_26_+1100__CUUaCkCT_BD.QhL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Dec_2011_13_30_26_+1100__CUUaCkCT_BD.QhL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Joerg,

Today's linux-next merge of the iommu tree got a conflict in
drivers/pci/hotplug/acpiphp_glue.c between commit 619a5182d1f3 ("PCI
hotplug: Always allow acpiphp to handle non-PCIe bridges") from the
pci-current tree and commit d90116ea38f7 ("PCI/ACPI: Make acpiphp ignore
root bridges using SHPC native hotplug") from the iommu tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pci/hotplug/acpiphp_glue.c
index 9ddf69e,ba43c03..0000000
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@@ -132,18 -132,6 +132,18 @@@ register_slot(acpi_handle handle, u32 l
  	if (!acpi_pci_check_ejectable(pbus, handle) && !is_dock_device(handle))
  		return AE_OK;
 =20
 +	pdev =3D pbus->self;
 +	if (pdev && pci_is_pcie(pdev)) {
 +		tmp =3D acpi_find_root_bridge_handle(pdev);
 +		if (tmp) {
 +			struct acpi_pci_root *root =3D acpi_pci_find_root(tmp);
 +
 +			if (root && (root->osc_control_set &
- 					OSC_PCI_EXPRESS_NATIVE_HP_CONTROL))
++					OSC_PCI_NATIVE_HOTPLUG))
 +				return AE_OK;
 +		}
 +	}
 +
  	acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
  	device =3D (adr >> 16) & 0xffff;
  	function =3D adr & 0xffff;

--Signature=_Fri__16_Dec_2011_13_30_26_+1100__CUUaCkCT_BD.QhL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6q1CAAoJEECxmPOUX5FESHEP/RX6tAwNmtF510znQXrHpgm0
QiE3B5Zuvh9BBPNFIlYyhZo++PAFf9Ttd92OGWJ3tt0bR+ZZPey6M1CzssBl33Mx
4h+MYbk+EiFhn+aN6/dUiFN07SngqekCjf7BEPjXiMTbQbkGjfMSQZAfdkfhkNkZ
fBtyUgMax2SshpDBulFpELblZT3WQV9xrxP2PFZuSUfegXALc/OsTYfG03d1XF6w
vPYUQOf3amgdqwXXvGx5b6pbWC/VZOGsMdvn/MsVfOeWB75xr6TTlsrVHWRNMW5d
qy8UHKcX7WtsDZEQcXBW/DBe0E7JnpabVx11h34h5o5kVre0awBegIueitzxmzDH
49Dp1ehqGce6ulztaeDYPSXk9d5AXGGky0gEU6WEJacHHKQav7kSgUC43I9mc7yq
q20VLtpj1RTzNRT6HASDPvo74wS+vkmFjSy/ydsYYq/Ay+lOejRe5ZvBj2u/hfqM
reijT7PY00r4H1bApuAj7ewds2DO3zmwjvahMKfiTPMYcKjvDUQOv3mwoESzD+Jt
LuNCfNuUyxvr+w42az/e/ONf6v0gcflR21Ds2W0+2SdswyZmXnEW/NZdKc+ZtcQQ
9EmLDKBlop9BFbJp1AEvoW8+JFg2ys2ZbDvjP3DAdxcyLFGScyaoZxS4xPn3YS5o
p9we7/NlV0Ya3e5m2BST
=6bWc
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Dec_2011_13_30_26_+1100__CUUaCkCT_BD.QhL--
