Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161189Ab2CPXgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:36:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38397 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161982Ab2CPXgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:36:17 -0400
From: Tejun Heo <tj@kernel.org>
To: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/10] cgroup: merge cft_release_agent cftype array into the base files array
Date: Fri, 16 Mar 2012 16:35:57 -0700
Message-Id: <1331940963-15756-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331940963-15756-1-git-send-email-tj@kernel.org>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that cftype can express whether a file should only be on root,
cft_release_agent can be merged into the base files cftypes array.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2b1a209..6c396f3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3748,13 +3748,13 @@ static struct cftype files[] = {
 		.read_u64 = cgroup_clone_children_read,
 		.write_u64 = cgroup_clone_children_write,
 	},
-};
-
-static struct cftype cft_release_agent = {
-	.name = "release_agent",
-	.read_seq_string = cgroup_release_agent_show,
-	.write_string = cgroup_release_agent_write,
-	.max_write_len = PATH_MAX,
+	{
+		.name = "release_agent",
+		.flags = CFTYPE_ONLY_ON_ROOT,
+		.read_seq_string = cgroup_release_agent_show,
+		.write_string = cgroup_release_agent_write,
+		.max_write_len = PATH_MAX,
+	},
 };
 
 static int cgroup_populate_dir(struct cgroup *cgrp)
@@ -3766,11 +3766,6 @@ static int cgroup_populate_dir(struct cgroup *cgrp)
 	if (err < 0)
 		return err;
 
-	if (cgrp == cgrp->top_cgroup) {
-		if ((err = cgroup_add_file(cgrp, NULL, &cft_release_agent)) < 0)
-			return err;
-	}
-
 	/* process cftsets of each subsystem */
 	for_each_subsys(cgrp->root, ss) {
 		struct cftype_set *set;
-- 
1.7.7.3

