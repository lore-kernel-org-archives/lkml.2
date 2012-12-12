Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab2LLVof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:44:35 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:36194 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815Ab2LLVoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:44:34 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 0/8] page reclaim bits
Date: Wed, 12 Dec 2012 16:43:32 -0500
Message-Id: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I had these in my queue and on test machines for a while, but they got
deferred over and over, partly because of the kswapd issues.  I hope
it's not too late for 3.8, they should be fairly straight forward.

#1 takes the anon workingset protection with plenty file cache from
global reclaim, which was just merged into 3.8, and generalizes it to
include memcg reclaim.

#2-#6 are get_scan_count() fixes and cleanups.

#7 fixes reclaim-for-compaction to work against zones, not lruvecs,
since that is what compaction works against.  Practical impact only on
memcg setups, but confusing for everybody.

#8 puts ksm pages that are copied-on-swapin into their own separate
anon_vma.

Thanks!

 include/linux/swap.h |   2 +-
 mm/ksm.c             |   6 --
 mm/memory.c          |   5 +-
 mm/vmscan.c          | 268 +++++++++++++++++++++++++++----------------------
 4 files changed, 152 insertions(+), 129 deletions(-)

