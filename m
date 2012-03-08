Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab2CHWXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:23:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20608 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728Ab2CHWWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:22:07 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=SCo5D0GyyXcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=QNtm8q2oWb9G1ifyncoA:9 a=7pAfy_8kPYBJQdXbZHMA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=HuMK9PPWfTy16wOzPZQA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120308222203.176951592@goodmis.org>
User-Agent: quilt/0.50-1
Date: Thu, 08 Mar 2012 17:17:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH 7/7] x86/jump labels: Handle initialization of enabled nops
References: <20120308221730.807074710@goodmis.org>
Content-Disposition: inline; filename=0007-x86-jump-labels-Handle-initialization-of-enabled-nop.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When jump labels are initialized at boot up, they are compared
to the default_nop before switching to the ideal nop.

But if a jump label is enabled by default on start up, the
enabled code does not test against the default nop, only the
ideal nop. But as this jump label has not been converted to the
ideal nop, it fails the check, and will crash the box.

The enabled path needs to be aware of initialization too.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/jump_label.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 9bae2c9..c3ae7c3 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -66,7 +66,8 @@ static void __jump_label_transform(struct jump_entry *ent=
ry,
 			code.jump_short =3D 0xeb;
 			code.offset =3D entry->target - (entry->code + 2);
 			/* Check for overflow ? */
-		} else if (memcmp(ip, ideal_nop, 5) =3D=3D 0) {
+		} else if ((!init && memcmp(ip, ideal_nop, 5) =3D=3D 0) ||
+			   (init && memcmp(ip, default_nop, 5) =3D=3D 0)) {
 			size =3D JUMP_LABEL_NOP_SIZE;
 			code.jump =3D 0xe9;
 			code.offset =3D entry->target - (entry->code + size);
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPWTELAAoJEIy3vGnGbaoAIqYP/2PFaptUL6ZZo6NHi+cG/TGm
w4/2eJJKT5+5/IrUDOFYJTtbT/JnA7YkExsRz4lIgTRqneR+l66NKt3Mm887/qrX
6ZRd/J8asvFL9oEbuXW9x4dCafkI0SDZcQkFICKt0/HIgwi9yzbOdMYmdiRJhBn3
1xb82TEXk6lxLhRFjKAE4lNzrHMin9JF3zRF9JZ3GUoaaxDJd8SIzEm3a528n1i6
rjQahW4HjxzweBq/YZo5agWMDEp15/PtL2xvkibUTKrCpyHTJ7KPF2+tGnKnjLhE
jhqNgKx2mLHSuKyPAJOqGSLu5XlMFTHEGQ9xIsViJD1V1jdzAfAKm8AhNIVQd5Z4
Q937UTOqINe6EU2qmKmuRkHZnwdFlzRp1bMfjMPvHGzWyiylUOdmPFJXimE3H82y
ViZj6tH+m8vSaRUBcyuz1COOuUxewor4+eCIRb5eVmATbF0BUxL83umaCXMF7Lr6
O4YEYVtOYpZh113E677RAEE3MEQ3mjUJy77JQzP6sceBqKpFXVYbW1sW6IySAW+F
15YDDLul+tpCEV0BqW1rmyPQfheZL4IIvyuGuXx4bLhaqQ9UW5ElapPuOPxzmAPG
YZjEe5/fc2d9g/ivyResMO3J24GoxmNO4A81p/Iz62BCwcFActLerGdxno5Z/nlm
wrss4n1bA00F1gFx7gTe
=Bv0o
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
