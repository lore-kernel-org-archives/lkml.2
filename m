Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab2EMNs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 09:48:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45023 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab2EMNs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 09:48:58 -0400
Message-ID: <4FAFBBC7.9020101@gmail.com>
Date: Sun, 13 May 2012 15:48:55 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] Fix minixfs size check
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig303EAED182F7B4BC11AD2DE7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig303EAED182F7B4BC11AD2DE7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

minixfs file size check is buggy and it doesn't allow creating a block wh=
ich
can't be fully filled

Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>

diff --git a/fs/minix/itree_v1.c b/fs/minix/itree_v1.c
index 282e15a..4f8f8b2 100644
--- a/fs/minix/itree_v1.c
+++ b/fs/minix/itree_v1.c
@@ -29,7 +29,8 @@ static int block_to_path(struct inode * inode, long blo=
ck, int offsets[DEPTH])
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
 			block, bdevname(inode->i_sb->s_bdev, b));
-	} else if (block >=3D (minix_sb(inode->i_sb)->s_max_size/BLOCK_SIZE)) {=

+	} else if ((u64) block * (u64) BLOCK_SIZE
+		   >=3D minix_sb(inode->i_sb)->s_max_size) {
 		if (printk_ratelimit())
 			printk("MINIX-fs: block_to_path: "
 			       "block %ld too big on dev %s\n",
diff --git a/fs/minix/itree_v2.c b/fs/minix/itree_v2.c
index 13487ad..4a9a19d 100644
--- a/fs/minix/itree_v2.c
+++ b/fs/minix/itree_v2.c
@@ -32,7 +32,8 @@ static int block_to_path(struct inode * inode, long blo=
ck, int offsets[DEPTH])
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
 			block, bdevname(sb->s_bdev, b));
-	} else if (block >=3D (minix_sb(inode->i_sb)->s_max_size/sb->s_blocksiz=
e)) {
+	} else if ((u64) block * (u64) sb->s_blocksize
+		   >=3D minix_sb(inode->i_sb)->s_max_size) {
 		if (printk_ratelimit())
 			printk("MINIX-fs: block_to_path: "
 			       "block %ld too big on dev %s\n",


--------------enig303EAED182F7B4BC11AD2DE7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+vu8cACgkQNak7dOguQgm6mAD9HNDWjEbqZnv4UYblP1ZhX+iX
i3A1vNE8DYQ9NxSFnhwA/jEGGoS7fJlueezZEjc3tXa+gofYIdYD6ax9oRlN6ke4
=0jTV
-----END PGP SIGNATURE-----

--------------enig303EAED182F7B4BC11AD2DE7--
