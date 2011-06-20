Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1FTRAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:00:04 -0400
Received: from ip-89-102-13-133.net.upcbroadband.cz ([89.102.13.133]:39922
	"EHLO dhcp-26-164.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755413Ab1FTRAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:00:00 -0400
X-Greylist: delayed 3544 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jun 2011 12:59:59 EDT
From: Frantisek Hrbata <fhrbata@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        CAI Qian <caiqian@redhat.com>, lwoodman@redhat.com
Subject: [PATCH] oom: add uid to "Killed process" message
Date: Mon, 20 Jun 2011 12:16:09 +0200
Message-Id: <1308564969-20888-1-git-send-email-fhrbata@redhat.com>
X-Mailer: git-send-email 1.7.4.4
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

