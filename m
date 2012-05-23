Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965063Ab2EWDYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 23:24:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964844Ab2EWDY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 23:24:28 -0400
Date: Wed, 23 May 2012 13:24:14 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] md updates for 3.5
Message-ID: <20120523132414.75d08bdb@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3UVawm27M7Z192J0WLvB/Jn"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3UVawm27M7Z192J0WLvB/Jn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 It's been a busy cycle for md - lots of fun stuff here.. if you like this
 king of thing :-)

Thanks,
NeilBrown


The following changes since commit b0d634d5683f0b186b242ce6a4f3b041edb8b956:

  md/raid10: fix transcription error in calc_sectors conversion. (2012-05-1=
9 09:01:13 +1000)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md-3.5

for you to fetch changes up to 1dff2b87a34a1ac1d1898ea109bf97ed396aca53:

  md/bitmap: record the space available for the bitmap in the superblock. (=
2012-05-22 13:55:34 +1000)

----------------------------------------------------------------
md updates for 3.5

Main features:
 - RAID10 arrays can be reshapes - adding and removing devices and
   changing chunks (not 'far' array though)
 - allow RAID5 arrays to be reshaped with a backup file (not tested
   yet, but the priciple works fine for RAID10).
 - arrays can be reshaped while a bitmap is present - you no longer
   need to remove it first
 - SSSE3 support for RAID6 syndrome calculations

and of course a number of minor fixes etc.

----------------------------------------------------------------
Jim Kukunas (7):
      crypto: wait for a full jiffy in do_xor_speed
      crypto: disable preemption while benchmarking RAID5 xor checksumming
      raid5: add AVX optimized RAID5 checksumming
      lib/raid6: fix test program build
      lib/raid6: Add SSSE3 optimized recovery functions
      lib/raid6: update test program for recovery functions
      lib/raid6: cleanup gen_syndrome function selection

Jonathan Brassow (4):
      DM RAID: Set recovery flags on resume
      DM RAID: Record and handle missing devices
      DM RAID: Use md_error() in place of simply setting Faulty bit
      MD RAID1: Further conditionalize 'fullsync'

NeilBrown (39):
      md: allow a reshape operation to be reversed.
      md: add possibility to change data-offset for devices.
      md/raid5:  Use correct data_offset for all IO.
      md/raid5: allow for change in data_offset while managing a reshape.
      md/raid10: collect some geometry fields into a dedicated structure.
      md: teach sync_page_io about new_data_offset.
      md: use resync_max_sectors for reshape as well as resync.
      md/raid10: Introduce 'prev' geometry to support reshape.
      md/raid10: split out interpretation of layout to separate function.
      md/raid10: add reshape support
      md: dm-raid should call helper function to clear rdev.
      md: move freeing of badblocks.page into md_rdev_clear
      md/bitmap: disentangle two different 'pending' flags.
      md/bitmap: add new 'space' attribute for bitmaps.
      md/bitmap: allow a bitmap with no backing storage.
      md/bitmap: centralise allocation of bitmap file pages.
      md/bitmap: change *_page_attr() to take a page number, not a page.
      md/bitmap: move some fields of 'struct bitmap' into a 'storage' subst=
ruct.
      md/bitmap: store bytes in file rather than just in last page.
      md/bitmap: separate bitmap file allocation to its own function.
      md/bitmap: move storage allocation from bitmap_load to bitmap_create.
      md/bitmap: remove bitmap_mask_state
      md/bitmap: remove single-bit manipulation on sb->state
      md/bitmap: use set_bit, test_bit, etc for operation on bitmap->flags.
      md/bitmap: convert some spin_lock_irqsave to spin_lock_irq
      md/bitmap: remove async freeing of bitmap file.
      md/bitmap: merge bitmap_file_unmap and bitmap_file_put.
      md/bitmap: make _page_attr bitops atomic.
      md/bitmap: make bitmap bitops atomic.
      md/bitmap: create a 'struct bitmap_counts' substructure of 'struct bi=
tmap'
      md/bitmap: use DIV_ROUND_UP instead of open-code
      md/bitmap: add bitmap_resize function to allow bitmap resizing.
      md/bitmap: make sure reshape request are reflected in superblock.
      md: allow array to be resized while bitmap is present.
      md/raid10: resize bitmap when required during reshape.
      md/raid5: Allow reshape while a bitmap is present.
      md/raid5: improve removal of extra devices after reshape.
      md/raid10: Remove extras after reshape to smaller number of devices.
      md/bitmap: record the space available for the bitmap in the superbloc=
k.

Shaohua Li (3):
      md: using GFP_NOIO to allocate bio for flush request
      raid5: remove unused variables
      raid5: support sync request

Yuanhan Liu (1):
      md: check the return of mddev_find()

majianpeng (2):
      md/raid1: allow fix_read_error to read from recovering device.
      md/raid10: Fix memleak in r10buf_pool_alloc

 arch/x86/Makefile              |    5 +-
 arch/x86/include/asm/xor_32.h  |    6 +-
 arch/x86/include/asm/xor_64.h  |    8 +-
 arch/x86/include/asm/xor_avx.h |  214 +++++++
 crypto/xor.c                   |   13 +-
 drivers/md/bitmap.c            | 1100 +++++++++++++++++++---------------
 drivers/md/bitmap.h            |   60 +-
 drivers/md/dm-raid.c           |   22 +-
 drivers/md/md.c                |  370 ++++++++++--
 drivers/md/md.h                |   12 +-
 drivers/md/raid1.c             |   22 +-
 drivers/md/raid10.c            | 1281 +++++++++++++++++++++++++++++++++++-=
----
 drivers/md/raid10.h            |   34 +-
 drivers/md/raid5.c             |  252 +++++---
 drivers/md/raid5.h             |    7 +
 include/linux/raid/md_p.h      |   15 +-
 include/linux/raid/pq.h        |   18 +-
 lib/raid6/Makefile             |    2 +-
 lib/raid6/algos.c              |  127 ++--
 lib/raid6/mktables.c           |   25 +
 lib/raid6/recov.c              |   15 +-
 lib/raid6/recov_ssse3.c        |  335 +++++++++++
 lib/raid6/test/Makefile        |    2 +-
 lib/raid6/test/test.c          |   32 +-
 lib/raid6/x86.h                |   15 +-
 25 files changed, 3124 insertions(+), 868 deletions(-)
 create mode 100644 arch/x86/include/asm/xor_avx.h
 create mode 100644 lib/raid6/recov_ssse3.c

--Sig_/3UVawm27M7Z192J0WLvB/Jn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7xYXjnsnt1WYoG5AQLGTg/9Ffg4c6CnRAf8mqvCl3tNAkJTKqq7vto0
BIOCWrjTC9RD74iEXTDYsirNc4gkinbFOCcOs/OiHbqyjvHYnpsgjsbKdiIGxHgM
uhY78xOc78YQ43W32crfxk3NhQvV3LOiTE9rzf+5GTbzBYO6Qv9qZ3h3tzczPGjE
El/NJSNdtmONH5Yc/e1KV7kW1czEBCz0d+Z1jjKqfQ8feR8jHZnGYEg5BC8NTrcH
m5dtOD0mMKXv4wZUpoz3mw0GOy2wh1mQvSNYDpK7XIh+N6kfoprNNViD8Ewa/GSk
C0unrgV10n56m5qv5/FMTf3uJ3DVTrCxLqrPmQSTJ670JGoPPCttqJC1P4guu7yB
b435Lqm5CEl7d+ixRDVKf1nK/+y7zYcOytLU1XhesQ+Gwh0I467BsCV2FkMtwyoU
1cZIQfVj2J26e6JpU1Ik6Apm5SLPQ5SXdmXZAm9fM20yL8kiNFa/cp8iJ/uLimCq
Vt0VVcB2YisvqyQYNepEh5gMjXphEl2U8aP7vnKm9oO/n7fpA7Tja8P4CL7RO3+W
lisi5rZD6wUi5Z8bWmO06fRLRfox6Y6tJR7ujKNAIvEY3VN3PfON7s9ni1Fs0Fdl
LQgfR3pu96NOEk++e0ZMfd1Wm3jtcXP/iTw/ZjWMJ9D9QhaeYRcU5/OPrHBe7b0N
uvA/yR/XTyY=
=/2w9
-----END PGP SIGNATURE-----

--Sig_/3UVawm27M7Z192J0WLvB/Jn--
