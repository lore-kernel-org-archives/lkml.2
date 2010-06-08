Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0FHMBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 08:01:49 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44207 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab0FHMBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 08:01:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 08/10] oom: use send_sig() instead force_sig()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100608204621.767A.A69D9226@jp.fujitsu.com>
References: <20100608204621.767A.A69D9226@jp.fujitsu.com>
Message-Id: <20100608210000.7692.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Jun 2010 21:01:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg, I parsed your mention mean following patch, correct?


===========================================
Oleg pointed out oom_kill.c has force_sig() abuse. force_sig() mean 
ignore signal mask. but SIGKILL itself is not maskable.
So, we can use send_sig() sefely.

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index e7d3a5d..599f977 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -399,7 +399,7 @@ static int __oom_kill_process(struct task_struct *p, struct mem_cgroup *mem)
 	p->rt.time_slice = HZ;
 	set_tsk_thread_flag(p, TIF_MEMDIE);
 
-	force_sig(SIGKILL, p);
+	send_sig(SIGKILL, p, 1);
 
 	return 0;
 }
-- 
1.6.5.2



