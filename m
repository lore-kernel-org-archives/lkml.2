Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2CEGAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 01:00:16 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59465 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab2CEGAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 01:00:14 -0500
Date: Mon, 5 Mar 2012 17:00:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shengzhou Liu <Shengzhou.Liu@freescale.com>
Subject: linux-next: manual merge of the usb tree with the usb.current tree
Message-Id: <20120305170004.9c81f2d148cc179f42a39ade@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_Mar_2012_17_00_04_+1100_t6oueHIWL9finWWS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Mar_2012_17_00_04_+1100_t6oueHIWL9finWWS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/host/ehci-fsl.h between commit 71919403dc86 ("Revert
"powerpc/usb: fix issue of CPU halt when missing USB PHY clock"") from
the usb.current tree and commit 28c56ea14314 ("powerpc/usb: fix bug of
kernel hang when initializing usb") from the usb tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/host/ehci-fsl.h
index 4918062,863fb0c..0000000
--- a/drivers/usb/host/ehci-fsl.h
+++ b/drivers/usb/host/ehci-fsl.h
@@@ -45,5 -47,7 +47,6 @@@
  #define FSL_SOC_USB_PRICTRL	0x40c	/* NOTE: big-endian */
  #define FSL_SOC_USB_SICTRL	0x410	/* NOTE: big-endian */
  #define FSL_SOC_USB_CTRL	0x500	/* NOTE: big-endian */
+ #define CTRL_UTMI_PHY_EN	(1<<9)
 -#define CTRL_PHY_CLK_VALID	(1 << 17)
  #define SNOOP_SIZE_2GB		0x1e
  #endif				/* _EHCI_FSL_H */

--Signature=_Mon__5_Mar_2012_17_00_04_+1100_t6oueHIWL9finWWS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPVFZkAAoJEECxmPOUX5FEXtQP/3zMdpj+iFWTW1JoMrqpFBml
lAIsQRanvuMHl33UhmuUY5Ahs92s4o3A+FQp9u69hoYDaFVMyPIs9OFd0zn2Cp5S
WiiO9oYpOHsmqvIjnvYftE4tTRfmp9sEsLcteoztc1aP814mfiQ8uJSEbVMhD0MQ
YmRQ09n29UrPerd03nm60/peRPjRMa4w7wWJvgd+xTPzSgHL/ptpt37cg2BY0xb/
Fuhwwqop+RaabDYtCpatqFGIci2nX4dMH8znACX+uILFoPI9i3clsnUs4fmntDta
e1POgZNv2g1UEKpBtFG8Yy58ngrxl/F34YJT8wchng3euiaHpU/FI2i0Tzz2PLbI
pyWlH+OKlb4G375VwnNsVyPgamx3s/p+dbKtcRPd8Kpn/CYu+6fn0KiYayzN7Z3O
D7qB1889pHq1MZBEzRolxkT+6ZsLFnKyJm+RsuP6iYPsbRev++oXY7WiCLoAmsJl
S3Cd2GXDAWWtgK7fd6hpVgX9ox9vfx+zimr2i2wABxAROcdlgU+kN8pkSN8VIxgi
LzW9iXtFoAm5mLyv3Oc2JcquTGQo8S+I7bNA4v7ZA+bkhzD3tu39O43R8e5PGseI
w2y3PSZikHMSDRUJe8oL4+9hMcWLXcCZrNS61qzDuMbWZJ5/fy3gnGFHxnSUKGlh
8afnslauY0UT1s7ZTL1F
=37xw
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Mar_2012_17_00_04_+1100_t6oueHIWL9finWWS--
