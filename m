Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab2IXNlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:41:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58530 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2IXNlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:41:08 -0400
Date: Mon, 24 Sep 2012 23:40:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>
Subject: linux-next: manual merge of the akpm tree with the vfs tree
Message-Id: <20120924234059.ee7e91a319758f0c6ef1b068@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_23_40_59_+1000_8zCqVWD1pU_CWCeP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_23_40_59_+1000_8zCqVWD1pU_CWCeP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/proc/base.c between commit c8506285ded8 ("procfs: Move /proc/pid/fd
[info] handling code to fd.[ch]") from the vfs tree and commit "coredump:
use SUID_DUMPABLE_ENABLED rather than hardcoded 1" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 67925a7..863b8c7 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -103,7 +103,7 @@ static inline int task_dumpable(struct task_struct *tas=
k)
 	if (mm)
 		dumpable =3D get_dumpable(mm);
 	task_unlock(task);
-	if(dumpable =3D=3D 1)
+	if(dumpable =3D=3D SUID_DUMPABLE_ENABLED)
 		return 1;
 	return 0;
 }

--Signature=_Mon__24_Sep_2012_23_40_59_+1000_8zCqVWD1pU_CWCeP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYGLrAAoJEECxmPOUX5FEkTkQAJaKhulksyJ5ayXcvf2BGEju
8kJuvKBW2rfWrM/HAyvSAFwq4ierpwi0lLNzNAxbcj/WB9esliUL9V9J4IXq3d21
QBaeUAYJfA5YZXkk9zfbUUzf9gf0DB+QIXT865oZcypqVechqH2HtUEs8m7iU0jn
OWUTowJEPtNcxGq7pBI/NBWZhafGTKnZu2pI3V3JYWA+h1iXpv+U5FspljJ48h/K
ShH6dS/gBLpLI15zJXQCVeX7O0PPYEQUr31h0iRujvy7Fd1UoWc1A7lnRqoStXoM
V0ddJykp3mJbEfV162APMRTKMN7HyYBANBbeEJ/F/SJfotIeIreiFk1xy5pCBxOe
aRDIwIV3XA6dDWf4kN9Oac2OdPTDi1bGlJcAxOurofoRfvUrC7ZO+ovE4ANrfEmL
Epg4iWpVifIve2FATfQPDaYfodnwJDqgUKfMV+JW1nLBJmZZ8Sv8h7y2gCGMMQlU
w3bzMr5n34fwMVbOnvz7PAj6FYYS0j5RHvzU0DP+7AjrgbQtV6etXc9otQc3Q7I3
dt8qPAOZ1WmYbsEBLkPvomi5+uhOCqCHdorKC8zfsBALL8d9t6Y3Pqdmtlv10tlc
KjGxPndLLYkut1J10UZgekFBYmf+Mv5gDaE7HRDgIW2nPNJB/UJuiJChID26HdBe
ff8lPYQttdG11q+Itj2s
=yJVu
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_23_40_59_+1000_8zCqVWD1pU_CWCeP--
