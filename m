Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab2B2JPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:15:43 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34834 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab2B2JPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:15:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.204.149.209 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH v4 ch1 0/7] mm: some cleanup/rework before lru_lock splitting
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Wed, 29 Feb 2012 13:15:33 +0400
Message-ID: <20120229090748.29236.35489.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is some cleanup/rework patches from Hugh Dickins and me.
This is about one-third of my current patchset,
so I prefer to merge this set before going further.

---

Hugh Dickins (2):
      mm/memcg: scanning_global_lru means mem_cgroup_disabled
      mm/memcg: move reclaim_stat into lruvec

Konstantin Khlebnikov (5):
      mm: rework __isolate_lru_page() file/anon filter
      mm: push lru index into shrink_[in]active_list()
      mm: rework reclaim_stat counters
      mm/memcg: rework inactive_ratio calculation
      mm/memcg: use vm_swappiness from target memory cgroup


 include/linux/memcontrol.h |   25 -----
 include/linux/mmzone.h     |   43 ++++----
 include/linux/swap.h       |    2 
 mm/compaction.c            |    5 +
 mm/memcontrol.c            |   86 ++++-------------
 mm/page_alloc.c            |   50 ----------
 mm/swap.c                  |   40 ++------
 mm/vmscan.c                |  225 ++++++++++++++++++++++----------------------
 mm/vmstat.c                |    6 -
 9 files changed, 173 insertions(+), 309 deletions(-)

-- 
Signature
