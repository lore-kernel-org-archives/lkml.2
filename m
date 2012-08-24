Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab2HXOij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:38:39 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:56178 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab2HXOih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:38:37 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 2/2] mm/vmscan: fix error number for failed kthread
Date: Fri, 24 Aug 2012 22:37:56 +0800
Message-Id: <1345819076-12545-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345819076-12545-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1345819076-12545-1-git-send-email-liwanp@linux.vnet.ibm.com>
x-cbid: 12082414-1618-0000-0000-000002559ADF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gavin Shan <shangw@linux.vnet.ibm.com>

The patch fixes the return value while failing to create the kswapd
kernel thread. Also, the error message is prioritized as KERN_ERR.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/vmscan.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8d01243..ddf00a7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3101,9 +3101,10 @@ int kswapd_run(int nid)
 	if (IS_ERR(pgdat->kswapd)) {
 		/* failure at boot is fatal */
 		BUG_ON(system_state == SYSTEM_BOOTING);
-		printk("Failed to start kswapd on node %d\n",nid);
-		ret = -1;
+		pr_err("Failed to start kswapd on node %d\n", nid);
+		ret = PTR_ERR(pgdat->kswapd);
 	}
+
 	return ret;
 }
 
-- 
1.7.7.6

