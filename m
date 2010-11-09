Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab0KIBR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 20:17:59 -0500
Received: from smtp-out.google.com ([74.125.121.35]:42753 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab0KIBR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 20:17:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=q5wXdO8IBfb3GG2X2oxGmEvVeZxzphkm0cDgPb5Afy5/O3KGSdWlcjCRHiWfgKQg9
	+WlW94AU9s2423PczvQjA==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH] memcg: correct memcg_hierarchical_free_pages() return type
Date: Mon,  8 Nov 2010 17:17:10 -0800
Message-Id: <1289265430-7190-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memcg_hierarchical_free_pages() returns a page count and thus
should return unsigned long to be consistent with the rest of
mm code.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b287afd..35870f9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1340,7 +1340,7 @@ static long mem_cgroup_local_page_stat(struct mem_cgroup *mem,
  * use_hierarchy is set, then this involves parent mem cgroups to find the
  * cgroup with the smallest free space.
  */
-static unsigned long long
+static unsigned long
 memcg_hierarchical_free_pages(struct mem_cgroup *mem)
 {
 	unsigned long free, min_free;
-- 
1.7.3.1

