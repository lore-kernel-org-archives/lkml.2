Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab1JZPSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:18:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58048 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933076Ab1JZPSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:18:14 -0400
Date: Wed, 26 Oct 2011 18:18:00 +0300 (EEST)
From: Pekka Enberg <penberg@cs.helsinki.fi>
X-X-Sender: penberg@tux.localdomain
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, cl@linux.com
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] slab changes for v3.2
Message-ID: <alpine.LFD.2.02.1110261817200.2567@tux.localdomain>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest slab tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

There's fixes, optimizations, and cleanups in the tree. The most interesting
ones are:

   - SLUB per-CPU partial list optimization from Christoph Lameter

   - /proc/slabinfo access restriction from Vasiliy Kulikov

Please note that the latter changes ABI to require root access that was agreed
to by almost everybody.

 			Pekka

The following changes since commit 3cfef9524677a4ecb392d6fbffe6ebce6302f1d4:

   Merge branch 'core-locking-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2011-10-26 16:17:32 +0200)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

Alex Shi (2):
       slub: correct comments error for per cpu partial
       slub: Discard slab page when node partial > minimum partial number

Alex,Shi (1):
       slub: Code optimization in get_partial_node()

Christoph Lameter (7):
       slub: free slabs without holding locks
       slub: Remove useless statements in __slab_alloc
       slub: Prepare inuse field in new_slab()
       slub: pass kmem_cache_cpu pointer to get_partial()
       slub: return object pointer from get_partial() / new_slab().
       slub: per cpu cache for partial pages
       slub: update slabinfo tools to report per cpu partial list statistics

Jason Liu (1):
       slub: doc: update the slabinfo.c file path

Pekka Enberg (2):
       Merge branch 'slab/urgent' into slab/next
       Merge branches 'slab/next' and 'slub/partial' into slab/for-linus

Sebastian Andrzej Siewior (2):
       slab: use print_hex_dump
       slub: use print_hex_dump

Shaohua Li (1):
       slub: explicitly document position of inserting slab to partial list

Thomas Jarosch (1):
       tools, slub: Fix off-by-one buffer corruption after readlink() call

Vasiliy Kulikov (1):
       mm: restrict access to slab files under procfs and sysfs

  Documentation/vm/00-INDEX |    2 -
  include/linux/mm_types.h  |   14 +-
  include/linux/slub_def.h  |    4 +
  mm/slab.c                 |   19 +-
  mm/slub.c                 |  558 +++++++++++++++++++++++++++++++--------------
  tools/slub/slabinfo.c     |   10 +-
  6 files changed, 425 insertions(+), 182 deletions(-)
