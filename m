Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1HJXwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:52:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59991 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab1HJXwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:52:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 11 Aug 2011 08:44:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH] memcg: fix comment on update nodemask
Message-Id: <20110811084456.5da61183.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110811083043.a3b2ba65.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110809190450.16d7f845.kamezawa.hiroyu@jp.fujitsu.com>
	<20110809190824.99347a0f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110810100042.GA15007@tiehlicka.suse.cz>
	<20110811083043.a3b2ba65.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > >  /*
> > >   * Always updating the nodemask is not very good - even if we have an empty
> > >   * list or the wrong list here, we can start from some node and traverse all
> > > @@ -1575,7 +1593,6 @@ static bool test_mem_cgroup_node_reclaim
> > >   */
> > 
> > Would be good to update the function comment as well (we still have 10s
> > period there).
> > 
> 
how about this ?
==

Update function's comment. The behavior is changed by commit 453a9bf3

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/memcontrol.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: mmotm-Aug3/mm/memcontrol.c
===================================================================
--- mmotm-Aug3.orig/mm/memcontrol.c
+++ mmotm-Aug3/mm/memcontrol.c
@@ -1568,10 +1568,7 @@ static bool test_mem_cgroup_node_reclaim
 #if MAX_NUMNODES > 1
 
 /*
- * Always updating the nodemask is not very good - even if we have an empty
- * list or the wrong list here, we can start from some node and traverse all
- * nodes based on the zonelist. So update the list loosely once per 10 secs.
- *
+ * Update scan nodemask with memcg's event_counter(NUMAINFO_EVENTS_TARGET)
  */
 static void mem_cgroup_may_update_nodemask(struct mem_cgroup *mem)
 {

