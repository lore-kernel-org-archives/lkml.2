Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab2JMJ6g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 05:58:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab2JMJ6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 05:58:34 -0400
Date: Sat, 13 Oct 2012 20:58:39 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jianpeng Ma <majianpeng@gmail.com>,
        Alexander Lyakas <alex.bolshoy@gmail.com>,
        Shaohua Li <shli@kernel.org>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jan Beulich <JBeulich@suse.com>,
        Jonathan Brassow <jbrassow@redhat.com>,
        Denis Efremov <yefremov.denis@gmail.com>
Subject: [PULL REQUEST] md updates for 3.7
Message-ID: <20121013205839.7dc4fe45@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Nslm=YgR.D9VpxTWLRDCO2H"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Nslm=YgR.D9VpxTWLRDCO2H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


MD updates for 3.7.
Latish because I needed to wait for the block tree to get merged.

Thanks,
NeilBrown



The following changes since commit 02f3939e1a9357b7c370a4a69717cf9c02452737:

  block: makes bio_split support bio without data (2012-09-28 10:38:48 +020=
0)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md-3.7

for you to fetch changes up to 72f36d5972a166197036c1281963f6863c429bf2:

  md: refine reporting of resync/reshape delays. (2012-10-11 14:25:57 +1100)

----------------------------------------------------------------
md updates for 3.7

"discard" support, some dm-raid improvements and other assorted
bits and pieces.

----------------------------------------------------------------
Alexander Lyakas (1):
      md: When RAID5 is dirty, force reconstruct-write instead of read-modi=
fy-write.

Dan Carpenter (1):
      md/raid10: use correct limit variable

Denis Efremov (1):
      md/linear: rcu_dereference outside read-lock section

Jan Beulich (1):
      add further __init annotations to crypto/xor.c

Jianpeng Ma (2):
      md/bitmap:Don't use IS_ERR to judge alloc_page().
      Subject: [PATCH] md:change resync_mismatches to atomic64_t to avoid r=
aces

Jonathan Brassow (5):
      MD RAID10: Prep for DM RAID10 device replacement capability
      DM RAID: Move 'rebuild' checking code to its own function
      DM RAID: Add rebuild capability for RAID10
      DM RAID: Fix comparison of index and quantity for "rebuild" parameter
      DM RAID: Fix for "sync" directive ineffectiveness

Michael Wang (1):
      raid: replace list_for_each_continue_rcu with new interface

NeilBrown (10):
      md/raid10: submit IO from originating thread instead of md thread.
      md: avoid taking the mutex on some ioctls.
      md/raid1: Don't release reference to device while handling read error.
      md/raid5: add some missing locking in handle_failed_stripe.
      md/raid5: protect debug message against NULL derefernce.
      md/raid5: make sure to_read and to_write never go negative.
      md: writing to sync_action should clear the read-auto state.
      md: make sure manual changes to recovery checkpoint are saved.
      md/raid5: be careful not to resize_stripes too big.
      md: refine reporting of resync/reshape delays.

Shaohua Li (7):
      md: linear supports TRIM
      md: raid 0 supports TRIM
      md: raid 1 supports TRIM
      md: raid 10 supports TRIM
      MD: change the parameter of md thread
      MD: raid5 trim support
      MD: raid5 avoid unnecessary zero page for trim

 Documentation/device-mapper/dm-raid.txt |   9 ++
 crypto/xor.c                            |   4 +-
 drivers/md/bitmap.c                     |  17 +--
 drivers/md/dm-raid.c                    | 124 ++++++++++++++----
 drivers/md/linear.c                     |  25 +++-
 drivers/md/md.c                         | 145 +++++++++++++++------
 drivers/md/md.h                         |   9 +-
 drivers/md/multipath.c                  |   3 +-
 drivers/md/raid0.c                      |  19 ++-
 drivers/md/raid1.c                      |  37 ++++--
 drivers/md/raid10.c                     |  95 ++++++++++++--
 drivers/md/raid5.c                      | 219 ++++++++++++++++++++++++++++=
----
 drivers/md/raid5.h                      |   1 +
 13 files changed, 578 insertions(+), 129 deletions(-)

--Sig_/Nslm=YgR.D9VpxTWLRDCO2H
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUHk7Tznsnt1WYoG5AQJ2ag/9FJJcJTI7DJfV7tAyU5UjVcQnM3EXbYp/
+u7eER4AfP543ww8pOwX7bQkqHjWleymHoEBybNvKbYaw9JooPvwkiDEF6O4EJ3U
udas30Swhm28yJZFZiX+R5JIi35pcii012na8rsHyoBRFFQWgZMZnkHuDsUolNvk
cCqKhv8NHHnCVp0tlB4pqJsj4ep7clfsSiRzhrlvjxuOaZixHiSvUB7muvJzmmqc
kptYXZf5p/r/kOQBL8DlaIFqoEVJzxjeCdGAmsiAy3N+JAhHn+d4Acec9WqWXKD5
3RhiXYRzIe/rOVDjl8LpIUIOHuh+2OYyeVapFUlQzly42LaEBvpmqUG11zNWb0cf
4t7T0+1NPa0NgfCLW7WPNnjj7SsVAfVwhmrYNvCaAjtp8Osqjz49q3JjZrwUkjAK
0AkHTcEAv8gL6j0QLQBbv4LghvcnZWbvhLMUqWGw5FV0F4ZzqCna6Bai2kxMSaAi
706NODXyIupkJlA5tIxeLbqyPnUNSPlbUD4aVg3tA8yKvwLfftoIOSbAJ36Ce7CY
MM3xeB8F/V3UjTKf09iMb3sgaAG/dH9ZvZ0VbmuNShE/2Yzg/UrW97DQXh+iYAg7
gqR5bLl/JHanAzAc2EgL49Ix+LxwP2L3whCpRuGeVKvKNmn40hTgdzJZy/9V19eV
sRwFKkyibb0=
=v3qC
-----END PGP SIGNATURE-----

--Sig_/Nslm=YgR.D9VpxTWLRDCO2H--
