Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab2LREct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 23:32:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab2LREcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 23:32:47 -0500
Date: Tue, 18 Dec 2012 15:32:16 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux RAID <linux-raid@vger.kernel.org>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        "Jianpeng Ma" <majianpeng@gmail.com>
Subject: [PULL REQUEST] md update for 3.8
Message-ID: <20121218153216.75ba7831@notabene.brown>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1Zp8ZAQjgYxctpLg_JEQioz"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1Zp8ZAQjgYxctpLg_JEQioz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
  Not much for md this time round.

Thanks,
NeilBrown

The following changes since commit 874807a83139abc094f939e93623c5623573d543:

  md/raid1{,0}: fix deadlock in bitmap_unplug. (2012-11-27 12:14:40 +1100)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md-3.8

for you to fetch changes up to a9add5d92b64ea57fb4c3b557c3891cdeb15fa0c:

  md/raid5: add blktrace calls (2012-12-18 10:22:21 +1100)

----------------------------------------------------------------
md update for 3.8

Mostly just little fixes.  Probably biggest part is
AVX accelerated RAID6 calculations.

----------------------------------------------------------------
Jim Kukunas (1):
      lib/raid6: Add AVX2 optimized recovery functions

NeilBrown (5):
      md: removed unused variable in calc_sb_1_csm.
      md: close race between removing and adding a device.
      md.c: re-indent various 'switch' statements.
      md/raid5: use async_tx_quiesce() instead of open-coding it.
      md/raid5: add blktrace calls

Yuanhan Liu (2):
      lib/raid6: Add AVX2 optimized gen_syndrome functions
      lib/raid6: build proper files on corresponding arch

kernelmail (1):
      md:Add place to update ->recovery_cp.

majianpeng (2):
      md: Update checkpoint of resync/recovery based on time.
      md: Use ->curr_resync as last completed request when cleanly aborting=
 resync.

 arch/x86/Makefile       |   5 +-
 drivers/md/md.c         | 256 ++++++++++++++++++++------------------
 drivers/md/md.h         |   2 +
 drivers/md/raid5.c      |  43 +++++--
 include/linux/raid/pq.h |   4 +
 lib/raid6/Makefile      |   9 +-
 lib/raid6/algos.c       |  12 ++
 lib/raid6/altivec.uc    |   3 -
 lib/raid6/avx2.c        | 251 +++++++++++++++++++++++++++++++++++++
 lib/raid6/mmx.c         |   2 +-
 lib/raid6/recov_avx2.c  | 323 ++++++++++++++++++++++++++++++++++++++++++++=
++++
 lib/raid6/recov_ssse3.c |   4 -
 lib/raid6/sse1.c        |   2 +-
 lib/raid6/sse2.c        |   8 +-
 lib/raid6/test/Makefile |  29 ++++-
 lib/raid6/x86.h         |  14 ++-
 16 files changed, 809 insertions(+), 158 deletions(-)
 create mode 100644 lib/raid6/avx2.c
 create mode 100644 lib/raid6/recov_avx2.c

--Sig_/1Zp8ZAQjgYxctpLg_JEQioz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUM/x0Dnsnt1WYoG5AQLX1A//aTRYoJ8tS3UNG80vaLagCsqDNqh5NWbT
Wv1Rt0wrYIS0YhY6vKP/4R3BdJ6zX/p/8FPqoTeiD9RuO2349W7hDbGz7Bf9qVLr
/SuRwic0tQmULMa5TacDJ11Hb4BDDUraYVZVwJcJu/rWayIAq2DPsXuKOu/iw+bI
75qCEKf6WgYxZtl4hJ+mPuVycgnsWpyrE/hDJM1P18UuTvqNlj0Vde/RUXIgcF/w
eSXwiRKC30Plspp6wDzEQKPD1dDsJlUYISGeBQ4vEx8V6dArsU2+49Lke6zlR++L
AWYT2V84gHirAjh/BuI37RdP+/euBuaeuhGo1hhBf3/1UbJlywLFO520/iY1U8RX
3liaD6w4S8yOCP8JPiwhVhRA9l7eifAZwdWLf+KokhHCQbzzPS+jpifQZ/EPNHrA
MktxFxIRfAv4fauFwz5NxFmFUZILlbHdE6LnzNubPLzsgsxw7Y2MEBhkaJaQN/Ev
WLjYuMI8O5HMQLyPrK5g/Wf3nWFpxkfTePh1RHbziLVPqvLdhK+DIaWbkUQ/4lb0
hT3sAT1vmtYRtyFcp6c7Rcwq1VOR602caLsMCZWWLX4ABvQJHGCD8re99cR2fJYr
VxW9SkZkP/r8lkbfx5Eq84rWyPR6/KJdEDhfZajGEzA2kJBkTr1DXixs3QlrQSJp
ppv3GQIp5TY=
=GzmE
-----END PGP SIGNATURE-----

--Sig_/1Zp8ZAQjgYxctpLg_JEQioz--
