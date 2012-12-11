Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab2LKKkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 05:40:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab2LKKko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 05:40:44 -0500
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AJYFeU8yeofxhM+tb4FN"
Organization: Red Hat UK Ltd
Date: Tue, 11 Dec 2012 10:39:27 +0000
Message-ID: <1355222367.2721.3.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AJYFeU8yeofxhM+tb4FN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following changes:

The main feature this time is the new Orlov allocator and the patches
leading up to it which allow us to allocate new inodes from their own
allocation context, rather than borrowing that of their parent directory.
It is this change which then allows us to choose a different location
for subdirectories when required. This works exactly as per the ext3
implementation from the users point of view.

In addition to that, we've got a speed up in gfs2_rbm_from_block()
from Bob Peterson, three locking related improvements from Dave
Teigland plus a selection of smaller bug fixes and clean ups.

The following changes since commit 0e4a43ed08e2f44aa7b96aa95d0a540d675483e1=
:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes =
(2012-11-07 13:38:56 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git mast=
er

Bob Peterson (7):
      GFS2: Speed up gfs2_rbm_from_block
      GFS2: Rename glops go_xmote_th to go_sync
      GFS2: Use dirty_inode in gfs2_dir_add
      GFS2: Eliminate redundant buffer_head manipulation in gfs2_unlink_ino=
de
      GFS2: don't reference inode's glock during block allocation trace
      GFS2: add error check while allocating new inodes
      GFS2: Set gl_object during inode create

David Teigland (3):
      GFS2: skip dlm_unlock calls in unmount
      GFS2: only use lvb on glocks that need it
      GFS2: remove redundant lvb pointer

Steven Whitehouse (6):
      GFS2: Review bug traps in glops.c
      GFS2: Add test for resource group congestion status
      GFS2: Use proper allocation context for new inodes
      GFS2: Add Orlov allocator
      GFS2: Fix truncation of journaled data files
      GFS2: Fix one RG corner case

 fs/gfs2/aops.c       |    2 +-
 fs/gfs2/bmap.c       |   54 ++++++++++++-
 fs/gfs2/dir.c        |    7 +--
 fs/gfs2/file.c       |    4 +-
 fs/gfs2/glock.c      |   40 ++++++----
 fs/gfs2/glock.h      |   54 +++++++-------
 fs/gfs2/glops.c      |   19 +++--
 fs/gfs2/incore.h     |    6 +-
 fs/gfs2/inode.c      |  209 ++++++++++++++++++++++++++--------------------=
----
 fs/gfs2/lock_dlm.c   |   20 ++++-
 fs/gfs2/ops_fstype.c |    3 +
 fs/gfs2/quota.c      |   10 +-
 fs/gfs2/rgrp.c       |  139 +++++++++++++++++++++++++++++----
 fs/gfs2/rgrp.h       |    3 +-
 fs/gfs2/trace_gfs2.h |    2 +-
 fs/gfs2/xattr.c      |    2 +-
 16 files changed, 380 insertions(+), 194 deletions(-)


--=-AJYFeU8yeofxhM+tb4FN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQxw1ZAAoJEMrg3m4a/8jSB+4QAIJ30ArsSC5WUKwd0VNjlFn3
vWLnNqmub5N99g/8WuK1jtMdyQiH4qC68uxGQOmhWMBJ154B0cEf8GGSv2hkLMma
0O48m/C12qcyJncCCG1jrZqbOEvUJXvGY2bX2vsxzjtcTxh5z+yHPMfUYHwgvrva
Lf9FNsdYOIZ83qgYFvWicix7/ZIcI3sCdrqgXkqlybv8Lg0lVKyj8hAl/r3Y4NAk
nawvOb+Ir5M4G+ABIFiubowa2paathHXxX6hl1pjugWCTe4J7qOLlZrTG4kYWXHT
Y1mCLKkv5hbJXeY8Ia1H0aTxlWe7cU4sSl2uA32TqoNnb0okjagDErTjRcQ+V4mH
9NW5QUkKAs307uyZu3251ywprqCn7cL0Vv5Rq8EWjfSwoYzlVOUuIE7IMTfB7izc
i65CtozQEV2ODLdAGQsF7V6T9m4Faw/FYGk0M1Y2JVuBHhVQxdanR1kKcxnM3k+I
Jd9WF9c1dP70uBN4Ch9KyUwOK1DhkAc++ZwugNN6i192c5sWb+5QPEsqhBcSzxOi
UR2rSkKXDuo0AFktUkuEkfFuLkt1w/fF8e08N8AOwdWaG8yFHicXZi41LX7GX78z
cwdveAJgIvTVOhORceji9XxB6togB0V0lROol85ibCIirej0Q5lQt5Wt6DYcL3ut
9pR6EMGFpFQ42uIsy9uG
=Wr02
-----END PGP SIGNATURE-----

--=-AJYFeU8yeofxhM+tb4FN--

