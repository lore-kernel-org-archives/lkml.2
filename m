Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab0IESdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:33:22 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46186 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab0IESdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:33:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ch1HNSkgLMAkNxBZAunROKXUWioTeRH3i2uP68FXNeVHtk3FW+ASttTZuU0cVNhd+5
         FthpVdc8qye162V8LpwbqsDXG+79rMB3keUm/p3TjQ8Avi9MWNDdfF3W0bxam9JWgSoh
         Tby8kGtpNI6qw8ZP5vGWNbWLfwNJo393voRKs=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 14/14] mm: oom_kill: use IS_ERR() instead of strict checking
Date: Sun,  5 Sep 2010 22:33:12 +0400
Message-Id: <1283711592-7669-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

Use IS_ERR() instead of strict checking.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 mm/oom_kill.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index fc81cb2..2ee3350 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -514,7 +514,7 @@ void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
 	read_lock(&tasklist_lock);
 retry:
 	p = select_bad_process(&points, limit, mem, NULL);
-	if (!p || PTR_ERR(p) == -1UL)
+	if (IS_ERR_OR_NULL(p))
 		goto out;
 
 	if (oom_kill_process(p, gfp_mask, 0, points, limit, mem, NULL,
@@ -691,7 +691,7 @@ retry:
 	p = select_bad_process(&points, totalpages, NULL,
 			constraint == CONSTRAINT_MEMORY_POLICY ? nodemask :
 								 NULL);
-	if (PTR_ERR(p) == -1UL)
+	if (IS_ERR(p))
 		goto out;
 
 	/* Found nothing?!?! Either we hang forever, or we panic. */
-- 
1.7.0.4

