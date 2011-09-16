Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1IPGVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:21:09 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:58320 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab1IPGVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:21:07 -0400
Date: Fri, 16 Sep 2011 16:21:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@google.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20110916162105.efc26643279ad362cabbd804@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

mm/memcontrol.c: In function 'mem_cgroup_force_empty':
mm/memcontrol.c:3761:15: error: 'rec' undeclared (first use in this function)
mm/memcontrol.c:3761:15: note: each undeclared identifier is reported only once for each function it appears in
mm/memcontrol.c:3761:7: error: too many arguments to function 'try_to_free_mem_cgroup_pages'
include/linux/swap.h:254:22: note: declared here

Presumably caused by my bad merge fixup.  I applied the further fix below.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 16 Sep 2011 16:17:52 +1000
Subject: [PATCH] akpm: merge fix up fix for memcg

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a505fc9..1faea9b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3758,7 +3758,7 @@ try_to_free:
 			goto out;
 		}
 		progress = try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL,
-						false, &rec);
+						false);
 		if (!progress) {
 			nr_retries--;
 			/* maybe some writeback is necessary */
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

