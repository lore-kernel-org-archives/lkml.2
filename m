Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2KZJ4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:56:20 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33684 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab2KZJ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:56:19 -0500
Date: Mon, 26 Nov 2012 20:56:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: linux-next: manual merge of the arm-soc tree with the arm-soc and
 pincrtl trees
Message-Id: <20121126205615.cda9cfaa998ce6972937d4aa@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_20_56_15_+1100_gXaN9v4t=OiVkhv+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_20_56_15_+1100_gXaN9v4t=OiVkhv+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/at91sam9g45.dtsi between various commits from the
arm-soc and pincrtl trees and commit 7492e7ca0f95 ("ARM: at91/dts: add
at91sam9_wdt driver to at91sam926x, at91sam9g45") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/at91sam9g45.dtsi
index 4212991,a98c00a..0000000
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@@ -472,22 -263,10 +472,28 @@@
  				};
  			};
 =20
 +			mmc0: mmc@fff80000 {
 +				compatible =3D "atmel,hsmci";
 +				reg =3D <0xfff80000 0x600>;
 +				interrupts =3D <11 4 0>;
 +				#address-cells =3D <1>;
 +				#size-cells =3D <0>;
 +				status =3D "disabled";
 +			};
 +
 +			mmc1: mmc@fffd0000 {
 +				compatible =3D "atmel,hsmci";
 +				reg =3D <0xfffd0000 0x600>;
 +				interrupts =3D <29 4 0>;
 +				#address-cells =3D <1>;
 +				#size-cells =3D <0>;
 +				status =3D "disabled";
++			};
++
+ 			watchdog@fffffd40 {
+ 				compatible =3D "atmel,at91sam9260-wdt";
+ 				reg =3D <0xfffffd40 0x10>;
+ 				status =3D "disabled";
  			};
  		};
 =20

--Signature=_Mon__26_Nov_2012_20_56_15_+1100_gXaN9v4t=OiVkhv+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQszy/AAoJEECxmPOUX5FE1iAP/AuY711rfs79DQEMclp7/2gq
2J4wNmPUxeTdZr2bC5/o9qc5KPnFB/NtJYFAscWirpLPCkOL+RpDJwC+W7dh7VB+
HkgkeS+FJpR06B9GgqSzsr/OntyQJBbrnex3MMzWzVwYusKFpQxIIBlMhPLYnrrc
YdOSf3XYDpdPjZrlBbirmHQQ2Kk48G5KdnITKR8F6CqJlZwJV3s5lCoyK1D2ydL1
DOAF03QCUId9G49/rW9A/xS0rPKouRTqyRq0Cxs3tEqtvyEVqCVOplAjV0TN+gGO
zmvR5EieZ8bY0jmsa+kLjMx5rJNsf9Vs5HE58jTmxOgi7GHrbN0OmIeS1CKvSknz
lnZo3+TdYDO/PJ7m46PXVzl3VcTAhanNtty/FHXdWWVccspe2IVJt6dO21g29jw0
MohE1Cwu6Yv3Yuw75NBR0XJTlt06gYkLazdpaQP4G5Yot9gyuQS13TG7dZZoZEOF
20ixRDuXqwuunUFgFHuQzYjWqtzvkfiLvYvmCQiDKoHNbt4Lsqy0/Fl7EE9d6lwg
p1zQb8W8R16Do019Y9yjjIgSx+ogkKotkglpp/ZcpA+3ynO/T1BlyV6sZNiPWDOE
UxcndBJfmNKnz2DdA2xz0Be+gz2asS6IpfPnyG/7DgJ9HwSXi6nXccMs3P5NoX9U
fM4hMAXJstKEf5flvMxP
=ejoj
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_20_56_15_+1100_gXaN9v4t=OiVkhv+--
