Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab0FAFsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:48:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52712 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab0FAFsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:48:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH 2/5] oom: remove warning for in mm-less task __oom_kill_process()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100601144238.243A.A69D9226@jp.fujitsu.com>
References: <20100601144238.243A.A69D9226@jp.fujitsu.com>
Message-Id: <20100601144705.243D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  1 Jun 2010 14:48:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the race of mm detach in task exiting vs oom is happen,
find_lock_task_mm() can be return NULL.

So, the warning is pointless. remove it.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index bac4515..70e1a85 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -402,12 +402,8 @@ static int __oom_kill_process(struct task_struct *p, struct mem_cgroup *mem,
 		return 1;
 
 	p = find_lock_task_mm(p);
-	if (!p) {
-		WARN_ON(1);
-		printk(KERN_WARNING "tried to kill an mm-less task %d (%s)!\n",
-			task_pid_nr(p), p->comm);
+	if (!p)
 		return 1;
-	}
 
 	if (verbose)
 		printk(KERN_ERR "Killed process %d (%s) "
-- 
1.6.5.2



