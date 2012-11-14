Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab2KNGzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:55:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:54781 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2KNGzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:55:38 -0500
Date: Wed, 14 Nov 2012 17:55:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hugh Dickins <hughd@google.com>
Subject: Re: linux-next: Tree for Nov 14
Message-Id: <20121114175528.819d9ac5b2582053b5de4b99@canb.auug.org.au>
In-Reply-To: <20121113213742.292f3ace.akpm@linux-foundation.org>
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
	<20121113213742.292f3ace.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Nov_2012_17_55_28_+1100_LQm7FZCK+glKeWpq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Nov_2012_17_55_28_+1100_LQm7FZCK+glKeWpq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 13 Nov 2012 21:37:42 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> It would help if the old sched/numa code wasn't in -next while you're
> away.  That would give me a clean run at 3.7 and will make it easier
> for others to integrate and test the four(!) different
> autoschednumacore implementations on top of linux-next.
>=20
> Pretty please?

So, your understanding is that the "old sched/numa code" won't (and
shouldn't) be merged into Linus' tree (for v3.7, or ever)?

In that case, what I can do is give you a tree that is the same as
akpm-base but with one of the merges in the tip tree reverted (and, in
fact, I could push that into akpm-base to make things easier for you).
I guess that would be the merge of the numa/core branch which would
result in the following commits being reverted:

Andrea Arcangeli (1):
      numa, mm: Support NUMA hinting page faults from gup/gup_fast

Gerald Schaefer (1):
      sched, numa, mm, s390/thp: Implement pmd_pgprot() for s390

Ingo Molnar (2):
      mm/pgprot: Move the pgprot_modify() fallback definition to mm.h
      sched, numa, mm: Add NUMA_MIGRATION feature flag

Lee Schermerhorn (3):
      mm/mpol: Add MPOL_MF_NOOP
      mm/mpol: Check for misplaced page
      mm/mpol: Add MPOL_MF_LAZY

Peter Zijlstra (17):
      sched, numa, mm: Make find_busiest_queue() a method
      sched, numa, mm: Describe the NUMA scheduling problem formally
      mm/thp: Preserve pgprot across huge page split
      mm/mpol: Make MPOL_LOCAL a real policy
      mm/mpol: Create special PROT_NONE infrastructure
      mm/migrate: Introduce migrate_misplaced_page()
      mm/mpol: Use special PROT_NONE to migrate pages
      sched, numa, mm: Introduce tsk_home_node()
      sched, numa, mm/mpol: Make mempolicy home-node aware
      sched, numa, mm: Introduce sched_feat_numa()
      sched, numa, mm: Implement THP migration
      sched, numa, mm: Implement home-node awareness
      sched, numa, mm: Introduce last_nid in the pageframe
      sched, numa, mm/mpol: Add_MPOL_F_HOME
      sched, numa, mm: Add fault driven placement and migration policy
      sched, numa, mm: Implement constant, per task Working Set Sampling (W=
SS) rate
      sched, numa, mm: Implement slow start for working set sampling

Ralf Baechle (1):
      sched, numa, mm, MIPS/thp: Add pmd_pgprot() implementation

Rik van Riel (6):
      mm/generic: Only flush the local TLB in ptep_set_access_flags()
      x86/mm: Only do a local tlb flush in ptep_set_access_flags()
      x86/mm: Introduce pte_accessible()
      mm: Only flush the TLB when clearing an accessible pte
      sched, numa, mm: Add credits for NUMA placement
      x86/mm: Completely drop the TLB flush from ptep_set_access_flags()

 CREDITS                                  |    1 -
 Documentation/scheduler/numa-problem.txt |  230 ------------
 arch/mips/include/asm/pgtable.h          |    2 -
 arch/s390/include/asm/pgtable.h          |   13 -
 arch/sh/mm/Kconfig                       |    1 -
 arch/x86/include/asm/pgtable.h           |    7 -
 arch/x86/mm/pgtable.c                    |    8 +-
 include/asm-generic/pgtable.h            |    4 -
 include/linux/huge_mm.h                  |   19 -
 include/linux/init_task.h                |    8 -
 include/linux/mempolicy.h                |    8 -
 include/linux/migrate.h                  |    7 -
 include/linux/migrate_mode.h             |    3 -
 include/linux/mm.h                       |  122 +++----
 include/linux/mm_types.h                 |   10 -
 include/linux/mmzone.h                   |   14 +-
 include/linux/page-flags-layout.h        |   83 -----
 include/linux/sched.h                    |   44 +--
 include/uapi/linux/mempolicy.h           |   17 +-
 init/Kconfig                             |   14 -
 kernel/sched/core.c                      |   77 +---
 kernel/sched/debug.c                     |    3 -
 kernel/sched/fair.c                      |  579 ++------------------------=
----
 kernel/sched/features.h                  |   14 -
 kernel/sched/sched.h                     |   36 --
 kernel/sysctl.c                          |   45 +--
 mm/huge_memory.c                         |  251 +++----------
 mm/memory.c                              |  127 +------
 mm/mempolicy.c                           |  204 ++---------
 mm/migrate.c                             |   87 +----
 mm/mprotect.c                            |   31 +-
 mm/pgtable-generic.c                     |    9 +-
 32 files changed, 209 insertions(+), 1869 deletions(-)

Does that sound like what you need?

If Ingo hasn't removed/reverted that branch tomorrow, I can do this
revert again just after merging the tip tree.

> Also, I need to get a fresh mmotm into -next tomorrow.  Don't do
> anything until I've pulled that rabbit out of the hat :)

No worries.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__14_Nov_2012_17_55_28_+1100_LQm7FZCK+glKeWpq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQo0BgAAoJEECxmPOUX5FEj2IP+QH9HuVajxfqxnJ0sspV7dvw
Rnq1dr9XHsObkSozawg5ZkjFlDENwjdh4ctoZRluZd+Z5d9TqeR2qFkKd7+2DFPG
QADCvCzq1YF4c51+akq51vHHHHN74b4tc7rrH5C858eckgZNRE6334F+LWMLFYce
KHJ12RCoZe2ZLPhlEuZIGXqJkWBb3TOCXtcmD/xIau9FpBake3uac8KojaQRyNHc
VXSh+QdElFJXbhAM5J4ETmqHfrxPIgFv73uKwheyNYDQ8TE4G46VnVJTzg2HBJse
T93gD04YsobQBsMTo2u7vH+yqae9cNzgjTxT0uGI20MiAwttuGMTJH0hj1GC6N9X
8htb3H+IPZTLpCHaLi09lvg5CJrJd1aVdC8WopzwdLnuC8RSiOGS3CULEixculRr
A7vfPnBFj+V8NBOwkQSQDJZrybPIKi1Cp/mjINwLbrZNUz5PLvsXf2KyyuXl44p/
8lRMZXDUWnfzsor2si7esFC97G9vfi8yYEyps20EkGimUosML4H+PEocmLhtj+/a
wi1Jsv/rCRGNKz3rpdPIHXhCpnMyDiaIaHCWy+uliyfpjjtKY0N8fmAEnW3rIjDX
EgFU+oklhvWqRTZijkiH+E38R0HA2QS6xRReH0b8xwfMQiI71k+AIR6ulcLytGfy
If6q2AJQb1Jcn+8yjZPa
=ab9o
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Nov_2012_17_55_28_+1100_LQm7FZCK+glKeWpq--
