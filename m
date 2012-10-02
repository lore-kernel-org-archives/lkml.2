Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab2JBPBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:01:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:56482 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab2JBPB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:01:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,523,1344236400"; 
   d="scan'208";a="151533131"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 7/7] trace: reuse kbasename() functionality
Date: Tue,  2 Oct 2012 18:01:00 +0300
Message-Id: <1349190062-13107-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org> (maintainer:TRACING)
Cc: Frederic Weisbecker <fweisbec@gmail.com> (maintainer:TRACING)
---
 kernel/trace/trace_uprobe.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 03003cd..a2b2fab 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -22,6 +22,7 @@
 #include <linux/uaccess.h>
 #include <linux/uprobes.h>
 #include <linux/namei.h>
+#include <linux/string.h>
 
 #include "trace_probe.h"
 
@@ -263,16 +264,15 @@ static int create_trace_uprobe(int argc, char **argv)
 
 	/* setup a probe */
 	if (!event) {
-		char *tail = strrchr(filename, '/');
+		char *tail;
 		char *ptr;
 
-		ptr = kstrdup((tail ? tail + 1 : filename), GFP_KERNEL);
+		tail = ptr = kstrdup(kbasename(filename), GFP_KERNEL);
 		if (!ptr) {
 			ret = -ENOMEM;
 			goto fail_address_parse;
 		}
 
-		tail = ptr;
 		ptr = strpbrk(tail, ".-_");
 		if (ptr)
 			*ptr = '\0';
-- 
1.7.10.4

