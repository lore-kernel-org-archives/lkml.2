Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1AUGpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:45:30 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51523 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab1AUGp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:45:28 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 21 Jan 2011 15:39:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 2/7] memcg : more fixes and clean up for 2.6.28-rc
Message-Id: <20110121153928.bb0c5e90.kamezawa.hiroyu@jp.fujitsu.com>
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

This is a fix for
ca3e021417eed30ec2b64ce88eb0acf64aa9bc29

mem_cgroup_disabled() should be checked at splitting.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

Index: mmotm-0107/mm/memcontrol.c
===================================================================
--- mmotm-0107.orig/mm/memcontrol.c
+++ mmotm-0107/mm/memcontrol.c
@@ -2144,6 +2144,8 @@ void mem_cgroup_split_huge_fixup(struct 
 	struct page_cgroup *tail_pc = lookup_page_cgroup(tail);
 	unsigned long flags;
 
+	if (mem_cgroup_disabled())
+		return;
 	/*
 	 * We have no races with charge/uncharge but will have races with
 	 * page state accounting.

