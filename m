Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab2KZJCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:02:47 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56575 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab2KZJCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:02:45 -0500
Date: Mon, 26 Nov 2012 20:02:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bo Shen <voice.shen@atmel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: linux-next: manual merge of the pinctrl tree with the sound-asoc
 tree
Message-Id: <20121126200243.7ad73ab21990661a3f12a01c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_20_02_43_+1100_pSTj6RPr=+IV/E=Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_20_02_43_+1100_pSTj6RPr=+IV/E=Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in
arch/arm/boot/dts/at91sam9g20ek_common.dtsi between commit 531f67e41dcd
("ASoC: at91sam9g20ek-wm8731: convert to dt support") from the sound-asoc
tree and commit 4134a4552748 ("ARM: at91/dts: add nodes for atmel hsmci
controllers for atmel boards") from the pinctrl tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/at91sam9g20ek_common.dtsi
index 2dcec8d,32a500a..0000000
--- a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
@@@ -62,10 -59,28 +69,33 @@@
  				status =3D "okay";
  			};
 =20
+ 			mmc0: mmc@fffa8000 {
+ 				pinctrl-0 =3D <
+ 					&pinctrl_board_mmc0_slot1
+ 					&pinctrl_mmc0_clk
+ 					&pinctrl_mmc0_slot1_cmd_dat0
+ 					&pinctrl_mmc0_slot1_dat1_3>;
+ 				status =3D "okay";
+ 				slot@1 {
+ 					reg =3D <1>;
+ 					bus-width =3D <4>;
+ 					cd-gpios =3D <&pioC 9 0>;
+ 				};
+ 			};
+=20
 +			ssc0: ssc@fffbc000 {
 +				status =3D "okay";
 +				pinctrl-0 =3D <&pinctrl_ssc0_tx>;
 +			};
++
+ 			pinctrl@fffff400 {
+ 				mmc0_slot1 {
+ 					pinctrl_board_mmc0_slot1: mmc0_slot1-board {
+ 						atmel,pins =3D
+ 							<2 9 0x0 0x5>;	/* PC9 gpio CD pin pull up and deglitch */
+ 					};
+ 				};
+ 			};
  		};
 =20
  		nand0: nand@40000000 {

--Signature=_Mon__26_Nov_2012_20_02_43_+1100_pSTj6RPr=+IV/E=Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQszAzAAoJEECxmPOUX5FESxwP/2Z8SiTyFWuKx0Qs1iSXFflL
mDup+X82UCCbx08BExLK89iZm0loyjtN17j19N+bxyW22E9NQm5Z7Qrxp3qlLdwX
jy4WMh1CWKkNlnU7YGMPYLC6eFD+2tOZrS8EsmJ0F7TGBSAb+lf77zV9uKcouiO/
l114DnNCorgbO9ilBhmc2DFKzTzSI+pzJGkiPvOQmvv2PEdTuZIzhsw9YkYIlZys
6+5GL9SQ5IO45J5pxtP2NcjWWKt7mS/3YxVutlf6wr3/GNHjhHthJvPipflZ0xHY
w3jaW9/Pjjdleoyw3kIHDKm2HOH+/ibWogsUXSbCLFu8/jJ5BX/eURTg3RfHntTr
XGG/LD+ry8SpxsnOrl/Zhsa2RpVOO/xAxs9Da1NOEsZHQOWYo3acst48iEnXx1pY
PiEdguiUAKDW54WVnSwRlqj/KUDr/vyO8h0EiTMjMRJswICIHteSym9zY2ZLVyAi
IWqn4s4ZhReGe/RDgGlfLHUouzttYHhbQzn/XVGHOzBwJoiMhW/lC31gmGdHqKCI
cOFdVXRStZzO7XZwSO2FGRQ+psJkq3Jmq4tlxq70I6VDwAq5OofMb0G682nFCUu1
3tKOTFKazy6Qr1qkYzz15W6u315QD3rMXQVvzZCcjJD+jNyPfsoDu7xnArs7Q1BP
Co1H/jvPOwI1zkPNonk2
=Wphn
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_20_02_43_+1100_pSTj6RPr=+IV/E=Q--
