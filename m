Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab1ELOyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:54:50 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:45999 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab1ELOyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:54:46 -0400
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
Subject: [rfc patch 1/6] memcg: remove unused retry signal from reclaim
Date: Thu, 12 May 2011 16:53:53 +0200
Message-Id: <1305212038-15445-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1305212038-15445-1-git-send-email-hannes@cmpxchg.org>
References: <1305212038-15445-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the memcg reclaim code detects the target memcg below its limit it
exits and returns a guaranteed non-zero value so that the charge is
retried.

Nowadays, the charge side checks the memcg limit itself and does not
rely on this non-zero return value trick.

This patch removes it.  The reclaim code will now always return the
true number of pages it reclaimed on its own.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 010f916..bf5ab87 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1503,7 +1503,7 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 			if (!res_counter_soft_limit_excess(&root_mem->res))
 				return total;
 		} else if (mem_cgroup_margin(root_mem))
-			return 1 + total;
+			return total;
 	}
 	return total;
 }
-- 
1.7.5.1

