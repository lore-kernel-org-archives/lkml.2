Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab2HATsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:48:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36485 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab2HATsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:48:41 -0400
Date: Wed, 1 Aug 2012 12:48:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Mel Gorman <mgorman@suse.de>
Subject: Linux 3.0.39
Message-ID: <20120801194836.GA9370@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.39 kernel.

All users of the 3.0 kernel series must upgrade.

Many thanks to Mel Gorman for all of the backported performance patches
that he took the time to send in and get merged properly.  That was an
incredible job, everyone using the 3.0-stable tree now owes you a
beverage of your choice when they see you.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/trace/postprocess/trace-vmscan-postprocess.pl |    8=20
 Makefile                                                    |    2=20
 arch/mips/include/asm/thread_info.h                         |    4=20
 arch/mips/kernel/vmlinux.lds.S                              |    3=20
 drivers/base/memory.c                                       |   58 +-
 drivers/md/dm-raid1.c                                       |    2=20
 drivers/md/dm-region-hash.c                                 |    5=20
 fs/btrfs/disk-io.c                                          |    5=20
 fs/cifs/readdir.c                                           |    7=20
 fs/hugetlbfs/inode.c                                        |    3=20
 fs/nfs/internal.h                                           |    2=20
 fs/nfs/write.c                                              |    4=20
 fs/ubifs/sb.c                                               |    8=20
 include/linux/cpuset.h                                      |   47 -
 include/linux/fs.h                                          |   11=20
 include/linux/init_task.h                                   |    8=20
 include/linux/memcontrol.h                                  |    3=20
 include/linux/migrate.h                                     |   23=20
 include/linux/mmzone.h                                      |   14=20
 include/linux/sched.h                                       |    2=20
 include/linux/swap.h                                        |    7=20
 include/trace/events/vmscan.h                               |   85 +++
 kernel/cpuset.c                                             |   63 +-
 kernel/fork.c                                               |    3=20
 kernel/time/ntp.c                                           |    8=20
 mm/compaction.c                                             |   26 -
 mm/filemap.c                                                |   11=20
 mm/hugetlb.c                                                |   13=20
 mm/memcontrol.c                                             |    3=20
 mm/memory-failure.c                                         |    2=20
 mm/memory_hotplug.c                                         |    2=20
 mm/mempolicy.c                                              |   30 -
 mm/migrate.c                                                |  240 ++++++-=
--
 mm/page_alloc.c                                             |  118 +++-
 mm/slab.c                                                   |   13=20
 mm/slub.c                                                   |   40 +
 mm/vmscan.c                                                 |  296 +++++++=
++---
 mm/vmstat.c                                                 |    2=20
 38 files changed, 826 insertions(+), 355 deletions(-)

Aaditya Kumar (1):
      mm: fix lost kswapd wakeup in kswapd_stop()

Alex Shi (2):
      kswapd: avoid unnecessary rebalance after an unsuccessful balancing
      kswapd: assign new_order and new_classzone_idx after wakeup in sleepi=
ng

Artem Bityutskiy (1):
      UBIFS: fix a bug in empty space fix-up

Dave Chinner (3):
      vmscan: add shrink_slab tracepoints
      vmscan: shrinker->nr updates race and go wrong
      vmscan: reduce wind up shrinker->nr when shrinker can't do work

David Daney (1):
      MIPS: Properly align the .data..init_task section.

David Rientjes (2):
      cpusets: avoid looping when storing to mems_allowed if one node remai=
ns set
      cpusets: stall when updating mems_allowed for mempolicy or disjoint n=
odemask

Dimitri Sivanich (1):
      mm/vmstat.c: cache align vm_stat

Greg Kroah-Hartman (1):
      Linux 3.0.39

Hugh Dickins (1):
      mm: test PageSwapBacked in lumpy reclaim

Jeff Layton (1):
      cifs: always update the inode cache with the results from a FIND_*

Johannes Weiner (2):
      mm: vmscan: fix force-scanning small targets without swap
      mm: vmscan: convert global reclaim to per-memcg LRU lists

John Stultz (1):
      ntp: Fix STA_INS/DEL clearing bug

Konstantin Khlebnikov (4):
      vmscan: promote shared file mapped pages
      vmscan: activate executable pages after first usage
      mm/hugetlb: fix warning in alloc_huge_page/dequeue_huge_page_vma
      vmscan: fix initial shrinker size handling

Mel Gorman (12):
      mm: memory hotplug: Check if pages are correctly reserved on a per-se=
ction basis
      mm: reduce the amount of work done when updating min_free_kbytes
      vmscan: abort reclaim/compaction if compaction can proceed
      mm: compaction: allow compaction to isolate dirty pages
      mm: compaction: determine if dirty pages can be migrated without bloc=
king within ->migratepage
      mm: page allocator: do not call direct reclaim for THP allocations wh=
ile compaction is deferred
      mm: compaction: make isolate_lru_page() filter-aware again
      mm: compaction: introduce sync-light migration for use by compaction
      mm: vmscan: when reclaiming for compaction, ensure there are sufficie=
nt free pages available
      mm: vmscan: do not OOM if aborting reclaim to start compaction
      mm: vmscan: check if reclaim should really abort even if compaction_r=
eady() is true for one zone
      cpuset: mm: reduce large amounts of memory barrier related damage v3

Mikulas Patocka (1):
      dm raid1: fix crash with mirror recovery and discard

Minchan Kim (6):
      mm: compaction: trivial clean up in acct_isolated()
      mm: change isolate mode from #define to bitwise type
      mm: compaction: make isolate_lru_page() filter-aware
      mm: zone_reclaim: make isolate_lru_page() filter-aware
      mm: migration: clean up unmap_and_move()
      mm/vmscan.c: consider swap space when deciding whether to continue re=
claim

Rik van Riel (1):
      vmscan: limit direct reclaim for higher order allocations

Shaohua Li (1):
      vmscan: clear ZONE_CONGESTED for zone with good watermark


--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJQGYgUAAoJEDjbvchgkmk+v4cQALsu0JTf/lKu3tcjmpy2ZDNR
vhaEMFZ4J8nC+PgirYV6jjgNm+T0ptSNXnV61M9DJNxRDhDgyP1wITDb4r6WonAs
ScFr6Z4HVXhusF9dVKu0FYCiX5L+JqOKZsi7aeCotk5ESLFyblEDWZXMx9afVjE/
55ogq25BW0UdT+zh64OGO7U0p7X0yxK/3bDpURrPyNAdvD1q0Olq+hjxumaMgn5v
IMXa1iMJi393dr3yPRK/G5kOseT0PwuWARdK9RgU8Uw3vm6jHxlDObxRKvpUrPVP
wQtzSu2OvMWMKzCfS95LvNsidMgXnQTlAMiCtKgbNfb0+CjWJFT8Pjz8QrgX+tun
ha8W2h4z9vCRTr885IUMezcnVQYk4x+T324/8+FJn9Ak1XguDXVucrmTpjAYBzP2
f15GcgLnyGZdBApN5jQe58ha+bhf9xfMGUe8fgAFNzdpOrzV7CBjqt0Kn6uMcvuP
DAwrj7EB6Vh0OAwCllazCEYgxwjjoenXsqbzfS6rf4cc5pCNTtr3LfsgMrmgyxR0
7LxLvje+CxyJ9GSWzX2RHwlyE9NIrCrcyh3wMgQ9hdRihBWpt2Vu9ppPATSw8tQi
CXoFUSLJS3ShwiVg1COb8p2qj7/jqavkrR/3xfSvUyx4C/KUzdHQKcDI/C+PUR8g
6g7ZpapuRwDnzm5BdlmS
=hbjU
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
