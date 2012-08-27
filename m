Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab2H0HNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:13:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:29244 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab2H0HNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:13:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,318,1344236400"; 
   d="scan'208";a="191701209"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH] tracing: skip printing "OK" if failed to disable event
Date: Mon, 27 Aug 2012 15:13:45 +0800
Message-Id: <1346051625-25231-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No acutal case found. But logically, we should skip "OK" in case any
error met.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 kernel/trace/trace_events.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 29111da..9894162 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1646,9 +1646,11 @@ static __init void event_trace_self_tests(void)
 		event_test_stuff();
 
 		ret = __ftrace_set_clr_event(NULL, system->name, NULL, 0);
-		if (WARN_ON_ONCE(ret))
+		if (WARN_ON_ONCE(ret)) {
 			pr_warning("error disabling system %s\n",
 				   system->name);
+			continue;
+		}
 
 		pr_cont("OK\n");
 	}
-- 
1.7.7.6

