Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab1KHBb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:31:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35575 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab1KHBak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:30:40 -0500
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=Wi6g_Sx0tScA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=63xn6-QBRweX3glTVUoA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=JKmKpb1nqUk1X8hPmYwA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111108013039.309728512@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Nov 2011 20:29:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Baron <jbaron@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 07/10] jump_label: jump_label_inc may return before the code is patched
References: <20111108012939.372220547@goodmis.org>
Content-Disposition: inline; filename=0007-jump_label-jump_label_inc-may-return-before-the-code.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Gleb Natapov <gleb@redhat.com>

If cpu A calls jump_label_inc() just after atomic_add_return() is
called by cpu B, atomic_inc_not_zero() will return value greater then
zero and jump_label_inc() will return to a caller before jump_label_update()
finishes its job on cpu B.

Link: http://lkml.kernel.org/r/20111018175551.GH17571@redhat.com

Cc: stable@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/jump_label.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index a8ce450..e6f1f24 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -66,8 +66,9 @@ void jump_label_inc(struct jump_label_key *key)
 		return;
=20
 	jump_label_lock();
-	if (atomic_add_return(1, &key->enabled) =3D=3D 1)
+	if (atomic_read(&key->enabled) =3D=3D 0)
 		jump_label_update(key, JUMP_LABEL_ENABLE);
+	atomic_inc(&key->enabled);
 	jump_label_unlock();
 }
=20
--=20
1.7.7



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOuIY/AAoJEIy3vGnGbaoAY3sP/2ae1YJRLA3knfUDiTuzn1w+
HButUlP6z0LhJVcDkanU2FRkpQV7bkL5/KWdzAxgvX4tuzPLIDlMVX5XDCNA3JNX
qBjmzsEqNIhGZay1GmgIK2XVJ9mzSS2c8u9aMuAvSXyGqB5NE/5wWF13eQZuId8r
SqFLOFRNWaYYRampG3uKdXm2fsRWMLrBMI6wGPUb37x0seY+MX0AbxjgAEhHjNO+
QL4eq7wSB1hZt/6MHg8GvZ5R+cX5VKgsry47zpVZBc+m6OmXnwmZxnPj43EepAwK
PdfnIhgAhv0ebM45hL742/XPfCYBulA8qVgVTQIEMwhnXIZKZG7lNeblsatJNE4y
4/3/pXkuEMYvsJPmyNmSB2ZdHLRpY9BWo3fIf/3wKoaYhzd9cQQ7JvVb9G1LNKfl
wgwe5D09PbvDiklRj0zcKOk4TcfC5BCGe+L6qB7XZ/X8rl4X83jb85KFD0yooCXP
szRaeXpa5iRCEawiWFO8q1KJ3xOQbNyKAwPtOglV0vNALgaIBzEsaAw2ZlmDrsuB
e+ZGbgC4s6JYDWRbv7OP9Hnx44GzSrM2VlSnhJfmNTkKWKbfjH8Dwpm4oYHUZmKS
Ja9fZ8Y0r/mizDj+YP4CQOdHcnqpS3WiTnUHVrHSRayOSrwF9ZJ9iY8bVTrdgncC
7mB2Qi9tg7w/oIr+g/ks
=pNbI
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
