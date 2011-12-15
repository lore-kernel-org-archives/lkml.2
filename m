Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608Ab1LOWVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:21:51 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:36591 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab1LOWVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:21:50 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Paul Menage <paul@paulmenage.org>
Subject: [PATCH] cgroups: remove redundant get/put of css_set from css_set_check_fetched()
Date: Thu, 15 Dec 2011 14:21:26 -0800
Message-Id: <1323987686-17968-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have a reference to all elements in newcg_list.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org
Cc: cgroups@vger.kernel.org
Cc: Paul Menage <paul@paulmenage.org>
---
 kernel/cgroup.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d9d5648..a7e00b9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1935,23 +1935,17 @@ static bool css_set_check_fetched(struct cgroup *cgrp,
 
 	read_lock(&css_set_lock);
 	newcg = find_existing_css_set(cg, cgrp, template);
-	if (newcg)
-		get_css_set(newcg);
 	read_unlock(&css_set_lock);
 
 	/* doesn't exist at all? */
 	if (!newcg)
 		return false;
 	/* see if it's already in the list */
-	list_for_each_entry(cg_entry, newcg_list, links) {
-		if (cg_entry->cg == newcg) {
-			put_css_set(newcg);
+	list_for_each_entry(cg_entry, newcg_list, links)
+		if (cg_entry->cg == newcg)
 			return true;
-		}
-	}
 
 	/* not found */
-	put_css_set(newcg);
 	return false;
 }
 
-- 
1.7.3.1

