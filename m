Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1FHVKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:10:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417Ab1FHVKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:10:44 -0400
Date: Wed, 8 Jun 2011 14:09:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        balbir@linux.vnet.ibm.com, linux-mm@kvack.org,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH] memcg: do not expose uninitialized mem_cgroup_per_node
 to world
Message-Id: <20110608140951.115ab1dd.akpm@linux-foundation.org>
In-Reply-To: <20110608123527.479e6991.kamezawa.hiroyu@jp.fujitsu.com>
References: <1306925044-2828-1-git-send-email-imammedo@redhat.com>
	<20110601123913.GC4266@tiehlicka.suse.cz>
	<4DE6399C.8070802@redhat.com>
	<20110601134149.GD4266@tiehlicka.suse.cz>
	<4DE64F0C.3050203@redhat.com>
	<20110601152039.GG4266@tiehlicka.suse.cz>
	<4DE66BEB.7040502@redhat.com>
	<BANLkTimbqHPeUdue=_Z31KVdPwcXtbLpeg@mail.gmail.com>
	<4DE8D50F.1090406@redhat.com>
	<BANLkTinMamg_qesEffGxKu3QkT=zyQ2MRQ@mail.gmail.com>
	<4DEE26E7.2060201@redhat.com>
	<20110608123527.479e6991.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The original patch:

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4707,7 +4707,6 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
 	if (!pn)
 		return 1;
 
-	mem->info.nodeinfo[node] = pn;
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		mz = &pn->zoneinfo[zone];
 		for_each_lru(l)
@@ -4716,6 +4715,7 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
 		mz->on_tree = false;
 		mz->mem = mem;
 	}
+	mem->info.nodeinfo[node] = pn;
 	return 0;
 }

looks like a really good idea.  But it needs a new changelog and I'd be
a bit reluctant to merge it as it appears that the aptch removes our
only known way of reproducing a bug.

So for now I think I'll queue the patch up unchangelogged so the issue
doesn't get forgotten about.

