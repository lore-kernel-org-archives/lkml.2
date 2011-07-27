Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1G0J5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:57:05 -0400
Received: from narfation.org ([79.140.41.39]:43166 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab1G0Jzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:55:49 -0400
From: Sven Eckelmann <sven@narfation.org>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: [PATCHv4 09/11] memcg: Use *_dec_not_zero instead of *_add_unless
Date: Wed, 27 Jul 2011 11:47:48 +0200
Message-Id: <1311760070-21532-9-git-send-email-sven@narfation.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311760070-21532-1-git-send-email-sven@narfation.org>
References: <1311760070-21532-1-git-send-email-sven@narfation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic_dec_not_zero is defined for each architecture through
<linux/atomic.h> to provide the functionality of
atomic_add_unless(x, -1, 0).

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org
---
 mm/memcontrol.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5f84d23..00a7580 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1909,10 +1909,10 @@ static void mem_cgroup_unmark_under_oom(struct mem_cgroup *mem)
 	/*
 	 * When a new child is created while the hierarchy is under oom,
 	 * mem_cgroup_oom_lock() may not be called. We have to use
-	 * atomic_add_unless() here.
+	 * atomic_dec_not_zero() here.
 	 */
 	for_each_mem_cgroup_tree(iter, mem)
-		atomic_add_unless(&iter->under_oom, -1, 0);
+		atomic_dec_not_zero(&iter->under_oom);
 }
 
 static DEFINE_SPINLOCK(memcg_oom_lock);
-- 
1.7.5.4

