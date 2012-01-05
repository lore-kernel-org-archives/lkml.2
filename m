Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab2AEEDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 23:03:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757803Ab2AEEDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 23:03:34 -0500
Date: Thu, 5 Jan 2012 15:03:19 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] md for 3.3
Message-ID: <20120105150319.375211fd@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/An_sbt5NhfT.B72T=ji_GhF"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/An_sbt5NhfT.B72T=ji_GhF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Thanks,
NeilBrown


The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:

  Linux 3.2 (2012-01-04 15:55:44 -0800)

are available in the git repository at:

  git://neil.brown.name/md/ md-3.3

for you to fetch changes up to 19d671695e1931ebfd75b2b888778201aefe35ca:

  md/raid1: Mark device want_replacement when we see a write error. (2011-1=
2-23 10:17:57 +1100)

----------------------------------------------------------------
(from the branch description for md-scratch local branch)

for-linus
md update for 3.3

Big change is new hot-replacement.
A slot in an array can hold 2 devices - one that
wants-replacement and one that is the replacement.
Once the replacement is built - either from the
original or (in the case of errors) from elsewhere,
the wants-replacement device will be removed.

----------------------------------------------------------------
NeilBrown (35):
      md: allow non-privileged uses to GET_*_INFO about raid arrays.
      md/bitmap: daemon_work cleanup.
      md/raid5: be more thorough in calculating 'degraded' value.
      md/bitmap: be more consistent when setting new bits in memory bitmap.
      md: remove test for duplicate device when setting slot number.
      md: change hot_remove_disk to take an rdev rather than a number.
      md: create externally visible flags for supporting hot-replace.
      md/raid5: allow each slot to have an extra replacement device
      md/raid5: raid5.h cleanup
      md/raid5: remove redundant bio initialisations.
      md/raid5: preferentially read from replacement device if possible.
      md/raid5: allow removal for failed replacement devices.
      md/raid5: writes should get directed to replacement as well as origin=
al.
      md/raid5:  detect and handle replacements during recovery.
      md/raid5: handle activation of replacement device when recovery compl=
etes.
      md/raid5: recognise replacements when assembling array.
      md/raid5: If there is a spare and a want_replacement device, start re=
placement.
      md/raid5: Mark device want_replacement when we see a write error.
      md/raid10: prepare data structures for handling replacement.
      md/raid10:  change read_balance to return an rdev
      md/raid10: preferentially read from replacement device if possible.
      md/raid10: allow removal of failed replacement devices.
      md/raid10: writes should get directed to replacement as well as origi=
nal.
      md/raid10:  Handle replacement devices during resync.
      md/raid10: handle recovery of replacement devices.
      md/raid10: Allow replacement device to be replace old drive.
      md/raid10: recognise replacements when assembling array.
      md/raid10: If there is a spare and a want_replacement device, start r=
eplacement.
      md/raid1:  Replace use of mddev->raid_disks with conf->raid_disks.
      md/raid1: Allocate spare to store replacement devices and their bios.
      md/raid1: Allow a failed replacement device to be removed.
      md/raid1: handle activation of replacement device when recovery compl=
etes.
      md/raid1: recognise replacements when assembling arrays.
      md/raid1: If there is a spare and a want_replacement device, start re=
placement.
      md/raid1: Mark device want_replacement when we see a write error.

Steven Rostedt (1):
      md: Fix userspace free_pages() macro

 Documentation/md.txt      |   22 ++-
 drivers/md/bitmap.c       |   12 +-
 drivers/md/md.c           |  107 ++++++--
 drivers/md/md.h           |   82 ++++---
 drivers/md/multipath.c    |    7 +-
 drivers/md/raid1.c        |  174 ++++++++++----
 drivers/md/raid1.h        |    7 +-
 drivers/md/raid10.c       |  582 ++++++++++++++++++++++++++++++++++++-----=
----
 drivers/md/raid10.h       |   61 +++--
 drivers/md/raid5.c        |  557 ++++++++++++++++++++++++++++++++---------=
--
 drivers/md/raid5.h        |   98 +++++----
 include/linux/raid/md_p.h |    7 +-
 include/linux/raid/pq.h   |    2 +-
 13 files changed, 1280 insertions(+), 438 deletions(-)

--Sig_/An_sbt5NhfT.B72T=ji_GhF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwUhBznsnt1WYoG5AQImhg/8DznoW3G8PzuSzpGbjL1wjMz7eXxkUq/i
Tv14Ksm67czvNe8DNK1nvg7ACXmqyL31i4ErnnQvtgDkMfigFsrpWqIcq5v967+h
mPYkbOqg+d29+klsTsmXe+wiwZWoN9c2ctGTQGQbaf914YExfvJpHIJdmphMGipx
2D+tBuA0+7sVVjhoWNY9h/ACpfezodcm6STtsq6FVVyot3yDKWsTjR1R+L9M/Wtu
00YRqjQHIz3U8FLauLb3eg4JUqz+PiGayKDDwTwoco07rUEwJLJoqJzTL/pKvcse
rLTOmiMn0wqCWsbRBx4apNJOVnQmSX2pK5elD8z/KIUL2Tnk/3kRwsZrqUuAJXrf
tA8a+7Xdog+gmnOAHaT33pDviHC4W8YqDxEjWhKaIGBiCX0d7hNY+f3CT3xqp9tZ
lbrHDrDuBBqLJjIDA0PUkz0BeLxFuXin1pu3+0Ww5Y8OH3xXdv4f3oVbSUo9Q7Fz
IhueqiqXqMjr3DY2kT+G2IG8j1h4PW3R1jdFLcFJ2JYpIU6TNhbOhS+Z8Va3ZeHc
FkBS9HfxDKUQQ57UIs9H1bm0hHNi1dSoZ4mpjR2oTKL4HW6d8tMe9IlBQlu5/IRX
S5YG2SyCZ34p+92r1Ru30dBT66IeZRmEp2zqo+HQKrQJTmy+UGoGGVtZa4cZX+o9
b31pQhAF2OI=
=ov37
-----END PGP SIGNATURE-----

--Sig_/An_sbt5NhfT.B72T=ji_GhF--
