Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2DKFMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 01:12:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43193 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab2DKFMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 01:12:08 -0400
Date: Wed, 11 Apr 2012 15:11:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: linux-next: build failure after merge of the final tree (devicetree
 tree related)
Message-Id: <20120411151155.b1a614f174442a592d1c1561@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__11_Apr_2012_15_11_55_+1000_/5lwMDzloiumeSrR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Apr_2012_15_11_55_+1000_/5lwMDzloiumeSrR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

drivers/of/of_mdio.c: In function 'of_mdiobus_register':
drivers/of/of_mdio.c:75:4: error: implicit declaration of function 'irq_of_=
parse_and_map' [-Werror=3Dimplicit-function-declaration]

Caused by commit e46c11b94787 ("of/irq: add empty irq_of_parse_and_map()
for non-dt builds").  SPARC has CONFIG_OF but not CONFIG_OF_IRQ ...

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__11_Apr_2012_15_11_55_+1000_/5lwMDzloiumeSrR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPhRKbAAoJEECxmPOUX5FEdW0P/1r+3uPcPIuiYgvE28K34M46
YHFyFVX438KLrQGzRHRBg9E4Edj9Sp5idtM6haWaLC7vKvFvlY3aCZu2QWaRHvLG
0PSUfkyptK9smAm9dvf/jQlEjD7CucGy0Svd6BI5xRVgFIe+V2srFAHDRfDYpmjn
d+yKAxiwxCYkSSeOW+s7/pB1nO5A6M6aYMfV6B3oqLomf+bQnssS0EBBeoOtjMcy
WuKu25Egf7H0zxcE4uF4ZdDykjlA9CvllDGJggK0NdOwOTVLHiDfCnFCA1oAhXkA
pswb7rt/0MWzcMObPkUIVifOl3CMMkQIYiSkVgF/1qlkfjb5blImy2S5kDsDUAy+
XJq8H+F7sSz7FI9wk9ZBdh6wEFuOkTbytMsHLmPlrv1oSJ7YHyKWonI8nhaSEZSp
eyWS1PN1e0O4XR9/uTWm9OjUpDlAw976YSdqXuZD5iirc6ghBRpnteAVYMIRzyJA
36ROZ/udZmszXfJL9/6nID8AALjI3dIybbxpirsrR1ia28KS5e55oiTFfL1eTU/S
UrLttX6hEiYYO+B6TIHQ60MdF4952NYOH/q++jf4dt6cC4j1oxZEXalLq+Y2RsGG
3RLxMrklQFxvpiul4kMQwnYJ929Xr7udBk3JBxH5M3ZyX9a8RvO6FLe0z7yTnArA
2an2RDOc6TBdJM9BcJMT
=jiaP
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Apr_2012_15_11_55_+1000_/5lwMDzloiumeSrR--
