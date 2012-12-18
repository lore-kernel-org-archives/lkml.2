Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2LRMya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 07:54:30 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:56688 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab2LRMy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 07:54:28 -0500
X-Greylist: delayed 1478 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 07:54:28 EST
Date: Tue, 18 Dec 2012 14:29:43 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] SLAB changes for v3.8
Message-ID: <alpine.LFD.2.02.1212181429280.2013@tux.localdomain>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

This contains preparational work from Christoph Lameter and Glauber Costa for
SLAB memcg and cleanups and improvements from Ezequiel Garcia and Joonsoo Kim.

Please note that the SLOB cleanup commit from Arnd Bergmann already
appears in your tree but I had also merged it myself which is why it
shows up in the shortlog.

			Pekka

------------------>
The following changes since commit 848b81415c42ff3dc9a4204749087b015c37ef66:

  Merge branch 'akpm' (Andrew's patch-bomb) (2012-12-17 20:58:12 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

Arnd Bergmann (1):
      mm/slob: use min_t() to compare ARCH_SLAB_MINALIGN

Christoph Lameter (6):
      slub: Use correct cpu_slab on dead cpu
      slab: Simplify bootstrap
      mm, sl[au]b: create common functions for boot slab creation
      slub: Use statically allocated kmem_cache boot structure for bootstrap
      slab: Use the new create_boot_cache function to simplify bootstrap
      mm/sl[aou]b: Common alignment code

Ezequiel Garcia (4):
      mm/slob: Drop usage of page->private for storing page-sized allocations
      mm/slob: Use object_size field in kmem_cache_size()
      mm/sl[aou]b: Move common kmem_cache_size() to slab.h
      mm/slob: Use free_page instead of put_page for page-size kmalloc allocations

Glauber Costa (5):
      mm/sl[au]b: Move slabinfo processing to slab_common.c
      mm/sl[au]b: Move print_slabinfo_header to slab_common.c
      sl[au]b: Process slabinfo_show in common code
      slub: Commonize slab_cache field in struct page
      slab: Ignore internal flags in cache creation

Joonsoo Kim (1):
      slub: remove one code path and reduce lock contention in __slab_free()

Pekka Enberg (3):
      Merge branch 'slab/procfs' into slab/next
      Merge branch 'slab/procfs' into slab/for-linus
      Merge branch 'slab/next' into slab/for-linus

Randy Dunlap (1):
      mm: fix slab.c kernel-doc warnings

 include/linux/mm_types.h |    7 +-
 include/linux/slab.h     |    9 ++-
 include/linux/slab_def.h |    6 +-
 mm/slab.c                |  289 +++++++++++---------------------------------
 mm/slab.h                |   53 ++++++++
 mm/slab_common.c         |  182 ++++++++++++++++++++++++++++-
 mm/slob.c                |   46 ++-----
 mm/slub.c                |  301 +++++++++++-----------------------------------
 8 files changed, 402 insertions(+), 491 deletions(-)
