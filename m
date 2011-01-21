Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab1AUGng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:43:36 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38892 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab1AUGne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:43:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 21 Jan 2011 15:37:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 1/7] memcg : comment, style fixes for recent patch of
 move_parent
Message-Id: <20110121153726.54f4a159.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110121153431.191134dd.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110121153431.191134dd.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

A fix for 987eba66e0e6aa654d60881a14731a353ee0acb4

A clean up for mem_cgroup_move_parent(). 
 - remove unnecessary initialization of local variable.
 - rename charge_size -> page_size
 - remove unnecessary (wrong) comment.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: mmotm-0107/mm/memcontrol.c
===================================================================
--- mmotm-0107.orig/mm/memcontrol.c
+++ mmotm-0107/mm/memcontrol.c
@@ -2265,7 +2265,7 @@ static int mem_cgroup_move_parent(struct
 	struct cgroup *cg = child->css.cgroup;
 	struct cgroup *pcg = cg->parent;
 	struct mem_cgroup *parent;
-	int charge = PAGE_SIZE;
+	int page_size;
 	unsigned long flags;
 	int ret;
 
@@ -2278,22 +2278,23 @@ static int mem_cgroup_move_parent(struct
 		goto out;
 	if (isolate_lru_page(page))
 		goto put;
-	/* The page is isolated from LRU and we have no race with splitting */
-	charge = PAGE_SIZE << compound_order(page);
+
+	page_size = PAGE_SIZE << compound_order(page);
 
 	parent = mem_cgroup_from_cont(pcg);
-	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false, charge);
+	ret = __mem_cgroup_try_charge(NULL, gfp_mask,
+				&parent, false, page_size);
 	if (ret || !parent)
 		goto put_back;
 
-	if (charge > PAGE_SIZE)
+	if (page_size > PAGE_SIZE)
 		flags = compound_lock_irqsave(page);
 
-	ret = mem_cgroup_move_account(pc, child, parent, true, charge);
+	ret = mem_cgroup_move_account(pc, child, parent, true, page_size);
 	if (ret)
-		mem_cgroup_cancel_charge(parent, charge);
+		mem_cgroup_cancel_charge(parent, page_size);
 put_back:
-	if (charge > PAGE_SIZE)
+	if (page_size > PAGE_SIZE)
 		compound_unlock_irqrestore(page, flags);
 	putback_lru_page(page);
 put:

