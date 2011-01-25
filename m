Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab1AYGH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 01:07:56 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34824 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab1AYGHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 01:07:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 25 Jan 2011 15:01:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 2/3] memcg: bugfix check mem_cgroup_disabled() at split
 fixup
Message-Id: <20110125150153.b16c4de3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110125145720.cd0cbe16.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110125145720.cd0cbe16.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

mem_cgroup_disabled() should be checked at splitting.
If diabled, no heavy work is necesary.

Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.38-rc2/mm/memcontrol.c
===================================================================
--- linux-2.6.38-rc2.orig/mm/memcontrol.c
+++ linux-2.6.38-rc2/mm/memcontrol.c
@@ -2145,6 +2145,8 @@ void mem_cgroup_split_huge_fixup(struct 
 	struct page_cgroup *tail_pc = lookup_page_cgroup(tail);
 	unsigned long flags;
 
+	if (mem_cgroup_disabled())
+		return;
 	/*
 	 * We have no races with charge/uncharge but will have races with
 	 * page state accounting.

