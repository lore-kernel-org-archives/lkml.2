Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2EMNup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 09:50:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34178 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2EMNum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 09:50:42 -0400
Message-ID: <4FAFBC30.4040305@gmail.com>
Date: Sun, 13 May 2012 15:50:40 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Evgeniy Dushistov <dushistov@mail.ru>
Subject: [PATCH] Increase file size limit on FreeBSD UFS flavours
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig7E93A51934FA308DFFAEAD64"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7E93A51934FA308DFFAEAD64
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Increase the file size limit on FreeBSD UFS flavours.

Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index ac8e279..7e80a68 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -768,6 +768,7 @@ static int ufs_fill_super(struct super_block *sb, voi=
d *data, int silent)
 		uspi->s_fshift =3D 9;
 		uspi->s_sbsize =3D super_block_size =3D 1536;
 		uspi->s_sbbase =3D 0;
+		sb->s_maxbytes =3D MAX_LFS_FILESIZE;
 		flags |=3D UFS_DE_44BSD | UFS_UID_44BSD | UFS_ST_44BSD | UFS_CG_44BSD;=

 		break;
 	case UFS_MOUNT_UFSTYPE_UFS2:
@@ -778,6 +779,7 @@ static int ufs_fill_super(struct super_block *sb, voi=
d *data, int silent)
 		uspi->s_fshift =3D 9;
 		uspi->s_sbsize =3D super_block_size =3D 1536;
 		uspi->s_sbbase =3D  0;
+		sb->s_maxbytes =3D MAX_LFS_FILESIZE;
 		flags |=3D UFS_TYPE_UFS2 | UFS_DE_44BSD | UFS_UID_44BSD | UFS_ST_44BSD=
 | UFS_CG_44BSD;
 		break;
 	=09


--------------enig7E93A51934FA308DFFAEAD64
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+vvDAACgkQNak7dOguQgkhEQD/VuEzsampRwkbRjZ7BAU35LWt
BUJK4GAuzZwcjLOtUDYBAKgG+ELzOFQ2RTYmT4eSOSwqyrqxBvtIATJ4F6Bdv1dH
=O4X6
-----END PGP SIGNATURE-----

--------------enig7E93A51934FA308DFFAEAD64--
