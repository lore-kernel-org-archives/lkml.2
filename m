Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab2INGnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:43:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38663 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab2INGnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:43:35 -0400
Date: Fri, 14 Sep 2012 16:43:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>, Jeff Garzik <jeff@garzik.org>
Subject: linux-next: manual merge of the dma-mapping tree with the libata
 tree
Message-Id: <20120914164333.c08c0d67584be3c3cabbdd97@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Sep_2012_16_43_33_+1000__PRZQ6XiMi=HPggh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Sep_2012_16_43_33_+1000__PRZQ6XiMi=HPggh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the dma-mapping tree got a conflict in
arch/arm/boot/dts/highbank.dts between commit 8996b89d6bc9 ("ata: add
platform driver for Calxeda AHCI controller") from the libata tree and
commit 33e4628cc333 ("ARM: highbank: add coherent DMA setup") from the
dma-mapping tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/highbank.dts
index 5204cf7,7414577..0000000
--- a/arch/arm/boot/dts/highbank.dts
+++ b/arch/arm/boot/dts/highbank.dts
@@@ -121,9 -121,7 +121,10 @@@
  			compatible =3D "calxeda,hb-ahci";
  			reg =3D <0xffe08000 0x10000>;
  			interrupts =3D <0 83 4>;
 +			calxeda,port-phys =3D <&combophy5 0 &combophy0 0
 +					     &combophy0 1 &combophy0 2
 +					     &combophy0 3>;
+ 			dma-coherent;
  		};
 =20
  		sdhci@ffe0e000 {

--Signature=_Fri__14_Sep_2012_16_43_33_+1000__PRZQ6XiMi=HPggh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUtIVAAoJEECxmPOUX5FEo5gP/2XJUc2D3vzUsIY+zeGygCMO
k00pLqqJ3N6aY1hFrVQjg12rZZ+0mPX+36IcTP/O/76det68b858GwmDIFRf8lW8
d4g8sDvOagmbGmN+DP1OQPyimWcjJ80lWS95Kx79AspNArYKZWi8ryHdGNXakRz5
wtc2SuGoasKRhS1cJP20yHqJkk+Oz1ShOyt3vwpW/3Fd4qI9IZUJ2mpwq9PI4jT+
RGTVIwk4k6lDFaht/KWk75A2jioB/DuZDOFFtLqx5rzIQwxz5LF4AjSOkx66ONVD
CoVmbVWNVXp1VyhbZdW0s/d8tYfJcWdffXN4kELk8E2muDw8KQsRqvKSiC9mooer
tWpwMO+FmW40nOOqRlSKcYa7m3uvcm3W9m3hA1A/E8HoGG6V2xBGp9TGU6/iS1Na
tZ74liWG7N+tnSdyEs9OdvgoDUGQiWdWaxSleuEAe1V7JFUP0Wm0LgHQ7dJGK/0p
km0RPvj5jWloh1Cvl9GFBYnLT6YK+gWuJQS8/0tN7ZyimiqvG+MRsBON1cyTaeJZ
kiaw2gIHkhH/XVqRwv37wFjBuWcgoutz6W2ci+RRYrcGtvlJeOUjlS7/1qhnukT3
uaQk79PpLH1FWKajm35BYWOqaRi5bNm1d3xXtfjnaNGKWE0fndZrfUNeIQALzHDg
FBD717Epz8oIqbdOXqIO
=Etu3
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Sep_2012_16_43_33_+1000__PRZQ6XiMi=HPggh--
