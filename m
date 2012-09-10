Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab2IJI6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:58:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62513 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756534Ab2IJI6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:58:00 -0400
X-IronPort-AV: E=Sophos;i="4.80,397,1344182400"; 
   d="scan'208";a="5814158"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [V4 PATCH 10/26] mm,migrate: use N_MEMORY instead N_HIGH_MEMORY
Date: Mon, 10 Sep 2012 16:59:02 +0800
Message-Id: <1347267558-6707-11-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347267558-6707-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347267558-6707-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/10 16:57:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/10 16:57:20,
	Serialize complete at 2012/09/10 16:57:20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux.com>
---
 mm/migrate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 77ed2d7..d595e58 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1201,7 +1201,7 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 			if (node < 0 || node >= MAX_NUMNODES)
 				goto out_pm;
 
-			if (!node_state(node, N_HIGH_MEMORY))
+			if (!node_state(node, N_MEMORY))
 				goto out_pm;
 
 			err = -EACCES;
-- 
1.7.1

