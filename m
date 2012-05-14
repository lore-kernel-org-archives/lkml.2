Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab2ENE6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 00:58:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44258 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2ENE6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 00:58:42 -0400
Date: Sun, 13 May 2012 21:58:18 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] mm/memcg: trivia and more lruvec
Message-ID: <alpine.LSU.2.00.1205132152530.6148@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a trivial renaming of two functions in Konstantin's patches;
some trivial little bits and pieces from my patches to vmscan.c now
on top of Konstantin's version; and the slightly more substantial
(but still functionally no different) use of lruvec instead of zone
pointer in lru_list functions.  Which I think takes us up to the
point beyond which Konstantin and I will need to settle differences
before proceeding further.

These I've diffed against 3.4.0-rc6-next-20120511, minus Ying's
"memcg: add mlock statistic in memory.stat" (and your fix to it)
that we already asked you to revert for now.

1/3 mm/memcg: get_lru_size not get_lruvec_size
2/3 mm: trivial cleanups in vmscan.c
3/3 mm/memcg: apply add/del_page to lruvec

 include/linux/memcontrol.h |   36 ++---------
 include/linux/mm_inline.h  |   20 +++---
 include/linux/swap.h       |    4 -
 mm/compaction.c            |    5 +
 mm/huge_memory.c           |    8 +-
 mm/memcontrol.c            |  111 +++++++++--------------------------
 mm/swap.c                  |   85 +++++++++++++-------------
 mm/vmscan.c                |   97 ++++++++++++++----------------
 8 files changed, 147 insertions(+), 219 deletions(-)

Hugh
