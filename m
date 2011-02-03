Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1BCO1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:27:12 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:40513 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045Ab1BCO1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:27:11 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [patch 1/5] memcg: no uncharged pages reach page_cgroup_zoneinfo
Date: Thu,  3 Feb 2011 15:26:02 +0100
Message-Id: <1296743166-9412-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1296743166-9412-1-git-send-email-hannes@cmpxchg.org>
References: <1296743166-9412-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All callsites check PCG_USED before passing pc->mem_cgroup, so the
latter is never NULL.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e071d7e..85b4b5a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -370,9 +370,6 @@ page_cgroup_zoneinfo(struct page_cgroup *pc)
 	int nid = page_cgroup_nid(pc);
 	int zid = page_cgroup_zid(pc);
 
-	if (!mem)
-		return NULL;
-
 	return mem_cgroup_zoneinfo(mem, nid, zid);
 }
 
-- 
1.7.4

