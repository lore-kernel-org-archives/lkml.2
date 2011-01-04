Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab1ADUoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:44:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:63402 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab1ADUoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:44:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,274,1291622400"; 
   d="scan'208";a="589853645"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tom Zanussi <tom.zanussi@intel.com>
Cc: Darren Hart <dvhart@linux.intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Tom Zanussi <tom.zanussi@intel.com>
Subject: [PATCH 3/3] trace-cmd: correct trace._handle usage in event-viewer.py
Date: Tue,  4 Jan 2011 12:43:40 -0800
Message-Id: <1294173820-7043-4-git-send-email-dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294173820-7043-1-git-send-email-dvhart@linux.intel.com>
References: <1294173820-7043-1-git-send-email-dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The handle member object was changed to _handle, correct the usage
in event-viewer.py.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Tom Zanussi <tom.zanussi@intel.com>
---
 event-viewer.py |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/event-viewer.py b/event-viewer.py
index 6f35642..28afca2 100755
--- a/event-viewer.py
+++ b/event-viewer.py
@@ -66,13 +66,13 @@ class EventStore(gtk.GenericTreeModel):
         print "Building trace index..."
         index = 0
         for cpu in range(0, trace.cpus):
-            rec = tracecmd_read_data(self.trace.handle, cpu)
+            rec = tracecmd_read_data(self.trace._handle, cpu)
             while rec:
                 offset = record_offset_get(rec)
                 ts = record_ts_get(rec)
                 self.refs.append(self.EventRef(index, ts, offset, cpu))
                 index = index + 1
-                rec = tracecmd_read_data(self.trace.handle, cpu)
+                rec = tracecmd_read_data(self.trace._handle, cpu)
         print "Loaded %d events from trace" % (index)
 
     @timing
-- 
1.7.1

