Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961Ab2FABAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 21:00:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40453 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929Ab2FABAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 21:00:35 -0400
Message-ID: <4FC81424.9050502@gmail.com>
Date: Fri, 01 Jun 2012 03:00:20 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Christoph Hellwig <hch@tuxera.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] Support HFS+ not filling its device completely
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigDE98A7D9E91B2FABAEC42C03"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDE98A7D9E91B2FABAEC42C03
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello, all. My HFS+ previously was on slightly smaller partition
and was subsequently dd'ed to its current location. Mac OS X doesn't
mind and I don't mind losing a little space. However Linux fails to
locate second superblock and hence to mount it. This patch uses
the size field from the first superblock to locate the second.


Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
---
 fs/hfsplus/wrapper.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 7daf4b8..a7e1268 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -206,6 +206,9 @@ reread:
 		set_bit(HFSPLUS_SB_HFSX, &sbi->flags);
 		/*FALLTHRU*/
 	case cpu_to_be16(HFSPLUS_VOLHEAD_SIG):
+		part_size =3D (((u64) be32_to_cpu(sbi->s_vhdr->blocksize)
+			      * (u64) be32_to_cpu(sbi->s_vhdr->total_blocks))
+			     >> HFSPLUS_SECTOR_SHIFT);
 		break;
 	case cpu_to_be16(HFSP_WRAP_MAGIC):
 		if (!hfsplus_read_mdb(sbi->s_vhdr, &wd))
--=20
1.7.10

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enigDE98A7D9E91B2FABAEC42C03
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk/IFC8ACgkQNak7dOguQgn9DAEAl6lii0aSySdu5Ja0DWjEANWi
a2MYXBAaAcLtxlJlJCwA/1id0XINOLHFoQJAKxfZy94Pic5c7aWTyqTp5HPWr2J+
=AALT
-----END PGP SIGNATURE-----

--------------enigDE98A7D9E91B2FABAEC42C03--
