Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab1FMDKD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 23:10:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43789 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1FMDJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 23:09:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 13 Jun 2011 12:03:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Subject: [BUGFIX][PATCH 1/5] memcg fix numa_stat permission
Message-Id: <20110613120301.09daa339.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110613120054.3336e997.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110613120054.3336e997.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is already queued in mmotm.
==
>From 3b1bec1d07ba21339697f069acab47dae6b81097 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 13 Jun 2011 09:32:28 +0900
Subject: [PATCH 1/5] memcg fix numa_stat permission

commit 406eb0c9b ("memcg: add memory.numastat api for numa statistics")
 adds memory.numa_stat file for memory cgroup.  But the file permissions
 are wrong.

[kamezawa@bluextal linux-2.6]$ ls -l /cgroup/memory/A/memory.numa_stat
---------- 1 root root 0 Jun  9 18:36 /cgroup/memory/A/memory.numa_stat

This patch fixes the permission as

[root@bluextal kamezawa]# ls -l /cgroup/memory/A/memory.numa_stat
-r--r--r-- 1 root root 0 Jun 10 16:49 /cgroup/memory/A/memory.numa_stat

Acked-by: Ying Han <yinghan@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bd9052a..ce05835 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4640,6 +4640,7 @@ static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "numa_stat",
 		.open = mem_control_numa_stat_open,
+		.mode = S_IRUGO,
 	},
 #endif
 };
-- 
1.7.4.1


