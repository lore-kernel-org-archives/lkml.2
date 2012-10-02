Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331Ab2JBELt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 00:11:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60829 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2JBELs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 00:11:48 -0400
Date: Tue, 2 Oct 2012 14:11:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the xen-two tree with the arm tree
Message-Id: <20121002141141.827ca565a2722b72b1c2157e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Oct_2012_14_11_41_+1000_3WD_5/YnnZoeEFDo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Oct_2012_14_11_41_+1000_3WD_5/YnnZoeEFDo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

Today's linux-next merge of the xen-two tree got a conflict in
arch/arm/Kconfig between commit bd51e2f59558 ("ARM: 7506/1: allow for
ATAGS to be configured out when DT support is selected") from the arm
tree and commit eff8d6447d5f ("xen/arm: introduce CONFIG_XEN on ARM")
from the xen-two tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig
index 7df4acc,3361466..0000000
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@@ -1897,6 -1891,22 +1897,16 @@@ config CC_STACKPROTECTO
  	  neutralized via a kernel panic.
  	  This feature requires gcc version 4.2 or above.
 =20
 -config DEPRECATED_PARAM_STRUCT
 -	bool "Provide old way to pass kernel parameters"
 -	help
 -	  This was deprecated in 2001 and announced to live on for 5 years.
 -	  Some old boot loaders still use this way.
 -
+ config XEN_DOM0
+ 	def_bool y
+ 	depends on XEN
+=20
+ config XEN
+ 	bool "Xen guest support on ARM (EXPERIMENTAL)"
+ 	depends on EXPERIMENTAL && ARM && OF
+ 	help
+ 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
+=20
  endmenu
 =20
  menu "Boot options"

--Signature=_Tue__2_Oct_2012_14_11_41_+1000_3WD_5/YnnZoeEFDo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQaml9AAoJEECxmPOUX5FEks4P/RiH1SchJrbarjnNB1mfpA1D
0rvPENeuUCOMp5Dad9rCnUvlb2QJQRlxmpfVuqG59+foc5IH4JUGbNfJAUDOFWF/
ekBOklWJ+BheU6hsjrcJwP8p1F4AgFr7GuC3kEpSCcKoZ3CSI3qp+Ro0FFCzzxDv
Z+L30yzvXC40KE9j3DCruM/8fu/33ncxh/ccwAAIAMjEXPtSbc4X8P2ySF9NyEvY
y6p/JsqzD9dkCq9/w/7vd5bWYOz6ZeMvTy/ecrtDkcVFNySOWWi3ngnER9vWxkvc
VtLawvT/XUJsbP5qCASV1xnqojUJOFcZj1hNDzG3T5s9P9CYYLVeu36wmv+e88eC
P2KRFW7S1nAN+N1/dkKTNMkZAuwzuRySg5TRysWjtgSUVdjjqNaUjbcYa36e5vem
1mZehD8ESqCAn0dVJDVYekl3c00PcYg7i/bGe92FsJ480zU3qLUY0YDMoWiqkGOj
B+ayAB2fIxgkVI0yUoTErlYHWJVYSDlrZv//ZUYKdizZR6gtC7DZI4Gp0aFJQGD7
SwO6ttHM1b32VoRYi6DzlVfNhND1+6Ofh/ouSFOy32K5b3OsUEtQK4HNZ9RTky1d
lfgGPHL4GzGc3xAZqp8nNxIEI9ZLu2+ua2lci3O1/XEs3b1U5xiyPTFOqRXKqZkq
jWC7Z+7EpgeNa3vy+Ziv
=EbJa
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Oct_2012_14_11_41_+1000_3WD_5/YnnZoeEFDo--
