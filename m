Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208Ab2C1LC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:02:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49982 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831Ab2C1LC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:02:26 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F72EF56.4030606@jp.fujitsu.com>
Date: Wed, 28 Mar 2012 20:00:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Suleiman Souhlal <suleiman@google.com>
Subject: [RFC][PATCH 5/6] memcg: remove unnecessary memory barrier.
References: <4F72EB84.7080000@jp.fujitsu.com>
In-Reply-To: <4F72EB84.7080000@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, Used bit and a pointer to memory cgroup are set at once.
memory barrier for Used bit -> pc->mem_cgroup is not necessary.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 622fd2e..767bef3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1258,8 +1258,6 @@ mem_cgroup_get_reclaim_stat_from_page(struct page *page)
 	pc = lookup_page_cgroup(page);
 	if (!PageCgroupUsed(pc))
 		return NULL;
-	/* Ensure pc's mem_cgroup is visible after reading PCG_USED. */
-	smp_rmb();
 	mz = page_cgroup_zoneinfo(pc_to_mem_cgroup(pc), page);
 	return &mz->reclaim_stat;
 }
-- 
1.7.4.1


