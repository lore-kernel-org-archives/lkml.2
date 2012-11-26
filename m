Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab2KZI5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 03:57:10 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39915 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab2KZI5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 03:57:07 -0500
Date: Mon, 26 Nov 2012 19:56:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bo Shen <voice.shen@atmel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: linux-next: manual merge of the pinctrl tree with the sound-asoc
 tree
Message-Id: <20121126195658.064037771da7d25572848e2b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_19_56_58_+1100_E76ybIBsNSgg70hL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_19_56_58_+1100_E76ybIBsNSgg70hL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in
arch/arm/boot/dts/at91sam9260.dtsi between commit 099343c64e16 ("ARM:
at91: atmel-ssc: add device tree support") from the sound-asoc tree and
commit 9873137a7a22 ("ARM: at91/dts: add nodes for atmel hsmci
controllers for atmel SOCs") from the pinctrl tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/at91sam9260.dtsi
index aaa42d8,b1d3fab..0000000
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@@ -213,13 -436,15 +437,22 @@@
  				status =3D "disabled";
  			};
 =20
+ 			mmc0: mmc@fffa8000 {
+ 				compatible =3D "atmel,hsmci";
+ 				reg =3D <0xfffa8000 0x600>;
+ 				interrupts =3D <9 4 0>;
+ 				#address-cells =3D <1>;
+ 				#size-cells =3D <0>;
+ 				status =3D "disabled";
+ 			};
+=20
 +			ssc0: ssc@fffbc000 {
 +				compatible =3D "atmel,at91rm9200-ssc";
 +				reg =3D <0xfffbc000 0x4000>;
 +				interrupts =3D <14 4 5>;
 +				status =3D "disable";
 +			};
 +
  			adc0: adc@fffe0000 {
  				compatible =3D "atmel,at91sam9260-adc";
  				reg =3D <0xfffe0000 0x100>;

--Signature=_Mon__26_Nov_2012_19_56_58_+1100_E76ybIBsNSgg70hL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQsy7aAAoJEECxmPOUX5FEXokP/2AN/DOt/n33U0epKAmDCT12
MvWzMwYI5EIrjp/x/SBS2zqmqBpEjDY+TawIDOVz1viwk4atnp/s5ySNdoFRxTFi
ve/rbBRDqbdC+RVsQmDNUoY+SWPlPw8Wk5OzAv9eeXCTRLy6OWiNTBtJkoXuKF72
59GM8UFvkNwOtjxkfKCzZ09a1786ct5eLd0Mv9vZZTTUrU/z+tF/kXTvAG4QheEn
VC67FA47DG49x0Wo1ARcEagTWpCweyWeo/whgAEbI83xMjwCBQJTC1wEZQzVQ3pN
P7dC3p0PDjQo5xj4mJdPJ/vKMYNuC+K8RiAngBnU5zctj/0YzLIPS7J/2FF+E1Q4
GeN3GMhDisfLFs3ALl9N6F1/BZ3bSDO7jNqdk08o2RQKJw5b1seY/dhrkyTCY9fl
ADrcnf1SZfQ/FvA4fUFVg3+/yV0s1gs3EmZ7hupOSnii9axPdo7thfhdzCz5Jyqd
X7uQ2HCf2OnRCPhckDdfCM1MPvYju7+rCPF1E9yLz5iUYLs4YhBabxL8+Fp1rvzv
b9pdvcbtb1WncJb430Y671WGELa8a56UBqLOi2O/CChIRta/GKzVZ0jhrUVylsOy
iNcukk7b6Il44uSjVCd+pT65eaiSPswUziqvutgbQZkEMXb7cv2zrepe7rKmSJJw
06NnJJcGAVxjPHVo+hVm
=vNlO
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_19_56_58_+1100_E76ybIBsNSgg70hL--
