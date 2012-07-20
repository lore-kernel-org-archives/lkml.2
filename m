Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab2GTHTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 03:19:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:32757 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab2GTHTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 03:19:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="195428975"
Message-ID: <1342769037.4060.18.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBIFS fix for 3.6-rc8
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Iwo <Iwo.Mergler@netcomm.com.au>
Date: Fri, 20 Jul 2012 10:23:57 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-8prcJWjIm0AkokZVhF1V"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8prcJWjIm0AkokZVhF1V
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The following changes since commit bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a=
:

  Linux 3.5-rc6 (2012-07-07 17:23:56 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.5-rc8

for you to fetch changes up to c6727932cfdb13501108b16c38463c09d5ec7a74:

  UBIFS: fix a bug in empty space fix-up (2012-07-20 10:13:27 +0300)

----------------------------------------------------------------
Fix a bug in UBIFS free space fix-up reported already twice recently:

http://lists.infradead.org/pipermail/linux-mtd/2012-May/041408.html
http://lists.infradead.org/pipermail/linux-mtd/2012-June/042422.html

and we finally have the fix. I am quite confident the fix is correct
because I could reproduce the problem with nandsim and verify the
fix. It was also verified by Iwo (the reporter).

I am also confident that this is OK to merge the fix so late because
this patch affects only the fixup functionality, which is not used by
most users.

----------------------------------------------------------------
Artem Bityutskiy (1):
      UBIFS: fix a bug in empty space fix-up

 fs/ubifs/sb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
index ef3d1ba..15e2fc5 100644
--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
@@ -718,8 +718,12 @@ static int fixup_free_space(struct ubifs_info *c)
                lnum =3D ubifs_next_log_lnum(c, lnum);
        }
=20
-       /* Fixup the current log head */
-       err =3D fixup_leb(c, c->lhead_lnum, c->lhead_offs);
+       /*
+        * Fixup the log head which contains the only a CS node at the
+        * beginning.
+        */
+       err =3D fixup_leb(c, c->lhead_lnum,
+                       ALIGN(UBIFS_CS_NODE_SZ, c->min_io_size));
        if (err)
                goto out;

--=20
Best Regards,
Artem Bityutskiy

--=-8prcJWjIm0AkokZVhF1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQCQeNAAoJECmIfjd9wqK0Y0QP/1Yzb/8SeOpbL+a50CisQuIc
Xi7nDNYB899krQNTwsZbVyvaRBBU0+lvOYSmy+gvith4AU7QrTMsccDuX8/3K+jJ
L+1IKNLj1touKo7QhcWeMQu+raYkteWOuaCoh33NnrsPkRYV41ITjHnnPnhsqICB
jnYOrXJXgfWOkiZ360PY0q4+RWv9Y/vohu1K8cKZCXKY1yNCYtBO7kUHSPiPlcCy
shO7ySqunimNoZi4Smvr5TtVRiwjUnwqZwTN/P7y9a3GF/YNZ5deQVxGf3iIrBfp
GMk9lBfouhWnbqsEA99X+ChllvxD+6+XPIIF8h39o21Y2T7UD+ihz61ud0Rdeyxf
r25yGDd5k1BHSB5kAvFVeZn6uY1PTLWDnsyIQoSLx18s1QLV5sYKw556jYGTEKBj
1yh0Qy2M7h/7RbfdykSsbSPD0njo0Mgt14aDG8/lWw1Pmp92E7nNF4JPwP4E4DEw
SR+wjGMLjH+qg4S5b0rEcRkWHMIdgODVJfO8emfuNzvh8ZMn9XjcRMNFAWUcsv7v
5B49amDkkVqJ2hj5mHcBv5pHteJYpLu//zpbvhmUkYG7nkFX2KauX01vOKVwJ9G4
A1qTZy6IqVJeDAp9spwjAbgQYeAXlbapA/GRfwzwRBZ/DFevgA0dNwiCdoVW1u+e
i+MRi7RcFfSKdit5vTqN
=m+7r
-----END PGP SIGNATURE-----

--=-8prcJWjIm0AkokZVhF1V--

