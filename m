Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab2EIUO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:14:57 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50158 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab2EIUO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:14:56 -0400
Message-ID: <4FAACF55.5070809@gmail.com>
Date: Wed, 09 May 2012 22:11:01 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix minixfs block limit check
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigE19A38006A126D8B59881D05"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE19A38006A126D8B59881D05
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello, all. On minix2 and minix3 usually max_size is 7fffffff and the
check in question prohibits creation of last block spanning right before
7fffffff. Here is a fix:

--- fs/minix/itree_v2.c    2011-04-23 01:34:36.363725380 +0200
+++ /home/phcoder/projects/fs/minix/itree_v2.c    2012-05-09
21:47:52.335621065 +0200
@@ -32,7 +32,8 @@
     if (block < 0) {
         printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
             block, bdevname(sb->s_bdev, b));
-    } else if (block >=3D
(minix_sb(inode->i_sb)->s_max_size/sb->s_blocksize)) {
+    } else if ((u64) block * (u64) sb->s_blocksize
+           >=3D minix_sb(inode->i_sb)->s_max_size) {
         if (printk_ratelimit())
             printk("MINIX-fs: block_to_path: "

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko



--------------enigE19A38006A126D8B59881D05
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+q0DkACgkQNak7dOguQglhJwD/USv5OIeKQU3M5MN6WcMeKujL
Tk3pZh0RoJr6QPQK+FoA/iUbihhRRsl0vl9NF8gFlLCPLjArCqXzS5whQMhuZlL+
=hRAZ
-----END PGP SIGNATURE-----

--------------enigE19A38006A126D8B59881D05--
