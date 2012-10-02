Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab2JBPBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:01:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:36740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab2JBPBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:01:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,523,1344236400"; 
   d="scan'208";a="218352868"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 2/7] lib: dynamic_debug: reuse kbasename()
Date: Tue,  2 Oct 2012 18:00:55 +0300
Message-Id: <1349190062-13107-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the custom implementation of the functionality similar to kbasename().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index e7f7d99..1db1fc6 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -62,13 +62,6 @@ static LIST_HEAD(ddebug_tables);
 static int verbose = 0;
 module_param(verbose, int, 0644);
 
-/* Return the last part of a pathname */
-static inline const char *basename(const char *path)
-{
-	const char *tail = strrchr(path, '/');
-	return tail ? tail+1 : path;
-}
-
 /* Return the path relative to source root */
 static inline const char *trim_prefix(const char *path)
 {
@@ -154,7 +147,7 @@ static int ddebug_change(const struct ddebug_query *query,
 			/* match against the source filename */
 			if (query->filename &&
 			    strcmp(query->filename, dp->filename) &&
-			    strcmp(query->filename, basename(dp->filename)) &&
+			    strcmp(query->filename, kbasename(dp->filename)) &&
 			    strcmp(query->filename, trim_prefix(dp->filename)))
 				continue;
 
-- 
1.7.10.4

