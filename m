Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab2KMDCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:02:32 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46691 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab2KMDCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:02:25 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mhocko@suse.cz, glommer@parallels.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/17] cgroup: trivial cleanup for cgroup_init/load_subsys()
Date: Mon, 12 Nov 2012 19:01:35 -0800
Message-Id: <1352775704-9023-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352775704-9023-1-git-send-email-tj@kernel.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consistently use @css and @dummytop in these two functions instead of
referring to them indirectly.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d849efd..6df17cb 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4332,7 +4332,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 	 * pointer to this state - since the subsystem is
 	 * newly registered, all tasks and hence the
 	 * init_css_set is in the subsystem's top cgroup. */
-	init_css_set.subsys[ss->subsys_id] = dummytop->subsys[ss->subsys_id];
+	init_css_set.subsys[ss->subsys_id] = css;
 
 	need_forkexit_callback |= ss->fork || ss->exit;
 
@@ -4344,7 +4344,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 	ss->active = 1;
 
 	if (ss->post_create)
-		ss->post_create(&ss->root->top_cgroup);
+		ss->post_create(dummytop);
 
 	/* this function shouldn't be used with modular subsystems, since they
 	 * need to register a subsys_id, among other things */
@@ -4456,7 +4456,7 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	ss->active = 1;
 
 	if (ss->post_create)
-		ss->post_create(&ss->root->top_cgroup);
+		ss->post_create(dummytop);
 
 	/* success! */
 	mutex_unlock(&cgroup_mutex);
-- 
1.7.11.7

