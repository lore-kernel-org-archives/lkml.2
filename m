Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab2K0E5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 23:57:38 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48380 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714Ab2K0E5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 23:57:37 -0500
Date: Tue, 27 Nov 2012 15:57:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Bill Pemberton <wfp5p@virginia.edu>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the arm-soc tree with the usb tree
Message-Id: <20121127155732.c3422fdbf62501ee134024d7@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Nov_2012_15_57_32_+1100_l/Q1stWjHYHxzuAC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Nov_2012_15_57_32_+1100_l/Q1stWjHYHxzuAC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in drivers/usb/=
host/ehci-orion.c between commit 41ac7b3ab7fe ("usb: remove use of __devini=
t") from the usb tree and commit 77dae54ab385 ("ARM: Kirkwood: ehci-orion: =
Add device tree binding") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/host/ehci-orion.c
index f74794c,e7e8275..0000000
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@@ -167,7 -184,9 +170,9 @@@ ehci_orion_conf_mbus_windows(struct usb
  	}
  }
 =20
+ static u64 ehci_orion_dma_mask =3D DMA_BIT_MASK(32);
+=20
 -static int __devinit ehci_orion_drv_probe(struct platform_device *pdev)
 +static int ehci_orion_drv_probe(struct platform_device *pdev)
  {
  	struct orion_ehci_data *pd =3D pdev->dev.platform_data;
  	const struct mbus_dram_target_info *dram;

--Signature=_Tue__27_Nov_2012_15_57_32_+1100_l/Q1stWjHYHxzuAC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtEg8AAoJEECxmPOUX5FEqAkP/A4yxupm4CEHNZ+tblM6TinK
nr40hua+35w+qP1AxMrxzv75p5vnwJKl6fJRHKohQjHmsIZIAQktP9IlWlmKrJnX
OrdE0dM3x9nDs+j3DMh4PGdTlM9k/LgdWdU5DWkE6p0voOM3VOxmLJFtf1eCp8g5
hIJZ998INvroRi7gFh8uUBk1N21xzMG9nd6dSyxnP9FjhVj5jS5ZrH47UYuxWI9p
t6pA+heu5fNqglCIDjbztX5T0v1t3VFwX6I9siYCoSSujblPS9mIj/oaAfa2cPUW
5ubi8rdyFGEz0rBYbQ+7WRzsM42cgGoAOkhJWjaB8iT+eRk51kDpf6UpmmsRz0rW
L3CvekT2cpq5KRLk3W2YyhyLUxwtsWKN4HEby0lId+8S5vlPcH1/LbuJieEzj/Xg
O5l5lvJynNaYUV7u8gcSfdvLxf2gRnDcIB1srt95EFnoal0XCMW9f0G0Czobbg3U
sjEHht0jP90IowRIN++5x9xHYdhejt7b/GCJk+czswtkmMSeok7yUJJGp0ts5ROF
IQu6Z8mxMzqaJU+Ne//0mdpzkbMcbUHRLOi0lrDQkmme92BR9/omz3NdFfFqiQOf
GqtqJjamAolt4qixVNAQMgzurwFqVbGHnx8HIPKzja8OqhFxkCiwd2ACxYFJfzaJ
gev2qvlW9tQJazKvorFV
=3E1L
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Nov_2012_15_57_32_+1100_l/Q1stWjHYHxzuAC--
