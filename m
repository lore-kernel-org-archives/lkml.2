Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab2JPLsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 07:48:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:46862 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672Ab2JPLs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 07:48:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="235689615"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCHv3 6/6] trace: reuse kbasename() functionality
Date: Tue, 16 Oct 2012 14:48:14 +0300
Message-Id: <1350388094-18805-8-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350388094-18805-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1350388094-18805-1-git-send-email-andriy.shevchenko@linux.intel.com>
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

