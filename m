Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab1KAG4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 02:56:13 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:54518 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1KAG4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 02:56:11 -0400
Date: Tue, 1 Nov 2011 17:56:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the hwspinlock tree with the arm-soc
 tree
Message-Id: <20111101175602.a1cc534d3819edcb8cd2cc77@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_17_56_02_+1100_tk9mJj.EB7Fwua70"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_17_56_02_+1100_tk9mJj.EB7Fwua70
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ohad,

Today's linux-next merge of the hwspinlock tree got a conflict in
arch/arm/mach-omap2/hwspinlock.c between commits 3528c58eb9e8 ("OMAP:
omap_device: when building return platform_device instead of
omap_device") and f718e2c034bf ("ARM: OMAP2+: devices: Remove all
omap_device_pm_latency structures") from the arm-soc tree and commit
c3c1250e93a7 ("hwspinlock/core/omap: fix id issues on multiple hwspinlock
devices") from the hwspinlock tree.

I fixed it up (see below) anc can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/hwspinlock.c
index 36e2109,eb7e509..0000000
--- a/arch/arm/mach-omap2/hwspinlock.c
+++ b/arch/arm/mach-omap2/hwspinlock.c
@@@ -23,6 -24,18 +24,10 @@@
  #include <plat/omap_hwmod.h>
  #include <plat/omap_device.h>
 =20
+ static struct hwspinlock_pdata omap_hwspinlock_pdata __initdata =3D {
+ 	.base_id =3D 0,
+ };
+=20
 -struct omap_device_pm_latency omap_spinlock_latency[] =3D {
 -	{
 -		.deactivate_func =3D omap_device_idle_hwmods,
 -		.activate_func   =3D omap_device_enable_hwmods,
 -		.flags =3D OMAP_DEVICE_LATENCY_AUTO_ADJUST,
 -	}
 -};
 -
  int __init hwspinlocks_init(void)
  {
  	int retval =3D 0;
@@@ -40,11 -53,14 +45,13 @@@
  	if (oh =3D=3D NULL)
  		return -EINVAL;
 =20
- 	pdev =3D omap_device_build(dev_name, 0, oh, NULL, 0, NULL, 0, false);
 -	od =3D omap_device_build(dev_name, 0, oh, &omap_hwspinlock_pdata,
++	pdev =3D omap_device_build(dev_name, 0, oh, &omap_hwspinlock_pdata,
+ 				sizeof(struct hwspinlock_pdata),
 -				omap_spinlock_latency,
 -				ARRAY_SIZE(omap_spinlock_latency), false);
 -	if (IS_ERR(od)) {
++				NULL, 0, false);
 +	if (IS_ERR(pdev)) {
  		pr_err("Can't build omap_device for %s:%s\n", dev_name,
  								oh_name);
 -		retval =3D PTR_ERR(od);
 +		retval =3D PTR_ERR(pdev);
  	}
 =20
  	return retval;

--Signature=_Tue__1_Nov_2011_17_56_02_+1100_tk9mJj.EB7Fwua70
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr5gCAAoJEECxmPOUX5FEA+oP/36eErN87KN1UMvS6OVB/iDW
EyuJg12+rzV2yUgL3SGIhiWwIkAOiKaUC7W7Wl03iLGuoCdnexAAewyrVfpTQ9UR
xjfebSIOSnKF4DE+HM7SdVGgSG+ItcqMJMD5UGv4E/PkiqyZ4rSdr8Ev6pqqZKO6
4tFUn2T8BEb6/iFkhY2bUX6/prgSN99Js892dX3+WkJ9KC0kdArf7MzUHx6uR+AG
LB0dqy2f0kx4oI7ryN4XSRiz9pLqE90V/rzq0zz7qCSQbPtvg32H4yGD4bUNHn9y
LnoPBOVWZmJ1vhPToM03IG5Tq0K6iw0ioD9Kh4h0uI8PhJfFCpudAOwy3zSvTdBX
rYPis3fZ0qB1bRtsjSHq4NBSplFiBiXIcBJLZILMrBhmBwT4cqJmEsmKtc/cfKMn
t0Fb1n2oHmO4vUEbzzseCJ5iolis/zWWArmLyW4njTnHR0Zq9sMoIOY5OuvO38BF
W7bQBk4Ow92qKzEq2aRkb2HiNeHd9fx+QhGhOV9SZ1M/12YVSz/4WlwTevYRKfqx
qYKcA6ZRISUIdHBR5nLnHWhYmziaE/L5RbvgbKL6QqVPWRxBgR/e3vNogbefFCMM
Bgf5zbfU4fVn8Pg0l3gA6Bv8AohYxlP9FomA7ykphkHnesfuQktBfpx05DKRmTZc
/SqEeXLAdPnAUZNUeIDL
=P0T1
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_17_56_02_+1100_tk9mJj.EB7Fwua70--
