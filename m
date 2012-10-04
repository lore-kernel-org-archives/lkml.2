Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750932Ab2JDRzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:55:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49219 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2JDRzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:55:51 -0400
Date: Thu, 4 Oct 2012 20:55:39 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] SLAB changes for v3.7-rc0
Message-ID: <alpine.LFD.2.02.1210042055190.2119@tux.localdomain>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

New and noteworthy:

  * More SLAB allocator unification patches from Christoph Lameter and
    others.  This paves the way for slab memcg patches that hopefully
    will land in v3.8.

  * SLAB tracing improvements from Ezequiel Garcia.

  * Kernel tainting upon SLAB corruption from Dave Jones.

  * Miscellanous SLAB allocator bug fixes and improvements from various
    people.

			Pekka

------------------>
The following changes since commit 56d92aa5cf7c96c70f81d0350c94faf46a9fb76d:

  Merge tag 'stable/for-linus-3.7-x86-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen (2012-10-02 22:09:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

Andrew Morton (1):
      mm/slab_common.c: cleanup

Christoph Lameter (17):
      slub: Take node lock during object free checks
      mm/slub: Add debugging to verify correct cache use on kmem_cache_free()
      mm/slub: Use kmem_cache for the kmem_cache structure
      mm/slab_common: Improve error handling in kmem_cache_create
      mm/sl[aou]b: Move list_add() to slab_common.c
      mm/sl[aou]b: Extract a common function for kmem_cache_destroy
      mm/sl[aou]b: Use "kmem_cache" name for slab cache with kmem_cache struct
      mm/sl[aou]b: Move freeing of kmem_cache structure to common code
      mm/sl[aou]b: Get rid of __kmem_cache_destroy
      mm/sl[aou]b: Move duping of slab name to slab_common.c
      mm/sl[aou]b: Do slab aliasing call from common code
      mm/sl[aou]b: Move sysfs_slab_add to common
      mm/sl[aou]b: Move kmem_cache allocations into common code
      mm/sl[aou]b: Shrink __kmem_cache_create() parameter lists
      mm/sl[aou]b: Move kmem_cache refcounting to common code
      slub: Zero initial memory segment for kmem_cache and kmem_cache_node
      slab: Only define slab_error for DEBUG

Dave Jones (1):
      mm, sl[au]b: Taint kernel when we detect a corrupted slab

David Rientjes (3):
      mm, slab: remove dflags
      mm, slab: remove page_get_cache
      mm, slob: fix build breakage in __kmalloc_node_track_caller

Ezequiel Garcia (11):
      mm: Use __do_krealloc to do the krealloc job
      mm, slob: Use NUMA_NO_NODE instead of -1
      mm, slab: Remove silly function slab_buffer_size()
      mm, slob: Add support for kmalloc_track_caller()
      mm, slab: Replace 'caller' type, void* -> unsigned long
      mm, slab: Match SLAB and SLUB kmem_cache_alloc_xxx_trace() prototype
      mm, slab: Rename __cache_alloc() -> slab_alloc()
      mm, slub: Rename slab_alloc() -> slab_alloc_node() to match SLAB
      mm/slab: Fix typo _RET_IP -> _RET_IP_
      mm/slab: Fix kmem_cache_alloc_node_trace() declaration
      mm/slab: Fix kmem_cache_alloc_node_trace() declaration

Fengguang Wu (1):
      slub: init_kmem_cache_cpus() and put_cpu_partial() can be static

Glauber Costa (1):
      slub: use free_page instead of put_page for freeing kmalloc allocation

Joonsoo Kim (1):
      slub: reduce failure of this_cpu_cmpxchg in put_cpu_partial() after unfreezing

Michael Wang (1):
      slab: fix the DEADLOCK issue on l3 alien lock

Michel Lespinasse (1):
      slab: do not call compound_head() in page_get_cache()

Pekka Enberg (6):
      Revert "mm/slab_common.c: cleanup"
      Revert "mm/sl[aou]b: Move sysfs_slab_add to common"
      Revert "mm/slab: Fix kmem_cache_alloc_node_trace() declaration"
      Merge branch 'slab/next' into slab/for-linus
      Merge branch 'slab/common-for-cgroups' into slab/for-linus
      Merge branch 'slab/tracing' into slab/for-linus

Shuah Khan (1):
      mm/slab: restructure kmem_cache_create() debug checks

Tetsuo Handa (1):
      slab: Fix build failure in __kmem_cache_create()

 include/linux/slab.h     |    6 +-
 include/linux/slab_def.h |   27 ++---
 include/linux/slob_def.h |    6 +-
 mm/slab.c                |  348 +++++++++++++++++++---------------------------
 mm/slab.h                |   19 +++-
 mm/slab_common.c         |  159 +++++++++++++++------
 mm/slob.c                |   91 +++++++-----
 mm/slub.c                |  208 +++++++++++++---------------
 mm/util.c                |   35 +++--
 9 files changed, 463 insertions(+), 436 deletions(-)
