Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1FTLFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 07:05:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab1FTLFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 07:05:15 -0400
From: Frantisek Hrbata <fhrbata@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        CAI Qian <caiqian@redhat.com>, lwoodman@redhat.com
Subject: [PATCH] oom: add uid to "Killed process" message
Date: Mon, 20 Jun 2011 13:04:36 +0200
Message-Id: <1308567876-23581-1-git-send-email-fhrbata@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add user id to the oom killer's "Killed process" message, so the user of the
killed process can be identified.

Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
---
 mm/oom_kill.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index e4b0991..249a15a 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -427,8 +427,9 @@ static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
 	/* mm cannot be safely dereferenced after task_unlock(p) */
 	mm = p->mm;
 
-	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
-		task_pid_nr(p), p->comm, K(p->mm->total_vm),
+	pr_err("Killed process %d (%s) uid: %d, total-vm:%lukB, "
+		"anon-rss:%lukB, file-rss:%lukB\n",
+		task_pid_nr(p), p->comm, task_uid(p), K(p->mm->total_vm),
 		K(get_mm_counter(p->mm, MM_ANONPAGES)),
 		K(get_mm_counter(p->mm, MM_FILEPAGES)));
 	task_unlock(p);
-- 
1.7.4.4

