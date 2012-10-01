Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab2JAJK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 05:10:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab2JAJKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 05:10:23 -0400
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1347543744.2719.5.camel@menhir>
References: <1347543744.2719.5.camel@menhir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-z19nz0rWwzQ+de2Zbyy0"
Organization: Red Hat UK Ltd
Date: Mon, 01 Oct 2012 10:09:30 +0100
Message-ID: <1349082570.2775.5.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-z19nz0rWwzQ+de2Zbyy0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following changes,

Steve.

-----------------------------------------------------------------------

The major feature this time is the "rbm" conversion in the resource
group code. The new struct gfs2_rbm specifies the location of an
allocatable block in (resource group, bitmap, offset) form. There
are a number of added helper functions, and later patches then
rewrite some of the resource group code in terms of this new
structure. Not only does this give us a nice code clean up, but            =
    =20
it also removes some of the previous restructions where extents
could not cross bitmap boundaries, for example.

In addition to that, there are a few bug fixes and clean ups, but
the rbm work is by far the majority of this patch set in terms of
number of changed lines.

-----------------------------------------------------------------------

The following changes since commit 979570e02981d4a8fc20b3cc8fd651856c98ee9d=
:

  Linux 3.6-rc7 (2012-09-23 18:10:57 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git mast=
er

Benjamin Marzinski (1):
      GFS2: Write out dirty inode metadata in delayed deletes

Bob Peterson (9):
      GFS2: rbm code cleanup
      GFS2: change function gfs2_direct_IO to use a normal gfs2_glock_dq
      GFS2: inline __gfs2_glock_schedule_for_reclaim
      GFS2: Combine functions gfs2_glock_wait and wait_on_holder
      GFS2: Combine functions gfs2_glock_dq_wait and wait_on_demote
      GFS2: Eliminate redundant calls to may_grant
      GFS2: Eliminate unnecessary check for state > 3 in bitfit
      GFS2: Stop block extents at the end of bitmaps
      GFS2: Fix infinite loop in rbm_find

Eric Sandeen (1):
      GFS2: fix s_writers.counter imbalance in gfs2_ail_empty_gl

Jan Kara (1):
      GFS2: Get rid of I_MUTEX_QUOTA usage

Michel Lespinasse (1):
      GFS2: Use RB_CLEAR_NODE() rather than rb_init_node()

Steven Whitehouse (14):
      GFS2: Merge two nearly identical xattr functions
      GFS2: Remove rs_requested field from reservations
      GFS2: Add structure to contain rgrp, bitmap, offset tuple
      GFS2: Replace rgblk_search with gfs2_rbm_find
      GFS2: Update gfs2_get_block_type() to use rbm
      GFS2: Update rgblk_free() to use rbm
      GFS2: Fix case where reservation finished at end of rgrp
      GFS2: Use rbm for gfs2_testbit()
      GFS2: Use rbm for gfs2_setbit()
      GFS2: Fix ->show_options() for statfs slow
      GFS2: Fall back to ignoring reservations, if there are no other block=
s left
      GFS2: Improve block reservation tracing
      GFS2: Fix unclaimed_blocks() wrapping bug and clean up
      GFS2: Consolidate free block searching functions

 fs/gfs2/aops.c       |   11 +-
 fs/gfs2/bmap.c       |    2 +-
 fs/gfs2/file.c       |    4 +-
 fs/gfs2/glock.c      |   60 +--
 fs/gfs2/glops.c      |    1 +
 fs/gfs2/incore.h     |   30 +-
 fs/gfs2/inode.c      |   20 +-
 fs/gfs2/ops_fstype.c |    8 +
 fs/gfs2/quota.c      |   11 +-
 fs/gfs2/rgrp.c       | 1203 ++++++++++++++++++++++++----------------------=
----
 fs/gfs2/rgrp.h       |   28 +-
 fs/gfs2/super.c      |    9 +-
 fs/gfs2/trace_gfs2.h |   20 +-
 fs/gfs2/trans.h      |    7 +-
 fs/gfs2/xattr.c      |   96 ++---
 15 files changed, 710 insertions(+), 800 deletions(-)


--=-z19nz0rWwzQ+de2Zbyy0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQaV3FAAoJEMrg3m4a/8jS2lAP/AlIvJtxALzvNGgL2SgR2RWw
Pppl+ErlP8ygOHp9hGUz7YogaIRbSPdTG3d5Fg4PKALeVVfiw28k+MWmqsY817pd
rda8MnVcEff0uiOS7JgdidpH/uG/4bqTw/6/5MtK4aIlvk2KiYg8tYTO4spZgiZ1
JnJ+/Qfig3r6kQAJ+9G77nci6n7UCBsBy4sO4gU5RueEzF1qDwsiyuV1j42BwAa+
0TXxG653pAUD1jB9IFiLCYCtBpgNh0TKwuTbqsz3JwkOIO4l6l2ZHyR5C/GOJfby
9+SlRb2+VkzpPsp1G+SfjdP0SWe9XrF+6OtJZZ8RMPqRaRS9h2R40LY4c68X4g6C
9kmC+lYHWaTJ+E70BpxIbgy3tUDLo4jrzYN0ACgNLoSOweELAw1Ie4gwSY9LC8nC
S8tv3FeZ9yXcVHD7BdHgCEScMKCB/vaN7i0svV6+vxXZ48a6Q9MuocPZ6R9deB49
irLWeiS6mtzWpBbjcmFQH5/JhwE/dUdyIc2wSQ/O5+YEbqFjXhsf0uzwSSWansuY
LhNFCbTt+VDkT4/QSbhCeTE3FZ2yGEwMwvp/f6sgvn5U9gNHluqd1Y6IiGDQtp+f
gwi6RusGvW9hAB44b0LP3M6CpUX+VyPlyGeyjrss1hbOjxdjQGoJLfxEfQUne2cD
5PY8geyc53SjEz9V5fz4
=w9jO
-----END PGP SIGNATURE-----

--=-z19nz0rWwzQ+de2Zbyy0--

