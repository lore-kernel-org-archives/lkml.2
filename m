Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031202Ab2CVV4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:56:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57572 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2CVV4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:56:16 -0400
Subject: [PATCH v6 0/7] mm: some simple cleanups
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Fri, 23 Mar 2012 01:56:12 +0400
Message-ID: <20120322214944.27814.42039.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I left here only small and simple patches, some of them already acked.

Patch for lru filters in __isolate_lru_page() was reworked again: we can remove all
these checks, because lumpy isolation in shrink_active_list() now forbidden.

---

Hugh Dickins (2):
      mm/memcg: scanning_global_lru means mem_cgroup_disabled
      mm/memcg: move reclaim_stat into lruvec

Konstantin Khlebnikov (5):
      mm: push lru index into shrink_[in]active_list()
      mm: mark mm-inline functions as __always_inline
      mm: remove lru type checks from __isolate_lru_page()
      mm/memcg: kill mem_cgroup_lru_del()
      mm/memcg: use vm_swappiness from target memory cgroup


 include/linux/memcontrol.h |   14 ------
 include/linux/mm_inline.h  |    8 ++-
 include/linux/mmzone.h     |   39 +++++++---------
 include/linux/swap.h       |    2 -
 mm/compaction.c            |    4 +-
 mm/memcontrol.c            |   32 +++----------
 mm/page_alloc.c            |    8 ++-
 mm/swap.c                  |   14 ++----
 mm/vmscan.c                |  105 +++++++++++++++-----------------------------
 9 files changed, 74 insertions(+), 152 deletions(-)

-- 
Signature
