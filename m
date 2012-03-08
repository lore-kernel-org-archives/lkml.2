Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab2CHSEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:04:08 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51927 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab2CHSEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:04:04 -0500
Subject: [PATCH v5 0/7] mm: some cleanup/rework before lru_lock splitting
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 08 Mar 2012 22:03:43 +0400
Message-ID: <20120308175752.27621.54781.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v5:
* rebase to next-20120308
* reworked cleanup for __isolate_lru_page()
* bloat-o-meter results for each patch

---

Hugh Dickins (2):
      mm/memcg: scanning_global_lru means mem_cgroup_disabled
      mm/memcg: move reclaim_stat into lruvec

Konstantin Khlebnikov (5):
      mm: push lru index into shrink_[in]active_list()
      mm: rework __isolate_lru_page() page lru filter
      mm: rework reclaim_stat counters
      mm/memcg: rework inactive_ratio calculation
      mm/memcg: use vm_swappiness from target memory cgroup


 include/linux/memcontrol.h |   25 -----
 include/linux/mm_inline.h  |    2 
 include/linux/mmzone.h     |   51 ++++-----
 include/linux/swap.h       |    2 
 mm/compaction.c            |    4 -
 mm/memcontrol.c            |   86 ++++------------
 mm/page_alloc.c            |   50 ---------
 mm/swap.c                  |   43 +++-----
 mm/vmscan.c                |  241 +++++++++++++++++++++-----------------------
 mm/vmstat.c                |    6 -
 10 files changed, 178 insertions(+), 332 deletions(-)

-- 
Signature
