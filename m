Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab0F3Jcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:32:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59996 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab0F3Jct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:32:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 09/11] oom: remove child->mm check from oom_kill_process()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
References: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
Message-Id: <20100630183209.AA62.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 30 Jun 2010 18:32:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Current "child->mm == p->mm" mean prevent to select vfork() task.
But we don't have any reason to don't consider vfork().

Remvoed.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 136708b..b5678bf 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -479,9 +479,6 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 		list_for_each_entry(child, &t->children, sibling) {
 			unsigned long child_points;
 
-			if (child->mm == p->mm)
-				continue;
-
 			/* badness() returns 0 if the thread is unkillable */
 			child_points = badness(child, mem, nodemask,
 					       uptime.tv_sec);
-- 
1.6.5.2



