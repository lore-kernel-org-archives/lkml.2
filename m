Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab0KHGFC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 01:05:02 -0500
Received: from mga14.intel.com ([143.182.124.37]:15474 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab0KHGFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 01:05:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,312,1286175600"; 
   d="scan'208";a="345777113"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: chris@chris-wilson.co.uk, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] Tracing: do export trace_set_clr_event
Date: Mon,  8 Nov 2010 14:05:12 +0800
Message-Id: <1289196312-25323-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace event belongs to a module does exist only when the module is
loaded. Well, we can use trace_set_clr_event funtion to enable some
trace event at the module init routine, so that we will not miss
something while loading then module.

So, Export the trace_set_clr_event function so that module can use it.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace_events.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0725eea..711965b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -320,6 +320,7 @@ int trace_set_clr_event(const char *system, const char *event, int set)
 {
 	return __ftrace_set_clr_event(NULL, system, event, set);
 }
+EXPORT_SYMBOL_GPL(trace_set_clr_event);
 
 /* 128 should be much more than enough */
 #define EVENT_BUF_SIZE		127
-- 
1.7.2.3

