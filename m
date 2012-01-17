Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab2AQMsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:48:03 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61703 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2AQMsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:48:00 -0500
MIME-Version: 1.0
Date: Tue, 17 Jan 2012 20:47:59 +0800
Message-ID: <CAJd=RBBdDriMhfetM2AWGzgxiJ1DDs-W4Ff9_1Z8DUgbyQmSkA@mail.gmail.com>
Subject: [PATCH] mm: memcg: remove checking reclaim order in soft limit reclaim
From: Hillf Danton <dhillf@gmail.com>
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If async order-O reclaim expected here, it is settled down when setting up scan
control, with scan priority hacked to be zero. Other than that, deny of reclaim
should be removed.


Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/memcontrol.c	Tue Jan 17 20:41:36 2012
+++ b/mm/memcontrol.c	Tue Jan 17 20:47:48 2012
@@ -3512,9 +3512,6 @@ unsigned long mem_cgroup_soft_limit_recl
 	unsigned long long excess;
 	unsigned long nr_scanned;

-	if (order > 0)
-		return 0;
-
 	mctz = soft_limit_tree_node_zone(zone_to_nid(zone), zone_idx(zone));
 	/*
 	 * This loop can run a while, specially if mem_cgroup's continuously
