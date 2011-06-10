Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1FJHv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 03:51:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36247 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab1FJHv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 03:51:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 10 Jun 2011 16:44:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Ying Han <yinghan@google.com>
Subject: [BUGFIX][PATCH] fix memory.numa_stat file permission
Message-Id: <20110610164456.cfcdbd0c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry I missed this bug because I tested as 'root' ...

=
>From 9fe15b548430635d4bbdc2b39e778dbb08e369c9 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 16:50:39 +0900
Subject: [PATCH][BUGFIX] memcg: fix memory.numa_stat file permission


 commit 406eb0c9ba765eb066406fd5ce9d5e2b169a4d5a adds memory.numa_stat
 file for memory cgroup. But it's file permission is wrong.

[kamezawa@bluextal linux-2.6]$ ls -l /cgroup/memory/A/memory.numa_stat
---------- 1 root root 0 Jun  9 18:36 /cgroup/memory/A/memory.numa_stat

This patch fixes the permission as

[root@bluextal kamezawa]# ls -l /cgroup/memory/A/memory.numa_stat
-r--r--r-- 1 root root 0 Jun 10 16:49 /cgroup/memory/A/memory.numa_stat

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


