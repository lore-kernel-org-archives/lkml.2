Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2IXHH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 03:07:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48673 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab2IXHHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 03:07:51 -0400
Date: Mon, 24 Sep 2012 17:07:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the staging tree with the vfs tree
Message-Id: <20120924170741.34abbc462d1c405b0b447b72@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_17_07_41_+1000_iZL0nXGuwyz1JiOT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_17_07_41_+1000_iZL0nXGuwyz1JiOT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/android/binder.c between commit 004223461eee ("new
helper: __alloc_fd()") from the vfs tree and commits efde99cd281a
("Staging: android: binder: Make task_get_unused_fd_flags function
static") and bf2023614201 ("Staging: android: binder: Remove an
inconsequential conditional macro") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/android/binder.c
index f71d624,a807129..0000000
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@@ -362,9 -362,14 +362,9 @@@ struct binder_transaction=20
  static void
  binder_defer_work(struct binder_proc *proc, enum binder_deferred_state de=
fer);
 =20
- int task_get_unused_fd_flags(struct binder_proc *proc, int flags)
 -/*
 - * copied from get_unused_fd_flags
 - */
+ static int task_get_unused_fd_flags(struct binder_proc *proc, int flags)
  {
  	struct files_struct *files =3D proc->files;
 -	int fd, error;
 -	struct fdtable *fdt;
  	unsigned long rlim_cur;
  	unsigned long irqs;
 =20

--Signature=_Mon__24_Sep_2012_17_07_41_+1000_iZL0nXGuwyz1JiOT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYAa9AAoJEECxmPOUX5FE5vAQAJMBr6cjaNzEK+M3AREnKBNG
qGhKGVe+B8F+mx02C8/+WrslMub+BH9+1s8D+/spEwLJxtH6FfP5sTnV+UBoPwSF
pnnVu6jUv+VtNJ2Dkcfa5ym4INztPT2g1z1bq5o0PZgyPl3CUdS0OQiyCd1SQtLR
bine+cd8X1pSzEb1cLnZzKcncqupC39jbsqH0+hCTHv2wzu4psks1n5FRCKaf8d/
9u7hpVXS0W+7/xQiefH6611ty5l6lK7GLamwmm9enfGj55HAHsXSfhNO/F0an19H
0UHxYDENJpF8IACxi+ckGdWucas91fJdNrAqya9VJCRWR0yQ5oGnUe4ZM0mk1DFY
GN8mHGQ6FYbGy2JL45cgBkqXD99lh4/W3bGUu9FXg7L0NKrDs0gBjKUl1paOx9Eb
4aQiY1nTNFcv0Urp8mQzw5rwvZMuOdpJ7jV77oXx6zMbAmUUErwJDNyLc4ulCfli
aW170qIC/r1ztDREvewAZE+Bl2wbi2ypp7tlAZsaqWZmadw/gQhE/e7KhHNlLo4J
XMlC/vx/qlm0EKcCIqzN6d5Xkf7WsiT7Xxf7DIYdwzBfBXpWgjwf7DpmXOptRHhi
Btk/lsDg8ssc9Wstv168fA7eX8sjfZKNuMymH21OkMSjGhUdOtaKTFk1IbYiEOjE
kDSE9PTfEaJcz70DPyID
=SybL
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_17_07_41_+1000_iZL0nXGuwyz1JiOT--
