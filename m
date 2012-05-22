Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab2EVHod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 03:44:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52693 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab2EVHob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 03:44:31 -0400
Date: Tue, 22 May 2012 17:44:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the userns tree with Linus' tree
Message-Id: <20120522174426.1cd39ec7841e7545bb340cdd@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_May_2012_17_44_26_+1000_7fMVAfz+rPOestkl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_May_2012_17_44_26_+1000_7fMVAfz+rPOestkl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in fs/stat.c
between commit a52dd971f947 ("vfs: de-crapify "cp_new_stat()" function")
from Linus' tree and commit a7c1938e22c0 ("userns: Convert stat to return
values mapped from kuids and kgids") from the userns tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/stat.c
index 0cef336,31acca5..0000000
--- a/fs/stat.c
+++ b/fs/stat.c
@@@ -224,9 -215,17 +224,9 @@@ static int cp_new_stat(struct kstat *st
  	tmp.st_nlink =3D stat->nlink;
  	if (tmp.st_nlink !=3D stat->nlink)
  		return -EOVERFLOW;
- 	SET_UID(tmp.st_uid, stat->uid);
- 	SET_GID(tmp.st_gid, stat->gid);
+ 	SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
+ 	SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
 -#if BITS_PER_LONG =3D=3D 32
 -	tmp.st_rdev =3D old_encode_dev(stat->rdev);
 -#else
 -	tmp.st_rdev =3D new_encode_dev(stat->rdev);
 -#endif
 -#if BITS_PER_LONG =3D=3D 32
 -	if (stat->size > MAX_NON_LFS)
 -		return -EOVERFLOW;
 -#endif=09
 +	tmp.st_rdev =3D encode_dev(stat->rdev);
  	tmp.st_size =3D stat->size;
  	tmp.st_atime =3D stat->atime.tv_sec;
  	tmp.st_mtime =3D stat->mtime.tv_sec;

--Signature=_Tue__22_May_2012_17_44_26_+1000_7fMVAfz+rPOestkl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPu0PaAAoJEECxmPOUX5FEq7IQAIbmJaKVKcMB8n3yTlVun6fk
7Dxh/69skF8J9oPHCMQNzy+4+QI8j8LcBrHq2rWGOUEXJnReohGMMV3WUvGlo+fr
5F9Bib/WddJT4+Yym+c99fVmMfGHQigPNCRYhZJMUf+2bZGd8Nb5uwaO/xZnXjzn
1VhOCd1djtaphdzCokhKwcXUkF62y5sm8Pqn5Nyzk/wm/Y5NzFuVr4VV+gxDAIQv
XCMp82vp/yAtJ2x9iJ5/8R69q3aWaFMgVlva2MNP+wqMLjl5CTA4cVWFAFkNPBMt
oNCX3e13XS2s8FZH7scxUM5tdgnglM6qnaRzMLBTzx6mWYltEbbDfHsdxGG7aXSI
84zMx5QcpUGlRHmUA5ABDUjAubhcwf5wqsUHCZ31qMrENLYyqogJfXe+03CMeJFZ
wudxagQc/t3sj6qATaME3V6CLiYJn3IUtZvKQ8DD79kbEea5W4NSxz7TyC++bGCL
otdDhNG7c0ken/qU4NLqsjLZb0kCQ03zHuz9zeAuW9vDE/HLcAG7MESzhoyg5crU
2zowKC+vCw/r0Cfd4Eiv7g3yMfMO8yOdEvtffhmDxa3+8yUNe7sZkt4gxw/GccNL
q6bN6TC7dsRaFKU9Y86SFsG/Xy9tFxtIxxm/GBT4JCTiXGLGYV/5YyCdwPPG8rhg
/QkySZr5z/mgkYytM35F
=Jqiu
-----END PGP SIGNATURE-----

--Signature=_Tue__22_May_2012_17_44_26_+1000_7fMVAfz+rPOestkl--
