Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab2KLDPO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 22:15:14 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35290 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2KLDPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 22:15:12 -0500
Date: Mon, 12 Nov 2012 14:15:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Subject: linux-next: manual merge of the pinctrl tree with the slave-dma
 tree
Message-Id: <20121112141503.6539e4170839e8f18910bb8d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__12_Nov_2012_14_15_03_+1100_go_d73hvff08dlgj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Nov_2012_14_15_03_+1100_go_d73hvff08dlgj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in
arch/arm/boot/dts/spear1340.dtsi between commit b47394911c26 ("ARM:
SPEAr13xx: Pass DW DMAC platform data from DT") from the slave-dma tree and=
 commit
4ddb1c295752 ("ARM: SPEAr: Add plgpio node in device tree dtsi files")
from the pinctrl tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/spear1340.dtsi
index 8ea3f66,6c09eb0..0000000
--- a/arch/arm/boot/dts/spear1340.dtsi
+++ b/arch/arm/boot/dts/spear1340.dtsi
@@@ -24,25 -24,12 +24,31 @@@
  			status =3D "disabled";
  		};
 =20
 +		dma@ea800000 {
 +			slave_info {
 +				uart1_tx {
 +					bus_id =3D "uart1_tx";
 +					cfg_hi =3D <0x6000>;	/* 0xC << 11 */
 +					cfg_lo =3D <0>;
 +					src_master =3D <0>;
 +					dst_master =3D <1>;
 +				};
 +				uart1_tx {
 +					bus_id =3D "uart1_tx";
 +					cfg_hi =3D <0x680>;	/* 0xD << 7 */
 +					cfg_lo =3D <0>;
 +					src_master =3D <1>;
 +					dst_master =3D <0>;
 +				};
 +			};
 +		};
 +
+ 		pinmux: pinmux@e0700000 {
+ 			compatible =3D "st,spear1340-pinmux";
+ 			reg =3D <0xe0700000 0x1000>;
+ 			#gpio-range-cells =3D <2>;
+ 		};
+=20
  		spi1: spi@5d400000 {
  			compatible =3D "arm,pl022", "arm,primecell";
  			reg =3D <0x5d400000 0x1000>;

--Signature=_Mon__12_Nov_2012_14_15_03_+1100_go_d73hvff08dlgj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQoGm3AAoJEECxmPOUX5FE+dYP/0y3pEtsm1FuomTpV2Iefb/6
SbQKBisvk/QfueP4T7ygjkstEhyU8upsVRaouAwbNKsNsKbjqrH8n2zpxprRSuhi
eJaje0U+EAZEO6clU9RO18mjmysrlt4926Zf2wHvsiBik3Sc5cDupAUZSXnfeUFf
GG8/o1hv0aG0vKnM7gcoVhIFeF0kfqvjbvwHYk7Qc8l4sGxsR3svOGlw0A/PUaso
rBgQGVIWzKKvCWaQMPqQRxg0UPUvDq6nS2sQrhAl1Ey0HZShlilgh5K3kfWVtL6n
1OnqeMWwyA4/nBfh5aKPgnji9BRIECNwNhd7VtXVLf13G16fhrGN4ace/LcoUZFd
8hK7kOsXW86Ipb3oWv236q1t1gOJXYpo1BHWuyPfV24EFzdTXzvwKxB6Y6aBbGc7
4KV9JtbcF0uPdXnyUuBNHVFpS6X4+TgqeN/qNVQZIW7mACEWy9IgTd2ys2F4so/v
q99BNA1+lmgTegEEbBUTj5HWN67ar93LkJCYbcK5c/IzcCEbLlYAz11C5q/De8HZ
lbtrxqIAzREbCCoG/BSbey/5PpxBdcx25gPDVYyWCvDE7Hp4s7l/YN5nKbNxQArn
V5GGuSiLSFUmYT3+AUmnUH3CdNG8XOYBnFODB9q1rkO+Bv1+AixtB59SfQl1+2AM
pf0C5T7IlSzPrsHXMUWZ
=JjEA
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Nov_2012_14_15_03_+1100_go_d73hvff08dlgj--
