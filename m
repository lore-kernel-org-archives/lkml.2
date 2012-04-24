Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab2DXTeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:34:11 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:35219 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757145Ab2DXTeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:34:10 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] Documentation: memcg: future proof hierarchical statistics documentation
Date: Tue, 24 Apr 2012 21:33:58 +0200
Message-Id: <1335296038-29297-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hierarchical versions of per-memcg counters in memory.stat are all
calculated the same way and are all named total_<counter>.

Documenting the pattern is easier for maintenance than listing each
counter twice.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Ying Han <yinghan@google.com>
---
 Documentation/cgroups/memory.txt |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index ab34ae5..6a066a2 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -432,17 +432,10 @@ hierarchical_memory_limit - # of bytes of memory limit with regard to hierarchy
 hierarchical_memsw_limit - # of bytes of memory+swap limit with regard to
 			hierarchy under which memory cgroup is.
 
-total_cache		- sum of all children's "cache"
-total_rss		- sum of all children's "rss"
-total_mapped_file	- sum of all children's "cache"
-total_pgpgin		- sum of all children's "pgpgin"
-total_pgpgout		- sum of all children's "pgpgout"
-total_swap		- sum of all children's "swap"
-total_inactive_anon	- sum of all children's "inactive_anon"
-total_active_anon	- sum of all children's "active_anon"
-total_inactive_file	- sum of all children's "inactive_file"
-total_active_file	- sum of all children's "active_file"
-total_unevictable	- sum of all children's "unevictable"
+total_<counter>		- # hierarchical version of <counter>, which in
+			addition to the cgroup's own value includes the
+			sum of all hierarchical children's values of
+			<counter>, i.e. total_cache
 
 # The following additional stats are dependent on CONFIG_DEBUG_VM.
 
-- 
1.7.7.6

