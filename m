Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab0F3JbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:31:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60860 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab0F3JbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:31:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 06/11] oom: kill duplicate OOM_DISABLE check
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
References: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
Message-Id: <20100630183019.AA59.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 30 Jun 2010 18:31:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


select_bad_process() and badness() have the same OOM_DISABLE check.
This patch kill one.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index fcbd21b..f5d903f 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -350,9 +350,6 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 			*ppoints = ULONG_MAX;
 		}
 
-		if (p->signal->oom_adj == OOM_DISABLE)
-			continue;
-
 		points = badness(p, mem, nodemask, uptime.tv_sec);
 		if (points > *ppoints || !chosen) {
 			chosen = p;
-- 
1.6.5.2



