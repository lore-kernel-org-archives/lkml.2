Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab0KIJMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:12:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:2993 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab0KIJMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:12:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,174,1288594800"; 
   d="scan'208";a="855641168"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        chris@chris-wilson.co.uk, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 4/4] tracing: update the trace/events.txt documentation
Date: Tue,  9 Nov 2010 17:12:47 +0800
Message-Id: <1289293967-31761-4-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289293967-31761-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1289293967-31761-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe the usage of trace_set_clr_module_event in events.txt

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 Documentation/trace/events.txt |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index 09bd8e9..120c1fe 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -93,6 +93,31 @@ In order to facilitate early boot debugging, use boot option:
 event-list is a comma separated list of events. See section 2.1 for event
 format.
 
+2.4 Module load option
+----------------------
+
+In order to track the events at the early module load phase, add the
+following codes in your module:
+
+    char *xxx_trace = NULL;
+    module_param_named(trace, xxx_trace, charp, 0400);
+
+
+    /* Your module init function */
+    xxx_init()
+    {
+        ....
+        if (xxx_trace)
+                trace_set_clr_module_event(THIS_MODULE, xxx_trace, 1);
+        ....
+    }
+
+where the xxx_trace is same as event-list described above, besides DO
+NOT include the subsystem.
+
+You can check the sample code for more information.
+
+
 3. Defining an event-enabled tracepoint
 =======================================
 
-- 
1.7.2.3

