Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab0FBNyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 09:54:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56529 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179Ab0FBNyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 09:54:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 5/5] oom: dump_tasks() use find_lock_task_mm() too
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Oleg Nesterov <oleg@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100601145033.2446.A69D9226@jp.fujitsu.com>
References: <20100601144238.243A.A69D9226@jp.fujitsu.com> <20100601145033.2446.A69D9226@jp.fujitsu.com>
Message-Id: <20100602215344.F51B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  2 Jun 2010 22:54:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> dump_task() should have the same process iteration logic as
> select_bad_process().
> 
> It is needed for protecting from task exiting race.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

sorry, this patch made one warning.
incremental patch is here.



Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index b06f8d1..f33a1b8 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -334,8 +334,6 @@ static void dump_tasks(const struct mem_cgroup *mem)
 	       "name\n");
 
 	for_each_process(p) {
-		struct mm_struct *mm;
-
 		if (is_global_init(p) || (p->flags & PF_KTHREAD))
 			continue;
 		if (mem && !task_in_mem_cgroup(p, mem))
-- 
1.6.5.2



