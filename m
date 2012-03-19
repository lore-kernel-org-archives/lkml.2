Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162078Ab2CSGBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:01:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161488Ab2CSGBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:01:02 -0400
Date: Mon, 19 Mar 2012 17:00:50 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: PULL REQUEST - md updates for 3.4
Message-ID: <20120319170050.418d5fea@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.XbJs2j_7NX_U4CNP907Vas"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.XbJs2j_7NX_U4CNP907Vas
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:

  Linux 3.3 (2012-03-18 16:15:34 -0700)

are available in the git repository at:

  git://neil.brown.name/md/ md-3.4

for you to fetch changes up to ecb178bb2b154a40cfae9fa4c42e62ccfa81ac6b:

  md: Add judgement bb->unacked_exist in function md_ack_all_badblocks(). (=
2012-03-19 12:46:42 +1100)

----------------------------------------------------------------
(from the branch description for md-scratch local branch)

for-linus
md updates for 3.4

Mostly tidying up code in preparation for some bigger changes
next time.
A few bug fixes tagged for -stable.

Main functionality change is that some RAID10 arrays can now
grow to use extra space that may have been made available on the
individual devices.

----------------------------------------------------------------
NeilBrown (19):
      md/raid5: make sure reshape_position is cleared on error path.
      md/raid10: remove unnecessary smp_mb() from end_sync_write
      md/raid5: removed unused 'added_devices' variable.
      md: allow re-add to failed arrays.
      md: don't set md arrays to readonly on shutdown.
      md/bitmap: ensure to load bitmap when creating via sysfs.
      md/raid1,raid10: avoid deadlock during resync/recovery.
      md: tidy up rdev_for_each usage.
      md: add proper merge_bvec handling to RAID0 and Linear.
      md/raid10: handle merge_bvec_fn in member devices.
      md/raid1: handle merge_bvec_fn in member devices.
      md/raid10 - support resizing some RAID10 arrays.
      md/bitmap: remove some unused noise from bitmap.h
      md/bitmap: move printing of bitmap status to bitmap.c
      md/bitmap: change a 'goto' to a normal 'if' construct.
      md/bitmap: remove some pointless locking.
      md/bitmap: remove unnecessary indirection when allocating.
      md/bitmap: discard CHUNK_BLOCK_SHIFT macro
      md: fix clearing of the 'changed' flags for the bad blocks list.

majianpeng (3):
      md: Use existed macros instead of numbers
      md/raid5: use atomic_dec_return() instead of atomic_dec() and atomic_=
read().
      md: Add judgement bb->unacked_exist in function md_ack_all_badblocks(=
).

 drivers/md/bitmap.c       |  152 ++++++++++++++++++------------------
 drivers/md/bitmap.h       |   22 +-----
 drivers/md/dm-raid.c      |   16 ++--
 drivers/md/faulty.c       |    2 +-
 drivers/md/linear.c       |   32 ++++----
 drivers/md/md.c           |  140 ++++++++++++++--------------------
 drivers/md/md.h           |   13 +++-
 drivers/md/multipath.c    |    2 +-
 drivers/md/raid0.c        |  164 ++++++++++++++++++++++------------------
 drivers/md/raid0.h        |   11 ++-
 drivers/md/raid1.c        |   98 ++++++++++++++++++------
 drivers/md/raid10.c       |  187 +++++++++++++++++++++++++++++++++--------=
----
 drivers/md/raid5.c        |   25 +++----
 include/linux/raid/md_p.h |    6 +-
 14 files changed, 496 insertions(+), 374 deletions(-)

--Sig_/.XbJs2j_7NX_U4CNP907Vas
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2bLkjnsnt1WYoG5AQJtnQ//SfJuRupZqn6ZfVbXL+1cT3kImRo4ay29
72TxUHPP4Jo7mtJ1Q9xn1sPYk5fL1DWzcdbDm+CKbJj+Jb2nnyur4N6hxdM14Wfj
/KhAcz5K87awagoLy7XX4+avufS6If38VuB0AcMUz0Xn2YH4PJ1XfeX2HaqmUI84
2kgsTY46HEvUFv6fX/ad22Gyl7cZlR5ocp9mpvVIXMYBLi17lSiJs0SXojL+pGGn
TjTKpLaJKK5Vdzg0UPAoK9OvBu9sP4ep5rhk6k9K+chnZDnBApuk1c4R0mlTN8ws
YiiNipOwFFYE6SmVVoIPKl2ZtrZFKz9UF0cDcgf0318cwII95hqGUASOxM73t9Bf
O7ZZm0VLJ/EUVSjSrrRBjD38r/AID5eSJXVFFQkmQanwwYVZtTq3dPN2fU0TDQYM
R7bSzCZK9b7aMbwn2QoC9nXRHZIi+MF2m4LgBFyaR152p0HiY5ymIdPvieiwvp7U
NhGJ0zYKzlRFrPtXdD+FYQnZXKhyQ/zgCkj78Y1UXp3dYntQpv2lnaLwO35nGyzF
pSZ0sB1Mmtmzrwzl0OMxHTErw3P7kN1UqvfQKPPfOXB4QK2ZByE0btOmryONVF4E
ktnttSUazITRtdRPUZetY1m7Cf2WKBF/5j0NWO8abNCtKz/5K5SJK9RQZpYQirQL
VxIsNu6C7Y4=
=HRai
-----END PGP SIGNATURE-----

--Sig_/.XbJs2j_7NX_U4CNP907Vas--
