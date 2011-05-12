Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab1ELOys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:54:48 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:45998 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab1ELOyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:54:45 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [rfc patch 0/6] mm: memcg naturalization
Date: Thu, 12 May 2011 16:53:52 +0200
Message-Id: <1305212038-15445-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Here is a patch series that is a result of the memcg discussions on
LSF (memcg-aware global reclaim, global lru removal, struct
page_cgroup reduction, soft limit implementation) and the recent
feature discussions on linux-mm.

The long-term idea is to have memcgs no longer bolted to the side of
the mm code, but integrate it as much as possible such that there is a
native understanding of containers, and that the traditional !memcg
setup is just a singular group.  This series is an approach in that
direction.

It is a rather early snapshot, WIP, barely tested etc., but I wanted
to get your opinions before further pursuing it.  It is also part of
my counter-argument to the proposals of adding memcg-reclaim-related
user interfaces at this point in time, so I wanted to push this out
the door before things are merged into .40.

The patches are quite big, I am still looking for things to factor and
split out, sorry for this.  Documentation is on its way as well ;)

#1 and #2 are boring preparational work.  #3 makes traditional reclaim
in vmscan.c memcg-aware, which is a prerequisite for both removal of
the global lru in #5 and the way I reimplemented soft limit reclaim in
#6.

The diffstat so far looks like this:

 include/linux/memcontrol.h  |   84 +++--
 include/linux/mm_inline.h   |   15 +-
 include/linux/mmzone.h      |   10 +-
 include/linux/page_cgroup.h |   35 --
 include/linux/swap.h        |    4 -
 mm/memcontrol.c             |  860 +++++++++++++------------------------------
 mm/page_alloc.c             |    2 +-
 mm/page_cgroup.c            |   39 +--
 mm/swap.c                   |   20 +-
 mm/vmscan.c                 |  273 +++++++--------
 10 files changed, 452 insertions(+), 890 deletions(-)

It is based on .39-rc7 because of the memcg churn in -mm, but I'll
rebase it in the near future.

Discuss!

	Hannes
