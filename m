Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab2LMBiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 20:38:06 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40594 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab2LMBiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 20:38:03 -0500
Date: Thu, 13 Dec 2012 12:37:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kumar, Anil" <anilkumar.v@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: linux-next: manual merge of the l2-mtd tree with Linus' tree
Message-Id: <20121213123755.db3d38128e0593a372ccf17f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Dec_2012_12_37_55_+1100_CZfapUg2lWfWOWy5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Dec_2012_12_37_55_+1100_CZfapUg2lWfWOWy5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next merge of the l2-mtd tree got a conflict in
Documentation/devicetree/bindings/arm/davinci/nand.txt between commit
fed16bba8726 ("mtd: nand: davinci: fix the binding documentation") from
Linus' tree and commit 192afdbfbc5c ("mtd: davinci: add support for
parition binding nodes") from the l2-mtd tree.

I fixed it up (maybe- see below) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/devicetree/bindings/arm/davinci/nand.txt
index 49fc7ad,4746452..0000000
--- a/Documentation/devicetree/bindings/arm/davinci/nand.txt
+++ b/Documentation/devicetree/bindings/arm/davinci/nand.txt
@@@ -23,16 -23,37 +23,24 @@@ Recommended properties=20
  - ti,davinci-nand-buswidth: buswidth 8 or 16
  - ti,davinci-nand-use-bbt: use flash based bad block table support.
 =20
+ nand device bindings may contain additional sub-nodes describing
+ partitions of the address space. See partition.txt for more detail.
+=20
 -Example (enbw_cmc board):
 -aemif@60000000 {
 -	compatible =3D "ti,davinci-aemif";
 -	#address-cells =3D <2>;
 -	#size-cells =3D <1>;
 -	reg =3D <0x68000000 0x80000>;
 -	ranges =3D <2 0 0x60000000 0x02000000
 -		  3 0 0x62000000 0x02000000
 -		  4 0 0x64000000 0x02000000
 -		  5 0 0x66000000 0x02000000
 -		  6 0 0x68000000 0x02000000>;
 -	nand@3,0 {
 -		compatible =3D "ti,davinci-nand";
 -		reg =3D <3 0x0 0x807ff
 -			6 0x0 0x8000>;
 -		#address-cells =3D <1>;
 -		#size-cells =3D <1>;
 -		ti,davinci-chipselect =3D <1>;
 -		ti,davinci-mask-ale =3D <0>;
 -		ti,davinci-mask-cle =3D <0>;
 -		ti,davinci-mask-chipsel =3D <0>;
 -		ti,davinci-ecc-mode =3D "hw";
 -		ti,davinci-ecc-bits =3D <4>;
 -		ti,davinci-nand-use-bbt;
 +Example(da850 EVM ):
 +nand_cs3@62000000 {
 +	compatible =3D "ti,davinci-nand";
 +	reg =3D <0x62000000 0x807ff
 +		0x68000000 0x8000>;
 +	ti,davinci-chipselect =3D <1>;
 +	ti,davinci-mask-ale =3D <0>;
 +	ti,davinci-mask-cle =3D <0>;
 +	ti,davinci-mask-chipsel =3D <0>;
 +	ti,davinci-ecc-mode =3D "hw";
 +	ti,davinci-ecc-bits =3D <4>;
 +	ti,davinci-nand-use-bbt;
+=20
 -		partition@180000 {
 -			label =3D "ubifs";
 -			reg =3D <0x180000 0x7e80000>;
 -		};
++	partition@180000 {
++		label =3D "ubifs";
++		reg =3D <0x180000 0x7e80000>;
+ 	};
  };

--Signature=_Thu__13_Dec_2012_12_37_55_+1100_CZfapUg2lWfWOWy5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQyTFzAAoJEECxmPOUX5FE7+IP/2+Ghpn6N8O9Dopp87EeqnMw
Hx6Ec0t+GFFDGby349bOzEeJgOWUybncyk3kHT24NvXiMk33UKjPz7Dj/GUTuoam
pJGTT2PjK/PzqopO/T8eBcU31YUjit/rcGpDYQAstjxhQDRD0GNLdXydLnc+0Hh6
9PlvOBNTncB+0avv3mMTe4KL4JxuRebEytFdp/wgOyUF0uZVINeXxaY5+Vx7Ssnv
xIgx2yoiqd5wzuMirQqSLYPmIr+cXs5kbCWuEUgEy0E0VlbOXfK7k1FIrY3/4tRq
1MO4m3ZRTMayDQyoCLUBPDM+3wDZqHQNVfKDK5dltprFE4/86rFZAAuBhXZDt7Qp
6/AR/ouYOKuoQsGdMFc02qsKCeXloSeLf3AD4OckUcZYJ5KEbioamMHloDU/ncPP
T5dtq6YZtBnMkRNTBiJ8HtBm2HykdBjcPyzTSESpkYfEM1Cmo6fNikdt0ZHHM6LS
K8JdFsUoQi4ohAFLH6e6A+axLtWDsEBArwWNJFZh43ZWggzOuN+B3lmq2RLzeLbL
96DfMomgueTE+ysQi2y1HogIWPR/+R/Os4/B0c1VkOBHH5JkNlUkDJuuBx0EOm1s
k3/035+HI744mFEApvmc4uHkbi5+qY0kOw3FWdi5td3iQtP7oRJhcS34bdOnvWwT
qzrBEIDfJMWc5GnhJeQX
=cdWg
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Dec_2012_12_37_55_+1100_CZfapUg2lWfWOWy5--
