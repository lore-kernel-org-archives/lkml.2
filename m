Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab2ACWf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:35:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39450 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373Ab2ACWfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:35:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:34 2012
Message-Id: <20120103223033.967141339@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hillf Danton <dhillf@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [31/67] memcg: keep root group unchanged if creation fails
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hillf Danton <dhillf@gmail.com>

commit a41c58a6665cc995e237303b05db42100b71b65e upstream.

If the request is to create non-root group and we fail to meet it, we
should leave the root unchanged.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4963,9 +4963,9 @@ mem_cgroup_create(struct cgroup_subsys *
 		int cpu;
 		enable_swap_cgroup();
 		parent = NULL;
-		root_mem_cgroup = mem;
 		if (mem_cgroup_soft_limit_tree_init())
 			goto free_out;
+		root_mem_cgroup = mem;
 		for_each_possible_cpu(cpu) {
 			struct memcg_stock_pcp *stock =
 						&per_cpu(memcg_stock, cpu);
@@ -5004,7 +5004,6 @@ mem_cgroup_create(struct cgroup_subsys *
 	return &mem->css;
 free_out:
 	__mem_cgroup_free(mem);
-	root_mem_cgroup = NULL;
 	return ERR_PTR(error);
 }
 


