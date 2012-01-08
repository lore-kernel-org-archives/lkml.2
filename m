Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab2AHXxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 18:53:25 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:40209 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2AHXxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 18:53:23 -0500
Date: Mon, 9 Jan 2012 10:53:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: linux-next: manual merge of the arm tree with Linus tree
Message-Id: <20120109105320.4f1b907fe943d5b8a34718c3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Jan_2012_10_53_20_+1100_b1zWg34wDOauSWjL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Jan_2012_10_53_20_+1100_b1zWg34wDOauSWjL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Today's linux-next merge of the arm tree got a conflict in
arch/arm/mach-s5pc100/common.c between commit 7affca3537d7 ("Merge branch
'driver-core-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core") from
Linus' tree and commit 109ac862f737 ("ARM: mach-s5pc100: use standard
arch_idle()") from the arm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s5pc100/common.c
index c909573,4659fb9..0000000
--- a/arch/arm/mach-s5pc100/common.c
+++ b/arch/arm/mach-s5pc100/common.c
@@@ -210,11 -201,7 +202,7 @@@ core_initcall(s5pc100_core_init)
  int __init s5pc100_init(void)
  {
  	printk(KERN_INFO "S5PC100: Initializing architecture\n");
-=20
- 	/* set idle function */
- 	pm_idle =3D s5pc100_idle;
-=20
 -	return sysdev_register(&s5pc100_sysdev);
 +	return device_register(&s5pc100_dev);
  }
 =20
  /* uart registration process */

--Signature=_Mon__9_Jan_2012_10_53_20_+1100_b1zWg34wDOauSWjL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPCixwAAoJEECxmPOUX5FE0NcP/RJWUXzfMkTaXQt5BPyTGKjK
5Kaaci6qoVB2ccMR98NT1GEis0nO/mJEzxde1unVrrj4mTZp9few7E4BiTRiDYcp
yHanhSv7nQTPGvcCH54qo7GBWr6tdt+xdTgp4IFM805FxQC08QWtam0uyhLnFXPC
7SXy/F5NBdB6w228a4KYU+cyPwZXbs8ji/8moWabmyKHDLNBM/Pl0vnUNLS/3lxI
IoY6c4iIc0VeGyowhYiNuP4BREadA2IIdzUgzaEoWu65bDBwXsk44X/MegBq4YNC
vPP36sBGLUcSj8QsWx0BCi07hH/JrPIfE7z0amKy9jl/JicmHK1Lv2lO0NinPmAa
U0mgvoxjFccX8+kMQSuVLgggfCghJ/eQcikahRmQblkJQ9FsDz1eaJWWYmjxObDo
3Tp0fCkwjHgsr0fFoCFF9VWMjbGEa/V0XcyjqqRp+l8sC69n/oty7Dpg+tguDY0a
1eY5OqIYCw0N2k1mer1jLDQ9ci11UVlBNsfJKpGxWJYIuCi9mwtTpWYLXi7Frf9e
Y1+Bw+iXU+xd70ERiXKCFpGIQoEKf5v1ufhNnPMdMlFgp3BSkzeR3SNhJ4bATcWW
HCGN5B4uvMgtveuU7BvjZliZNC3I9xWAevWE7pyRf70KMPnyTnKKdM5KBJ/k03hl
Ofga8IxvDvVQSOw8CoiW
=S6GG
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jan_2012_10_53_20_+1100_b1zWg34wDOauSWjL--
