Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab2ACBGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 20:06:48 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:50596 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2ACBGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 20:06:47 -0500
Date: Tue, 3 Jan 2012 12:06:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>
Subject: linux-next: manual merge of the xfs tree with Linus' tree
Message-Id: <20120103120632.a43a2ab50ac747093bbb2f5f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Jan_2012_12_06_32_+1100_BlmFV3uEqccojw3+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Jan_2012_12_06_32_+1100_BlmFV3uEqccojw3+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xfs tree got a conflict in
fs/xfs/xfs_sync.c between commit be4f1ac82877 ("xfs: log all dirty inodes
in xfs_fs_sync_fs") from the  tree and commit 34625c661b01 ("xfs: remove
xfs_qm_sync") from the xfs tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/xfs/xfs_sync.c
index f0994aedc,5b9ec37..0000000
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@@ -385,20 -359,7 +385,17 @@@ xfs_quiesce_data
  {
  	int			error, error2 =3D 0;
 =20
 +	/*
 +	 * Log all pending size and timestamp updates.  The vfs writeback
 +	 * code is supposed to do this, but due to its overagressive
 +	 * livelock detection it will skip inodes where appending writes
 +	 * were written out in the first non-blocking sync phase if their
 +	 * completion took long enough that it happened after taking the
 +	 * timestamp for the cut-off in the blocking phase.
 +	 */
 +	xfs_inode_ag_iterator(mp, xfs_log_dirty_inode, 0);
 +
- 	xfs_qm_sync(mp, SYNC_TRYLOCK);
- 	xfs_qm_sync(mp, SYNC_WAIT);
-=20
- 	/* force out the newly dirtied log buffers */
+ 	/* force out the log */
  	xfs_log_force(mp, XFS_LOG_SYNC);
 =20
  	/* write superblock and hoover up shutdown errors */

--Signature=_Tue__3_Jan_2012_12_06_32_+1100_BlmFV3uEqccojw3+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPAlSYAAoJEECxmPOUX5FE2egP/jtqzuG4BanEyUnHkr007tc6
AdsCF532Pmoi4uvbhySEvJf1boXvBbmIMpqgsYoYzp7F99IsyktW6LXp/1jhkmy0
dbi/i/f3an0iLgANQNqnGXqiIomBNLkX4N7WZBjkcrP4mdLssYeQ9Lp+c1U/w2ZZ
YnBIcQNv6scuDcQYzljuc1hYa2TPwg1nEX0yvDnYGd1QUg6R0ZpyMNKD0skW5wld
wc0iczjRc9AVu+exT+6kuRGgreq1pERBGyWs+NaNESd3e9WzHjv/yqghSjGDyRYl
7fL9XqK38MSpbl8gDYY1sHgqok9N1m0CpemKgWW1yTboJE/3NKg8+mDyo1vFmjc7
ex7VEoD2Xw85kpS/HyTu00RtQ5hS+WFSsJoOQfxLQT90ckWl17PLeTvr3eUtSXzn
cQ13NwjTQIVR4Z+ldK4aLzpO5NVQA8I4EhTVotCz8CAl9IyDsA66M1D5t/BggilR
5qIqHgpBJ+fmDnAq5260rMEsMyt3m9hzVuzZR9CzsNuuNVhb72HXh7ovQkbMLXDG
UF9LzXGrPpgJCRGMuZIx+78d/nuavezuabTLaYWPxF1nREz2e+WMC/8I5Xvawfa/
m1KIjKw6uIADAbjL1miemvn/6iUwV3QZ1MXS4Vr9y8wZyVSduFvn8As9C+o5ZE3m
H50ws7cA5FNGHNQAQCap
=xnju
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Jan_2012_12_06_32_+1100_BlmFV3uEqccojw3+--
