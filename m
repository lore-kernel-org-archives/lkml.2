Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab2JCInU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 04:43:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:20952 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab2JCInO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 04:43:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,527,1344236400"; 
   d="scan'208";a="199964586"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCHv2 3/6] staging: rts_pstor: reuse kbasename()
Date: Wed,  3 Oct 2012 11:43:00 +0300
Message-Id: <1349253783-21612-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349253783-21612-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1349253783-21612-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The custom filename function mostly repeats the kernel's kbasename. This patch
simplifies it. The updated filename() will not check for the '\' in the
filenames. It seems redundant in Linux.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rts_pstor/trace.h |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rts_pstor/trace.h b/drivers/staging/rts_pstor/trace.h
index cf60a1b..59c5686 100644
--- a/drivers/staging/rts_pstor/trace.h
+++ b/drivers/staging/rts_pstor/trace.h
@@ -24,26 +24,16 @@
 #ifndef __REALTEK_RTSX_TRACE_H
 #define __REALTEK_RTSX_TRACE_H
 
+#include <linux/string.h>
+
 #define _MSG_TRACE
 
 #ifdef _MSG_TRACE
 static inline char *filename(char *path)
 {
-	char *ptr;
-
 	if (path == NULL)
 		return NULL;
-
-	ptr = path;
-
-	while (*ptr != '\0') {
-		if ((*ptr == '\\') || (*ptr == '/'))
-			path = ptr + 1;
-		
-		ptr++;
-	}
-
-	return path;
+	return kbasename(path);
 }
 
 #define TRACE_RET(chip, ret)   										\
-- 
1.7.10.4

