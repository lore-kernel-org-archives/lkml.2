Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab2AHXx2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 18:53:28 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:56016 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab2AHXx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 18:53:27 -0500
Date: Mon, 9 Jan 2012 10:53:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: linux-next: manual merge of the arm tree with Linus' tree
Message-Id: <20120109105325.1216252da90a1ac00ab6003e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Jan_2012_10_53_25_+1100_zqvqQK0=iDlSoE_P"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Jan_2012_10_53_25_+1100_zqvqQK0=iDlSoE_P
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Today's linux-next merge of the arm tree got a conflict in
arch/arm/mach-exynos/common.c between commit 7affca3537d7 ("Merge branch
'driver-core-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core") from
Linus' tree and commit 53aa9b6a12dd ("ARM: mach-exynos: use standard
arch_idle()") from the arm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos/common.c
index b6ac6ee,8484019..0000000
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@@ -468,10 -459,7 +460,7 @@@ int __init exynos_init(void
  {
  	printk(KERN_INFO "EXYNOS: Initializing architecture\n");
 =20
- 	/* set idle function */
- 	pm_idle =3D exynos_idle;
-=20
 -	return sysdev_register(&exynos4_sysdev);
 +	return device_register(&exynos4_dev);
  }
 =20
  static struct s3c24xx_uart_clksrc exynos4_serial_clocks[] =3D {

--Signature=_Mon__9_Jan_2012_10_53_25_+1100_zqvqQK0=iDlSoE_P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPCix1AAoJEECxmPOUX5FEdBQP/RbQQhcFKZIl8IxDr9/7jNoZ
NYOl5oreoK1wRCj/g/Wc4rX86/s+eKa7vuY1DY4tqhKl5hpDmsOpWBsk4/9LkSaK
wAKYeG1GFLqz/MzMLqRR+/47rvMs/j7vlRMOtkHzlDwztpNG3spaiBOSfdeGWn0E
zyMYvB7uejVqvZI0tFTXR/T5Bzq79p3VXDXGCiVzCs/YCvLSCqwu9AL5ajIK2zDQ
wCE3tganYmtnM6aCkEOhBWYLe12G10T5FM27zzTDTG87ND7+EIjdSCiV08P4fSD4
vRrQnRq8XIqvaVohIDgIPHwCGAy1gbh7YqHilfDMFYi1CuDHjJ7rtWH/8LxcaK5f
algvFbDqEJWyhG9XJt5Z2CDYB4IWWkNX9aKQmmKz4moVQ359rX7BWGMXhOwccJf6
4ySe/txkxCUqcy7s0kmfzd9BNr8pRtoDsTtHArbSuJH4gzG9SWWnOTuc20DKp6Hy
qmhzAc0mhzBj5u3syN4EuwAXaKuLJ4085X2UBMakFnWYl5gsP8w59dWHvYKwD20H
gUokHrtl/72UrXX1g65VthwaXWUWEuUnW0q+npGqGlrw39Hz6GYahH6QXRcDODOT
mzebOg/nyxjf1VrlJdwMX4N4e46POYEwu9AJ5ICqhdC144j77lji/+rmQKteYtvd
akPhZoKEt8fzkgylQbSU
=910/
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jan_2012_10_53_25_+1100_zqvqQK0=iDlSoE_P--
