Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab1JYIjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:39:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294Ab1JYIjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:39:53 -0400
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UT4NLCUyyI01U09Rn3zB"
Organization: Red Hat UK Ltd
Date: Tue, 25 Oct 2011 09:41:17 +0100
Message-ID: <1319532077.2840.19.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UT4NLCUyyI01U09Rn3zB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following changes. These are at a temporary
location pending getting my kernel.org account back again. If thats an
issue, please let me know, otherwise I'm hoping that just signing this
pull request should be enough for now. I included below what I hope is
enough info that it should be possible to validate the tree from this
message.

There are no changes since I posted the patches for final review.=20

Steve.

--------------------------------------------------------------------------
The following changes since commit fd11e153b82ad1c84ccc71ba1cfedc222465198c=
:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2011-10-=
20 22:16:28 +0300)

are available in the git repository at:

  http://sucs.org/~rohan/git/gfs2-3.0-nmw/ master

Benjamin Marzinski (1):
      GFS2: rewrite fallocate code to write blocks directly

Bob Peterson (2):
      GFS2: Use rbtree for resource groups and clean up bitmap buffer ref c=
ount scheme
      GFS2: speed up delete/unlink performance for large files

Steven Whitehouse (21):
      GFS2: Clean up dir hash table reading
      GFS2: Split data write & wait in fsync
      GFS2: Fix bug-trap in ail flush code
      GFS2: Make atime checks more efficient
      GFS2: Fix inode allocation error path
      GFS2: Fix bug trap and journaled data fsync
      GFS2: Use ->dirty_inode()
      GFS2: Clean up gfs2_create
      GFS2: Fix lseek after SEEK_DATA, SEEK_HOLE have been added
      GFS2: Make resource groups "append only" during life of fs
      GFS2: Cache the most recently used resource group in the inode
      GFS2: Remove obsolete assert
      GFS2: Call do_strip() directly from recursive_scan()
      GFS2: Use cached rgrp in gfs2_rlist_add()
      GFS2: Fix AIL flush issue during fsync
      GFS2: Correctly set goal block after allocation
      GFS2: Clean up ->page_mkwrite
      GFS2: Fix off-by-one in gfs2_blk2rgrpd
      GFS2: Misc fixes
      GFS2: Remove two unused variables
      GFS2: Move readahead of metadata during deallocation into its own fun=
ction

 fs/gfs2/acl.c        |    5 +-
 fs/gfs2/aops.c       |    8 +-
 fs/gfs2/bmap.c       |  199 ++++++++++--------
 fs/gfs2/dir.c        |   50 +----
 fs/gfs2/file.c       |  295 ++++++++++----------------
 fs/gfs2/glops.c      |   89 ++++----
 fs/gfs2/glops.h      |    2 +-
 fs/gfs2/incore.h     |   23 +--
 fs/gfs2/inode.c      |  112 ++++-------
 fs/gfs2/inode.h      |    2 +-
 fs/gfs2/lops.c       |   66 +++----
 fs/gfs2/ops_fstype.c |    6 +-
 fs/gfs2/quota.c      |   28 +--
 fs/gfs2/rgrp.c       |  573 +++++++++++++++++-----------------------------=
----
 fs/gfs2/rgrp.h       |   31 +--
 fs/gfs2/super.c      |  134 +++++++-----
 fs/gfs2/trans.c      |    5 -
 fs/gfs2/trans.h      |   22 +-
 fs/gfs2/xattr.c      |   28 +--
 19 files changed, 666 insertions(+), 1012 deletions(-)

---------------------------------------------------------------------------=
------
Top of tree commit (to verify tree matches details in this email, if requir=
ed):

author	Steven Whitehouse <swhiteho@redhat.com>=09
	 Wed, 21 Sep 2011 10:05:16 +0000 (11:05 +0100)
committer	Steven Whitehouse <swhiteho@redhat.com>=09
	 Fri, 21 Oct 2011 11:39:54 +0000 (12:39 +0100)
commit	b99b98dc2673a123a73068f16720232d7be7e669
tree	a191b03e9c054c62777d1b3ab3cae55cbd6e5e01	tree | snapshot
parent	9ae32429fe036fcfce036ec57b28fc59f3911976	commit | diff


--=-UT4NLCUyyI01U09Rn3zB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOpnYoAAoJEMrg3m4a/8jS92wQAIHiPiaR6uBQS2DXj3GWGhg+
rIGqH17r3kwSDxHnj3jSERBkiQJOlXl39vJ+pjNeNssNnOLD0BL8L6U5g9esm8cT
aYBwXpu7ACdPhmMc6qhfKVtDkp/TefzJz8re9Twl++RU7EYvij3ynuT6IabM9JyN
OTDS7AMJ6PTK7r6rdyssF6CyHvJvyWIODCVDiJdU6M6EZKQxU2vaUAkVFTt4ED00
dJwqJE/2gAfStADoVsZ8QWBjsQ9Ahk9wMxa3O1Gljyl6SwFu3srNcgI7Djzc1ut6
1EE82tDCrfNS5lSCk3uPZR6CXW4w6pXRYTPdM/nMct8iOX3kJIrTYilfcGA2rJil
VdBGHwhtPualYC8HCQEK/mvhCSy3iK4ALKn3THUALRBd9r0B7fc/mlEXXgTtQTus
aXk//90bTIiprsFGuM9Hkecef2IupsKepqDUfFR3Abfhqsl5p+rkooDycQlpuJsO
N7OXZ2kR74xGwH7FNBpHlNttnWLdeoqWIcI47vSHTYBgdfCcGvrQZDDWNSJlK3n9
V96ZFoWgGJwkGnW9uSB4nFmuVM6/f+PvrVsC8qLiF11my+CSe8ja7KXWL3XZtUsP
1Mo57ALl7VC4ozCLewLdhBjG1iXk5qV5TyfNbMsO2lv55Xed6u3BbxGm/v6g7bMK
2CmJFdJIPvzIQoLybHqN
=GS1M
-----END PGP SIGNATURE-----

--=-UT4NLCUyyI01U09Rn3zB--

