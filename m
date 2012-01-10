Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab2AJPDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 10:03:13 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:41395 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239Ab2AJPDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 10:03:11 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/2] mm: memcg reclaim integration followups
Date: Tue, 10 Jan 2012 16:02:50 +0100
Message-Id: <1326207772-16762-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are two patches based on memcg-aware global reclaim, which I
dropped from the initial series to focus on the exclusive-lru changes.

The first one is per-memcg reclaim statistics.  For now, they include
only pages scanned and pages reclaimed, separately for direct reclaim
and kswapd, as well as separately for internal pressure or reclaim due
to parental memcgs.

The second one is integrating soft limit reclaim into the now
memcg-aware global reclaim path.  It kills a lot of code and performs
better as far as I have tested it.  Furthermore, Ying is working on
turning soft limits into guarantees, as discussed in Prague, and this
patch is also in preparation for that.

Sorry for the odd point in time to submit this, I guess this will mean
3.4 at the earliest.  But the soft limit removal is a bit heavy weight
so it's probably easier conflict-wise to have it at the bottom of the
-mm stack.

 Documentation/cgroups/memory.txt |    4 +
 include/linux/memcontrol.h       |   28 ++-
 mm/memcontrol.c                  |  482 +++++++++-----------------------------
 mm/vmscan.c                      |   87 ++------
 4 files changed, 144 insertions(+), 457 deletions(-)
