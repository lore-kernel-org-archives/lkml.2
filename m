Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab2KZJxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:53:16 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56673 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab2KZJxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:53:14 -0500
Date: Mon, 26 Nov 2012 20:53:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: linux-next: manual merge of the arm-soc tree with the sound-asoc
 and pincrtl trees
Message-Id: <20121126205312.46fb3f816e1e95ba8cbb5049@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_20_53_12_+1100_xXjUzm9a0H+k2YOd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_20_53_12_+1100_xXjUzm9a0H+k2YOd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/at91sam9263.dtsi between various commits from the
arm-soc and pinctrl trees and commit 7492e7ca0f95 ("ARM: at91/dts: add
at91sam9_wdt driver to at91sam926x, at91sam9g45") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/at91sam9263.dtsi
index 18d9310,ff54612..0000000
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@@ -403,23 -196,11 +403,29 @@@
  				status =3D "disabled";
  			};
 =20
 +			mmc0: mmc@fff80000 {
 +				compatible =3D "atmel,hsmci";
 +				reg =3D <0xfff80000 0x600>;
 +				interrupts =3D <10 4 0>;
 +				#address-cells =3D <1>;
 +				#size-cells =3D <0>;
 +				status =3D "disabled";
 +			};
 +
 +			mmc1: mmc@fff84000 {
 +				compatible =3D "atmel,hsmci";
 +				reg =3D <0xfff84000 0x600>;
 +				interrupts =3D <11 4 0>;
 +				#address-cells =3D <1>;
 +				#size-cells =3D <0>;
 +				status =3D "disabled";
 +			};
++
+ 			watchdog@fffffd40 {
+ 				compatible =3D "atmel,at91sam9260-wdt";
+ 				reg =3D <0xfffffd40 0x10>;
+ 				status =3D "disabled";
+ 			};
  		};
 =20
  		nand0: nand@40000000 {

--Signature=_Mon__26_Nov_2012_20_53_12_+1100_xXjUzm9a0H+k2YOd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQszwIAAoJEECxmPOUX5FEVWMP/2XGRPEoEzJ0t3Jm2Zu4HcTe
TMg7MsTn0vRPqNFi71iY8G57eabUq5N+ZPGcfxUudxVOsIM3KV3HXrxWeq3V5iej
3Jt3bHdawfEivgTm/kogxw4ekEvmjA6HlTLRPklpb+hLY6ogjpZTnrHd8XMnxKyi
tXb1nGACO5VRPAS3Wn+8L7FQ8FKjY//xCtJ73mPmjovLTEoRAxDaoPEVnLzLyte/
p8rfcCTl1ahItYfxPz88itQ09thiesjCUOuh+ZuxWPKKFZhIlXqAw3j5i4Tshnxw
G43smn44M5VT2ZKCO0a7Z+TIYraXBiz7GevuHOCrU9ZII2MJhpkyXTHrgTUuC7yy
wYq6NE0s7kKEGFRFGLU+cNFg/3m5nqNUjho/5p8SjE0ZBGWcDG57CQfMoJ7wtuED
G+n9QkOOZWO1tjcKKTZht6+Zc+m6J2wNmyIcoJNYix1hBue9jxbzFMscnl2AdwIv
waTIX3qouZyAlCcTh6Pz3QSs4OOTeKYIiaUMcK9EVxs49foh/ZQsiT2b6kN/UFwe
+YFoCVT7AExf+kP/A+glZqBc5xLh1zR8xgeRmyiBznITPzTtOC+fFkbLBJy/swyg
V/V2+Eiqae/NhhbsqP5PPzivJeNK9+Kh+RNwUOh7FfYpdzQOxcwHO5CBc5qTPTwH
SYkJO7CM5JAI1NhM0rPX
=rebe
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_20_53_12_+1100_xXjUzm9a0H+k2YOd--
