Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966565Ab2EPJbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 05:31:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49902 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2EPJbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 05:31:03 -0400
Date: Wed, 16 May 2012 19:30:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: linux-next: manual merge of the akpm with the  tree
Message-Id: <20120516193052.4af4ee85feb4a36b936b74df@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_May_2012_19_30_52_+1000_FikpuOwyLkKE.G8+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_May_2012_19_30_52_+1000_FikpuOwyLkKE.G8+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in kernel/exit.c
between commit a29c33f4e506 ("userns: Convert setting and getting uid and
gid system calls to use kuid and kgid") from the uerns tree and commit
"cred: remove task_is_dead() from __task_cred() validation" from the akpm
tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/exit.c
index 112f703,7c293e6..0000000
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@@ -1218,7 -1218,7 +1218,7 @@@ static int wait_task_zombie(struct wait
  	unsigned long state;
  	int retval, status, traced;
  	pid_t pid =3D task_pid_vnr(p);
- 	uid_t uid =3D from_kuid_munged(current_user_ns(), __task_cred(p)->uid);
 -	uid_t uid =3D task_uid(p);
++	uid_t uid =3D from_kuid_munged(current_user_ns(), task_uid(p));
  	struct siginfo __user *infop;
 =20
  	if (!likely(wo->wo_flags & WEXITED))

--Signature=_Wed__16_May_2012_19_30_52_+1000_FikpuOwyLkKE.G8+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPs3PMAAoJEECxmPOUX5FEC8MP/31oSugRyO2T6Irp6NlIXgDo
6+mULukdnjP0uhemWpOcq+O2kycWPBMcTOLbf/T0TaiOS41dsMsgfDyQc1CNF/6n
p8bvIuc48TAreE0AODNBLjalWbcKI1KkFmHxPkdOuGt2Bcgqog474MVbG6IrHpQe
Mqyny8egxZYxc+JUACbMV8GNLAN8e8XGUL5QzAFFcu1GNhlAJvPK4h1hliBf+61U
nCxtzeX2x8XN6hsWy0NFJ3hzPaYiOGJUGjmk0LOmy5eXhQwDb/MBD6sID7IFYWkq
uS+4QjBPJRlyOYea1cOFD2cLpEtoprw4smGPY+XgbF5Za5fxz8SgQiTWuRjyYQHX
7yP0BOhfh8rDwfYWWdlogWX5Wa4fUlZCPz8km9xSHDf22ZoH2SUmZpVDrefLx10u
NpeIxXURka3eqBvdY6Gt5LOWRkMxRn1qGVEBlD8925lieqe2wSpZGeOaoeVpNKQR
snC/wWCA/qrVzRTJys5hAsWlpB25HXwTx3sGYwCR1miHJTrDHmYSTH+mr7k0C26c
bqGjulFxpbilRrHEjB/kpIGNpcUFvJGDVg80MOUnH9WmlEXBJuJrHnDpS3g8Mh2i
uK7rQ+8xPBtxFF4gcF341WaEd3LjDjca5eXa+NCqdBYCXem+nU73eYvlk47hXYhL
J46oY8TgDagbwgTv7hLV
=F3r1
-----END PGP SIGNATURE-----

--Signature=_Wed__16_May_2012_19_30_52_+1000_FikpuOwyLkKE.G8+--
