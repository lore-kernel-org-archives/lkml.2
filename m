Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967017Ab2EOXIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 19:08:02 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63949 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966054Ab2EOXIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 19:08:00 -0400
Message-ID: <4FB2E1C7.1070700@gmail.com>
Date: Wed, 16 May 2012 01:07:51 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] Support non-BMP characters on Joliet.
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig33216AEBACD8761FBCC8E666"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig33216AEBACD8761FBCC8E666
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
---
 fs/isofs/joliet.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/isofs/joliet.c b/fs/isofs/joliet.c
index a048de8..d85e842 100644
--- a/fs/isofs/joliet.c
+++ b/fs/isofs/joliet.c
@@ -16,22 +16,35 @@
 static int
 uni16_to_x8(unsigned char *ascii, __be16 *uni, int len, struct nls_table=
 *nls)
 {
-	__be16 *ip, ch;
+	__be16 *ip, ch[2];
 	unsigned char *op;
=20
 	ip =3D uni;
 	op =3D ascii;
=20
-	while ((ch =3D get_unaligned(ip)) && len) {
+	ch[1] =3D get_unaligned(ip);
+
+	while (len) {
 		int llen;
-		llen =3D nls->uni2char(be16_to_cpu(ch), op, NLS_MAX_CHARSET_SIZE);
+		int s;
+		unicode_t uni;
+		ch[0] =3D ch[1];
+		if (len > 1)
+			ch[1] =3D get_unaligned(ip + 1);
+		s =3D utf16s_to_unicode(ch, len > 1 ? 2 : 1, UTF16_BIG_ENDIAN,
+				      &uni);
+		if (s <=3D 0) {
+			llen =3D -1;
+			s =3D 1;
+		} else
+			llen =3D nls->uni2char(uni, op, NLS_MAX_CHARSET_SIZE);
 		if (llen > 0)
 			op +=3D llen;
 		else
 			*op++ =3D '?';
-		ip++;
+		ip +=3D s;
=20
-		len--;
+		len -=3D s;
 	}
 	*op =3D 0;
 	return (op - ascii);
--=20
1.7.10

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enig33216AEBACD8761FBCC8E666
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+y4ccACgkQNak7dOguQgmVBAD+In9Tg1IaXDjSjz1DXSl76oRj
LLMPaRpIKuTzQsvzLsYBAI4iLpkrLxeHBtghyNZ2WU2SIgqy9U9X0GfOLxqu49zC
=W/or
-----END PGP SIGNATURE-----

--------------enig33216AEBACD8761FBCC8E666--
