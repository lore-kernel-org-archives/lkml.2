Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab1KGUSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:18:48 -0500
Received: from www17.your-server.de ([213.133.104.17]:59167 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab1KGUSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:18:46 -0500
Message-ID: <1320697117.1396.4.camel@localhost.localdomain>
Subject: [PATCH] nilfs2: unbreak compat ioctl
From: Thomas Meyer <thomas@m3y3r.de>
To: konishi.ryusuke@lab.ntt.co.jp,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 07 Nov 2011 21:18:37 +0100
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-DWVIevM0WrcR2vm9+1Ln"
X-Mailer: Evolution 3.2.1 (3.2.1-1.fc16) 
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DWVIevM0WrcR2vm9+1Ln
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I guess commit 828b1c50ae11e6dda68f8dfefe43b74c7182b157 incidentally broke
all other compat ioctls. make them work again.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---
 fs/nilfs2/ioctl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 41d6743..1773a98 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -842,8 +842,6 @@ long nilfs_compat_ioctl(struct file *filp, unsigned int=
 cmd, unsigned long arg)
 	case FS_IOC32_GETVERSION:
 		cmd =3D FS_IOC_GETVERSION;
 		break;
-	default:
-		return -ENOIOCTLCMD;
 	}
 	return nilfs_ioctl(filp, cmd, (unsigned long)compat_ptr(arg));
 }
--=20
1.7.7


--=-DWVIevM0WrcR2vm9+1Ln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJOuD0eAAoJEK2Y/UtDbsHsnPEH/iXeosVRJLdXfTZVCeLxZxUd
tRb7/Ic2Gx9dVV8Iltk1vkvUXdcY7b+a5Mh+efsyKi7pKB0WuDiju9KCZqTlfuDM
2XnsRGrElH8CEApYBXnofXApEW9i/l15cfsdJL5/Tl6+8AqY6L20qt3M2IHckWXh
EkBb2NLjqaYGzNNubgkeedSYXuRXnKOsHhRskivIQHjXUEQUEk3dOiHAhH3+Ja8s
gZ6uDyZk58ltbti9vPIm2Vlf/Ej6yQ2bjUa/4BJtMzdpSTxqm8WOK/NkP9eRvSDx
I8Fnn8qPtqYh5/IRlXDdpXxFpXrWSWJXZbDQBs6gIWvrrQQP+9U5+HGdWd6p0sU=
=Wjfw
-----END PGP SIGNATURE-----

--=-DWVIevM0WrcR2vm9+1Ln--

