Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab2FLPoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:44:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57586 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2FLPjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:39:44 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tejun@google.com, agk@redhat.com,
        dan.j.williams@intel.com
Subject: [Bcache v14 00/16]
Date: Tue, 12 Jun 2012 08:39:06 -0700
Message-Id: <1339515562-14638-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Augh. I had about two pages written out about what's changed since the
last version, and then I accidentally reran git format-patch instead of
git send-email, and poof.

stab. stab. stab.

So, here's the shortlog since the last version instead.

Dan Williams (5):
      bcache: disable lockdep, enable CONFIG_BCACHE=m
      bcache: drop select COMPACTION
      bcache: fix symlink removal
      bcache: move to drivers/md/
      bcache: uplevel allocation of 'cached_dev' and 'cache'

Kent Overstreet (81):
      bcache: Add format string checking to cache_set_error()
      bcache: Switch error macros to do {} while
      bcache: Check queue_max_segments() in __bio_max_sector()
      bcache: Document some things and incorporate some review feedback
      bcache: Fix a bug in submit_bbio_split()
      bcache: sprint_string_list() -> snprint_string_list()
      bcache: Kill hprint()
      bcache: Review feedback
      bcache: Kill popcount()
      bcache: Take out some nested functions
      bcache: Documentation and coding style from review feedback
      bcache: Kill contamination
      bcache: BDEV_DATA_START
      bcache: BUCKET_(GC|DISK)_GEN_MAX
      bcache: MAX_IN_FLIGHT_DISCARDS
      bcache: Capitalize constants
      bcache: Convert macros to inline functions
      bcache: Fix a deadlock between gc and allocation
      bcache: Change pop_bucket() to take gc_mark instead of prio
      bcache: Garbage collection cleanups
      bcache: Split out gc mark and sectors used
      bcache: Add looping macro for cached btree nodes
      bcache: rename do_bio_hook() -> search_alloc()
      bcache: Fix for discards in writeback mode
      bcache: Don't unnecessarily init btree_op closure
      bcache: Don't reissue no data bio to flash only dev
      bcache: Refactor request path/control flow
      bcache: Kill some dependencies on bcache_device ptr
      bcache: Move bcache_device pointer to struct search
      bcache: Move bio_insert_done to btree_op
      bcache: Move cache_bio, skip to btree_op
      bcache: Abstract out keybuf code
      bcache: Pass write_prio to pop_bucket(), rework reserve handling
      bcache: Factor out mca_reinit()
      bcache: Change mca_reap() to check page_order
      bcache: Refactor mca_bucket_alloc()
      bcache: Factor out cannibalize_bucket()
      bcache: Prefix all external symbols with bch_
      bcache: Convert to struct closure_waitlist
      bcache: Kill bch_bbio_kmalloc(), bi_destructor use
      bcache: Kill bio_split_front() and other upstreamed code
      remove some bio_puts() for new bio_reset() semantics
      bcache: fix bio_map()
      bcache: Kill submit_bio_split(), submit_bbio_split()
      bcache: Kill bio passthrough split code
      bcache: Use bio_clone_bioset()
      bcache: Kill uuid_bio
      bcache: Kill unnecessary bio_max_sectors() checks
      bcache: Better naming in cached_dev_cache_miss()
      bcache: Kill bio_get() in btree_bio_init()
      bcache: Kill prio_bio
      bcache: Get refcount when bio is submitted, not when it's split
      bcache: Get refcount at the same time io is submitted
      closures: closure_call()
      bcache: Refactor flash_dev_make_request()
      closures: continue_at_nobarrier()
      bcache: Refactor request_(read|write)()
      bcache: Get rid of set_closure_fn() in read_dirty()
      bcache: Kill compat code for old kernels
      bcache: next() -> bkey_next()
      bcache: Document auxiliary search trees
      bcache: Add bch_alloc_sectors()
      bcache: Rename KEY_DEV() -> KEY_INODE(), introduce KEY_OFFSET()
      bcache: Fix for CONFIG_TRACING=y
      bcache: Clean up, comment bio_insert()
      bcache: Move debugfs file to cache_set
      bcache: Rename vars for consistency
      bcache: Writeback refactoring/locking improvements
      bcache: Factor out ratelimit code
      closures: Destructors
      closures: closure_sleep() -> closure_delay()
      closures: closure_trylock_call
      closure_sleep() -> closure_delay()
      bcache: Fix readahead past end of the device
      bcache: Convert background writeback to use a closure
      bcache: Reorder writeback code
      bcache: Fix dirty data accounting
      bcache: Better bset stats
      bcache: Fix detaching when unregistering cache set
      bcache: Moving garbage collector
      bcache: Update cgroup code

 drivers/md/bcache/Makefile    |   12 +-
 drivers/md/bcache/alloc.c     |  386 ++++++++-------
 drivers/md/bcache/bcache.h    |  429 ++++++++++------
 drivers/md/bcache/bset.c      |  334 ++++++++-----
 drivers/md/bcache/bset.h      |  125 ++---
 drivers/md/bcache/btree.c     |  946 ++++++++++++++++++++++--------------
 drivers/md/bcache/btree.h     |  108 +++--
 drivers/md/bcache/debug.c     |  112 ++---
 drivers/md/bcache/debug.h     |   39 +-
 drivers/md/bcache/io.c        |  128 ++---
 drivers/md/bcache/journal.c   |   93 ++--
 drivers/md/bcache/journal.h   |   20 +-
 drivers/md/bcache/movinggc.c  |  245 ++++++++++
 drivers/md/bcache/request.c   | 1077 ++++++++++++++++++-----------------------
 drivers/md/bcache/request.h   |   30 +-
 drivers/md/bcache/stats.c     |   50 +-
 drivers/md/bcache/stats.h     |   22 +-
 drivers/md/bcache/super.c     |  682 +++++++++++++-------------
 drivers/md/bcache/sysfs.c     |  228 ++++-----
 drivers/md/bcache/sysfs.h     |    8 -
 drivers/md/bcache/util.c      |  235 ++-------
 drivers/md/bcache/util.h      |   80 +--
 drivers/md/bcache/writeback.c |  534 ++++++++------------
 include/linux/closure.h       |   88 ++--
 include/trace/events/bcache.h |   32 +-
 lib/closure.c                 |   26 +-
 26 files changed, 3177 insertions(+), 2892 deletions(-)
