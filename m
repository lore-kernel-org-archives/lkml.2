Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab1LLNtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 08:49:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51645 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1LLNtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 08:49:19 -0500
MIME-Version: 1.0
In-Reply-To: <20111212131118.GA15249@tiehlicka.suse.cz>
References: <CAJd=RBB_AoJmyPd7gfHn+Kk39cn-+Wn-pFvU0ZWRZhw2fxoihw@mail.gmail.com>
	<alpine.LSU.2.00.1112111520510.2297@eggly>
	<20111212131118.GA15249@tiehlicka.suse.cz>
Date: Mon, 12 Dec 2011 21:49:18 +0800
Message-ID: <CAJd=RBAZT0zVnMm7i7P4J9Qg+LvTYh25RwFP7JZnN9dxwWp55g@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: keep root group unchanged if fail to create new
From: Hillf Danton <dhillf@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>, Balbir Singh <bsingharora@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 9:11 PM, Michal Hocko <mhocko@suse.cz> wrote:
>
> Hillf could you update the patch please?
>
Hi Michal,

Please review again, thanks.
Hillf

===CUT HERE===
From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] mm: memcg: keep root group unchanged if fail to create new

If the request is to create non-root group and we fail to meet it, we should
leave the root unchanged.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---

--- a/mm/memcontrol.c	Fri Dec  9 21:57:40 2011
+++ b/mm/memcontrol.c	Mon Dec 12 21:47:14 2011
@@ -4848,9 +4848,9 @@ mem_cgroup_create(struct cgroup_subsys *
 		int cpu;
 		enable_swap_cgroup();
 		parent = NULL;
-		root_mem_cgroup = memcg;
 		if (mem_cgroup_soft_limit_tree_init())
 			goto free_out;
+		root_mem_cgroup = memcg;
 		for_each_possible_cpu(cpu) {
 			struct memcg_stock_pcp *stock =
 						&per_cpu(memcg_stock, cpu);
@@ -4888,7 +4888,6 @@ mem_cgroup_create(struct cgroup_subsys *
 	return &memcg->css;
 free_out:
 	__mem_cgroup_free(memcg);
-	root_mem_cgroup = NULL;
 	return ERR_PTR(error);
 }
