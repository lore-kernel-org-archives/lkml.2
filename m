Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab2LCNzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 08:55:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:8866 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175Ab2LCNyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:54:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,206,1355126400"; 
   d="scan'208";a="258229017"
From: Alex Shi <alex.shi@intel.com>
To: npiggin@kernel.dk, mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 03/10] sched: don't need go to smaller sched domain
Date: Mon,  3 Dec 2012 21:54:07 +0800
Message-Id: <1354542848-29638-4-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1354542848-29638-1-git-send-email-alex.shi@intel.com>
References: <1354542848-29638-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If parent sched domain has no task allowed cpu find. neither find in
it's child. So, go out to save useless checking.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b40bc2b..05ee54e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3150,10 +3150,8 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 			load_idx = sd->wake_idx;
 
 		group = find_idlest_group(sd, p, cpu, load_idx);
-		if (!group) {
-			sd = sd->child;
-			continue;
-		}
+		if (!group)
+			goto unlock;
 
 		new_cpu = find_idlest_cpu(group, p, cpu);
 
-- 
1.7.5.4

