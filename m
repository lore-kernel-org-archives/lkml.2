Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab2BNVhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:37:52 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46349 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab2BNVhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:37:51 -0500
Subject: [PATCH 1/2] mm: replace COMPACTION_BUILD with
 IS_ENABLED(CONFIG_COMPACTION)
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Wed, 15 Feb 2012 01:37:46 +0400
Message-ID: <20120214213746.26555.95500.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more candidate for replacing with IS_ENABLED() macro.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/kernel.h |    7 -------
 mm/vmscan.c            |    4 ++--
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e834342..1300307 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -733,13 +733,6 @@ extern int __build_bug_on_failed;
 #define NUMA_BUILD 0
 #endif
 
-/* This helps us avoid #ifdef CONFIG_COMPACTION */
-#ifdef CONFIG_COMPACTION
-#define COMPACTION_BUILD 1
-#else
-#define COMPACTION_BUILD 0
-#endif
-
 /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 25ad7ad..4061e91 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -376,7 +376,7 @@ static void set_reclaim_mode(int priority, struct scan_control *sc,
 	 * reclaim/compaction.Depending on the order, we will either set the
 	 * sync mode or just reclaim order-0 pages later.
 	 */
-	if (COMPACTION_BUILD)
+	if (IS_ENABLED(CONFIG_COMPACTION))
 		sc->reclaim_mode = RECLAIM_MODE_COMPACTION;
 	else
 		sc->reclaim_mode = RECLAIM_MODE_LUMPYRECLAIM;
@@ -2255,7 +2255,7 @@ static bool shrink_zones(int priority, struct zonelist *zonelist,
 				continue;
 			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;	/* Let kswapd poll it */
-			if (COMPACTION_BUILD) {
+			if (IS_ENABLED(CONFIG_COMPACTION)) {
 				/*
 				 * If we already have plenty of memory free for
 				 * compaction in this zone, don't free any more.

