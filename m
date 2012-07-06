Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2GFDpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 23:45:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58405 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2GFDpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 23:45:19 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm/memcg: add BUG() to mem_cgroup_reset
Date: Fri,  6 Jul 2012 11:44:57 +0800
Message-Id: <1341546297-6223-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Branch in mem_cgroup_reset only can be RES_MAX_USAGE, RES_FAILCNT.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/memcontrol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a501660..5e4d1ab 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3976,6 +3976,8 @@ static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
 		else
 			res_counter_reset_failcnt(&memcg->memsw);
 		break;
+	default:
+		BUG();
 	}
 
 	return 0;
-- 
1.7.5.4

