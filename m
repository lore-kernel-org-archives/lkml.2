Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2KZKBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:01:49 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59052 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab2KZKBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:01:47 -0500
Date: Mon, 26 Nov 2012 21:01:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        "hongbo.zhang" <hongbo.zhang@linaro.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: linux-next: manual merge of the arm-soc tree with the thermal tree
Message-Id: <20121126210144.d753c9f29a94d0816e8d3709@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_21_01_44_+1100_CNgdeZJ9PjVJwra9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_21_01_44_+1100_CNgdeZJ9PjVJwra9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/dbx5x0.dtsi between commit dc1956b5f84d ("Thermal: Add
ST-Ericsson DB8500 thermal properties and platform data") from the
thermal tree and commit 0563f638f052 ("ARM: ux500: Add node for the MMC
GPIO regulator") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/dbx5x0.dtsi
index 487b705,7ce45fc..0000000
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@@ -695,10 -630,18 +664,23 @@@
  			status =3D "disabled";
  		};
 =20
 +		cpufreq-cooling {
 +			compatible =3D "stericsson,db8500-cpufreq-cooling";
 +			status =3D "disabled";
 +		 };
 +
+ 		vmmci: regulator-gpio {
+ 			compatible =3D "regulator-gpio";
+=20
+ 			regulator-min-microvolt =3D <1800000>;
+ 			regulator-max-microvolt =3D <2600000>;
+ 			regulator-name =3D "mmci-reg";
+ 			regulator-type =3D "voltage";
+=20
+ 			gpios =3D <&tc3589x_gpio 18 0x4>;
+ 			gpio-enable =3D <&tc3589x_gpio 17 0x4>;
+ 			states =3D <1800000 0x1
+ 				  2900000 0x0>;
+ 		};
  	};
  };

--Signature=_Mon__26_Nov_2012_21_01_44_+1100_CNgdeZJ9PjVJwra9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQsz4IAAoJEECxmPOUX5FEAs0QAJbN1GxSOEp5YbasvV9Wzy0k
fk4+X+BVr6nXeLWdQKk6Fo2MBdZl5o+fEUsJ0/L/Dd4fV3ey8YsazebvFmqSVm+u
5BDAIHkTPM+4Q1DVHLtfIGbudyx4nDmMkBnspW1sYOHtt1rfm512vrq0ACvtefG3
bKYXqxQMHRkt+Y9900o5q+0IzMqMSUz1l/M3v17GetY0qpoUMAzwkRrR1wKGcauk
PSRYdijBY0yMCbgdDHZMdcGi0RsOMRQFMg/JEu7QbqrdeFp+8jRghtooektCS4Mf
XoSiaDbkfpZbaj5ac55O3n9MUhcvrzuII3WngXWeMjlgYbUxGJYKX9OQ1BL6w32E
rDyG1hCg4p8O8geR+bA5nGTLe+kSZ3Y9q7YTysRTbx3GsDMTloDHo+h2Wafg6+IR
tiPJnXMl6ZUEmL/pNruNbAgVgWsXBq2664hm3kXVJLoj103eGDMNniOkGjMs2m0V
QbNxxonIJU0U/LyQ0ToNFV2KgBeTlQUcYn1/PNZ59CIj51JlDkvtZXAiFdXdh0H1
bmo/VkqcJjhaaf0BHeZ5M+JWlOU0w4KPqofy8Y9sOlMSd4ALlAidlFcE+vmzmSE4
g9ikCNy2ksUQ2GM6/njRgm0DQOEHF8bpZNW+EBMWOpwz5up1m5ybg/6c7CrcNu3S
RpTf+26fP0gIKsg5D07Z
=fPap
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_21_01_44_+1100_CNgdeZJ9PjVJwra9--
