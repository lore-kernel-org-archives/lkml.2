Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1JKIFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 04:05:48 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:51684 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab1JKIFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 04:05:47 -0400
Date: Tue, 11 Oct 2011 19:05:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the hwspinlock tree with the arm-soc
 tree
Message-Id: <20111011190534.b3663a8392cc0905b6c4a466@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Oct_2011_19_05_34_+1100_VrshzAzwHrVwWUMR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Oct_2011_19_05_34_+1100_VrshzAzwHrVwWUMR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ohad,

Today's linux-next merge of the hwspinlock tree got a conflict in
arch/arm/mach-omap2/hwspinlock.c between commit 3528c58eb9e8 ("OMAP:
omap_device: when building return platform_device instead of
omap_device") from the arm-soc tree and commit c3c1250e93a7
("hwspinlock/core/omap: fix id issues on multiple hwspinlock devices")
from the hwspinlock tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/hwspinlock.c
index 0b3ae9d,eb7e509..0000000
--- a/arch/arm/mach-omap2/hwspinlock.c
+++ b/arch/arm/mach-omap2/hwspinlock.c
@@@ -48,13 -53,14 +53,14 @@@ int __init hwspinlocks_init(void
  	if (oh =3D=3D NULL)
  		return -EINVAL;
 =20
- 	pdev =3D omap_device_build(dev_name, 0, oh, NULL, 0,
 -	od =3D omap_device_build(dev_name, 0, oh, &omap_hwspinlock_pdata,
++	pdev =3D omap_device_build(dev_name, 0, oh, &omap_hwspinlock_pdata,
+ 				sizeof(struct hwspinlock_pdata),
  				omap_spinlock_latency,
  				ARRAY_SIZE(omap_spinlock_latency), false);
 -	if (IS_ERR(od)) {
 +	if (IS_ERR(pdev)) {
  		pr_err("Can't build omap_device for %s:%s\n", dev_name,
  								oh_name);
 -		retval =3D PTR_ERR(od);
 +		retval =3D PTR_ERR(pdev);
  	}
 =20
  	return retval;

--Signature=_Tue__11_Oct_2011_19_05_34_+1100_VrshzAzwHrVwWUMR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOk/jOAAoJEECxmPOUX5FEq7kP/0UWq2OmbadCo9unZG9s867W
cdnqHiPuyDzwc5L5qeMH+LWG0QWRx6SiunuLWlYfXkhUXK9N1UBJvUF+KrnPuEYp
UJaGcB222HndwhBFe3zrihg6dRzMCWmruqei9lMpSnaxQlEJaBFrhlp1YM7rTIEh
N8jrlnfy9X+MOR2Iz1VhLsMNs6iou5IAUxkylyqbYWD7NsfpPk3lr+hKotEx7472
6JzyxOSkHDyj84QMfw97oi48pQEzg+ao25Du9ezUWV/WmY2IMaxdjzYfwqd7v62l
sRT+Fowv04H+5j2uvr8XVPhdbmXFgLoyZQXS0zJndrA1zkdmYHayj2D7J/dxWJw3
SliuD3DFiD4UL6vfstonReiuI/iT5p9L+i6oXOeAJc62bpFJRQlnUGk6MxNsCUpV
pfmeYmBOMLFn8LXX7ln9JeQkFU4qfXYv8RuIuUAMr5cRq6y0COy6V9Zmh4j+wzD2
o+BbXTVvw0HBcipmdhfuYlXtD7w0YqbRwKuU5h3dKVZ5Lji/ykXHTCdPs9RT6Wu0
yFWnJkhHPIQv2EuYKpeZtOJlVnIfSaChzFgz33cs6CWik4L6reY2/wZR/gMcTicX
0LCvKtBfMbs/OMO4FXE2AqEPwBofnuqYAC45Wcbl3ulfZHJj1zK1F1I7sH+WwZ4q
pHQnKN5lNDC4PIbr2Jvk
=d1v6
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Oct_2011_19_05_34_+1100_VrshzAzwHrVwWUMR--
