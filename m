Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2IXNpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:45:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38667 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab2IXNpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:45:15 -0400
Date: Mon, 24 Sep 2012 23:45:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the akpm tree with the  tree
Message-Id: <20120924234514.c4a2c71425eab483716ded85@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_23_45_14_+1000_OM7FqkdmMLSxvTyd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_23_45_14_+1000_OM7FqkdmMLSxvTyd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/proc/base.c between commit c8506285ded8 ("procfs: Move /proc/pid/fd
[info] handling code to fd.[ch]") from the vfs tree and commit
"coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixe=
s"
from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 863b8c7..cceaab0 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -103,7 +103,7 @@ static inline int task_dumpable(struct task_struct *tas=
k)
 	if (mm)
 		dumpable =3D get_dumpable(mm);
 	task_unlock(task);
-	if(dumpable =3D=3D SUID_DUMPABLE_ENABLED)
+	if (dumpable =3D=3D SUID_DUMPABLE_ENABLED)
 		return 1;
 	return 0;
 }

--Signature=_Mon__24_Sep_2012_23_45_14_+1000_OM7FqkdmMLSxvTyd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYGPqAAoJEECxmPOUX5FEhJEP+gI0ftum4kb8x2T9t3QC9afz
l9bwLU9q5R20vI/WstLbY6w0LhEsQtB/sv1dkvR6OluBvgFK/fcqWtM8yxfcAsZ9
4FSrwNT64sL+VXZEsq0b9ijyiZUpKb3TeW/ZG2EL9gKEKaZpJijvVGrCf4NrsVvn
uBX40ZE00alch40csss/EBxBS48c0aYXu5Hl2C+v/F/tEW/YCvsAfBZTnW5sjE8B
esh4oSHleQZy9x9dOpFW2WieXcwsNoFpAsE+yAwQwLvBOG7nP1a3AM2KJGQMr0s2
JrNPJ8rXaYo/i8sJNO0kjxOiO4dl57uaiYtD/1DwNvUcs90E+1M+QSy4kunwFiiv
RPAckjT88nJG+1nLxEN55zzEfs0/7/5XYpH9OKAHXCjMAUSEd68Uq+fx2U41Zuqr
O2DGVKd4vTQyKLtpr9L/HDhMYhJKGcr2R37PHsyTyDo1rFAVnhB9D0sL00VJi5vJ
A4DiUjQ2sc5YJ7AKVrJscMKwlC+MPFY4QximcJ/Mnvvb0XVYC/AR24JNL4G0aH3d
J9Wdfs3oSZUIBnPMpMa0cL3cEA3rVhbe+k1E4g56QPgk6kFHlkQKaaLEEI7lT1mt
tyramMgzwjHVMyqk7uRdmA6Am+VnIag+fQOZG8y3IUDDAS6Whq7LCxPC2MRTVEXV
j74K+IdfxqwYTpV8RFQI
=7isA
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_23_45_14_+1000_OM7FqkdmMLSxvTyd--
