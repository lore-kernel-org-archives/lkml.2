Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1HCDXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 23:23:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53029 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab1HCDXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 23:23:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 3 Aug 2011 12:15:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [BUGFIX][PATCH] memcg: fix oom schedule_timeout
Message-Id: <20110803121532.1ab8d76c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is onto the latest mmotm.

==
Before calling schedule_timeout(), task state should be changed.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: mmotm-Aug3/mm/memcontrol.c
===================================================================
--- mmotm-Aug3.orig/mm/memcontrol.c
+++ mmotm-Aug3/mm/memcontrol.c
@@ -2005,7 +2005,7 @@ bool mem_cgroup_handle_oom(struct mem_cg
 	if (test_thread_flag(TIF_MEMDIE) || fatal_signal_pending(current))
 		return false;
 	/* Give chance to dying process */
-	schedule_timeout(1);
+	schedule_timeout_uninterruptible(1);
 	return true;
 }
 

