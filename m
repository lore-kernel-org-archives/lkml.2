Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab2BTRWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:22:40 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43752 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab2BTRWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:22:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.204.156.129 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH v2 00/22] mm: lru_lock splitting
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 20 Feb 2012 21:22:35 +0400
Message-ID: <20120220171138.22196.65847.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There complete patch-set with my lru_lock splitting
plus all related preparations and cleanups rebased to next-20120210

git: https://github.com/koct9i/linux/commits/lruvec

main changes:
* rebase
* sed -e 's/book/lruvec/g'
* fixed locking
* some cleaning and reordering

---

Konstantin Khlebnikov (22):
      memcg: rework inactive_ratio logic
      memcg: fix page_referencies cgroup filter on global reclaim
      memcg: use vm_swappiness from current memcg
      mm: drain percpu lru add/rotate page-vectors on cpu hot-unplug
      mm: replace per-cpu lru-add page-vectors with page-lists
      mm: deprecate pagevec lru-add functions
      mm: rename lruvec->lists into lruvec->pages_lru
      mm: add lruvec->pages_count
      mm: link lruvec with zone and node
      mm: unify inactive_list_is_low()
      mm: add lruvec->reclaim_stat
      mm: kill struct mem_cgroup_zone
      mm: move page-to-lruvec translation upper
      mm: push lruvec into update_page_reclaim_stat()
      mm: push lruvecs from pagevec_lru_move_fn() to iterator
      mm: introduce lruvec locking primitives
      mm: handle lruvec relocks on lumpy reclaim
      mm: handle lruvec relocks in compaction
      mm: handle lruvec relock in memory controller
      mm: optimize putback for 0-order reclaim
      mm: free lruvec in memcgroup via rcu
      mm: split zone->lru_lock


 fs/mpage.c                 |   21 +-
 fs/nfs/dir.c               |   10 -
 include/linux/memcontrol.h |   62 -------
 include/linux/mm.h         |   37 ++++
 include/linux/mm_inline.h  |   19 +-
 include/linux/mmzone.h     |   19 +-
 include/linux/pagevec.h    |    4 
 include/linux/swap.h       |    5 -
 mm/compaction.c            |   30 ++-
 mm/huge_memory.c           |   10 +
 mm/internal.h              |  226 +++++++++++++++++++++++++
 mm/memcontrol.c            |  320 ++++++++++++++---------------------
 mm/page_alloc.c            |   19 +-
 mm/readahead.c             |   15 +-
 mm/swap.c                  |  256 ++++++++++++++++------------
 mm/vmscan.c                |  402 +++++++++++++++++++++-----------------------
 16 files changed, 821 insertions(+), 634 deletions(-)

-- 
Signature
