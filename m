Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab2KMDCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:02:18 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:36312 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab2KMDCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:02:14 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mhocko@suse.cz, glommer@parallels.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/17] cgroup: initialize cgrp->allcg_node in init_cgroup_housekeeping()
Date: Mon, 12 Nov 2012 19:01:29 -0800
Message-Id: <1352775704-9023-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352775704-9023-1-git-send-email-tj@kernel.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not strictly necessary but it's annoying to have uninitialized
list_head around.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d0803f0..ed0e177 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1381,6 +1381,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	INIT_LIST_HEAD(&cgrp->children);
 	INIT_LIST_HEAD(&cgrp->files);
 	INIT_LIST_HEAD(&cgrp->css_sets);
+	INIT_LIST_HEAD(&cgrp->allcg_node);
 	INIT_LIST_HEAD(&cgrp->release_list);
 	INIT_LIST_HEAD(&cgrp->pidlists);
 	mutex_init(&cgrp->pidlist_mutex);
-- 
1.7.11.7

