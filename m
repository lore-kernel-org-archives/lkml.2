Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2AHXxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 18:53:20 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:53974 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2AHXxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 18:53:19 -0500
Date: Mon, 9 Jan 2012 10:53:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: linux-next: manual merge of the arm tree with Linus' tree
Message-Id: <20120109105309.27dfc8afcc8db0e16e2021e0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Jan_2012_10_53_09_+1100_._UwIXbLi3gWfFHT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Jan_2012_10_53_09_+1100_._UwIXbLi3gWfFHT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Today's linux-next merge of the arm tree got a conflict in
arch/arm/mach-s5pv210/common.c between commit 7affca3537d7 ("Merge branch
'driver-core-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core") from
Linus' tree and commit 58329cb3171f ("ARM: mach-s5pv210: use standard
arch_idle()") from the arm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s5pv210/common.c
index 0ec3933,2622b8a..0000000
--- a/arch/arm/mach-s5pv210/common.c
+++ b/arch/arm/mach-s5pv210/common.c
@@@ -247,11 -238,7 +239,7 @@@ core_initcall(s5pv210_core_init)
  int __init s5pv210_init(void)
  {
  	printk(KERN_INFO "S5PV210: Initializing architecture\n");
-=20
- 	/* set idle function */
- 	pm_idle =3D s5pv210_idle;
-=20
 -	return sysdev_register(&s5pv210_sysdev);
 +	return device_register(&s5pv210_dev);
  }
 =20
  static struct s3c24xx_uart_clksrc s5pv210_serial_clocks[] =3D {

--Signature=_Mon__9_Jan_2012_10_53_09_+1100_._UwIXbLi3gWfFHT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPCixlAAoJEECxmPOUX5FEBfwP/0VCoQUaXoII0YvKT7Qe0BqY
gT0ZLmT5fvFwUzAG+cTkr/VLhuj1dfVhtlfI5Vzh1p0BL8zmblTiQ/UmRsQDn3JL
Qy8XEGdb6QJe/vmiGqJ2KV/YnsVV9R+OGvf5Pkl7pBxcra+V6Vt4hr6xZPAWoU1K
Pe6enUSt/WQfnjsizXgKMkLUrqoGv7Ed7jLTdVY7rMnIBu5An6c5YEam1oornL/S
0mPy6f+gRdE18silgti1KVXYk1O8QbhF8GkSxtDJyNG7B1ya7GA45kbYWntZYYb5
Qi9SlCesdXUT0/e7PXBxIBBXtGGbCl/5jhtwzPZ8f0B63tKnQTNQCdMaVZAGlKdG
YThMVGEnnjDp+btAAhZmnfjDJ/aG00JW6f2VgNWfiHYTYMayERVU+RzkUq6n05Kp
yedZudV+yFHQL2N9+NI3650lGoiPd6oOAOc/IQ8AQykjhbfgS8y1XmR3AaObjJPn
aj9udr0eOH2i9XdCM+r0X1Ud7PRcPpyf/m4UHz26PT9UBxwAYZGd/cZ+fQ6MxHe2
Ox231w+j1RbyzkG2ApAC9GQNKBizqNACT5+t6OGmCOmtHv+rB9L9LVFtFB7MQTQg
aogqKWDpTiYm4d1xyJ6Wg0MS0B4grnrMLafSDx6l6PiyoHPhXdj+fi90nHQYUo3+
GFFbIBMHlCjMp58kBXrD
=kyzL
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jan_2012_10_53_09_+1100_._UwIXbLi3gWfFHT--
