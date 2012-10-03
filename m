Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab2JCIxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 04:53:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:21091 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab2JCIx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 04:53:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,527,1344236400"; 
   d="scan'208";a="229925733"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCHv2.5] trace: reuse kbasename() functionality
Date: Wed,  3 Oct 2012 11:53:19 +0300
Message-Id: <1349254399-22742-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349253783-21612-7-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1349253783-21612-7-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_uprobe.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 03003cd..c7ba4f6 100644
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
-		if (!ptr) {
+		tail = kstrdup(kbasename(filename), GFP_KERNEL);
+		if (!tail) {
 			ret = -ENOMEM;
 			goto fail_address_parse;
 		}
 
-		tail = ptr;
 		ptr = strpbrk(tail, ".-_");
 		if (ptr)
 			*ptr = '\0';
-- 
1.7.10.4

