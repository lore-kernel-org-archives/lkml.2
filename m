Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1C1BA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 21:00:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41558 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab1C1BAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 21:00:25 -0400
Date: Mon, 28 Mar 2011 12:00:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Tao Ma <boyu.mt@taobao.com>
Subject: linux-next: manual merge of the ocfs2 tree with Linus' tree
Message-Id: <20110328120015.4e913a4b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Mar_2011_12_00_15_+1100_hq/HJWl=DY7=s2E1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Mar_2011_12_00_15_+1100_hq/HJWl=DY7=s2E1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Joel,

Today's linux-next merge of the ocfs2 tree got a conflict in
fs/ocfs2/super.c between commit 316873c958ee ("ocfs2: use system_wq
instead of ocfs2_quota_wq") from Linus' tree and commit ef6b689b63b9
("ocfs2: Remove ENTRY from masklog") from the ocfs2 tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ocfs2/super.c
index 236ed1b,0e40839..0000000
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@@ -1662,12 -1654,12 +1650,11 @@@ static int __init ocfs2_init(void
  	status =3D register_quota_format(&ocfs2_quota_format);
  leave:
  	if (status < 0) {
 -		ocfs2_quota_shutdown();
  		ocfs2_free_mem_caches();
  		exit_ocfs2_uptodate_cache();
+ 		mlog_errno(status);
  	}
 =20
- 	mlog_exit(status);
-=20
  	if (status >=3D 0) {
  		return register_filesystem(&ocfs2_fs_type);
  	} else
@@@ -1676,8 -1668,8 +1663,6 @@@
 =20
  static void __exit ocfs2_exit(void)
  {
- 	mlog_entry_void();
-=20
 -	ocfs2_quota_shutdown();
 -
  	if (ocfs2_wq) {
  		flush_workqueue(ocfs2_wq);
  		destroy_workqueue(ocfs2_wq);

--Signature=_Mon__28_Mar_2011_12_00_15_+1100_hq/HJWl=DY7=s2E1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNj92fAAoJEDMEi1NhKgbs18wH/1EzOckm3+kpOPBWtntCPQ3j
t8KY9UM982PQWtiZOd7TYqMM1kOwUKDHA8oMKN0WL+uLD/Womm0xcVa4eN47xr1X
CeY/fCjT/xMxXIzsNR7Es602w74OcaPk5MkANzrttsiqxvmU9o0/mdXVelHMoGJM
nFbG318R2jWxUKhh2WhT4QYun036QbuT3w82kQA/8UD42lomSG3FT6//bDRALIVL
HteYISiQ42lDDJkuwvmcarNXyTARzFcLnoYVQjIBn5zYaw83QJmgtUushKMh4Xc2
93zhkatggQ9Hynm4EuwIZsY+SVY74EFHncsvxKMm/JCP3GybFAQ49CXYsz71cBE=
=xUId
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Mar_2011_12_00_15_+1100_hq/HJWl=DY7=s2E1--
