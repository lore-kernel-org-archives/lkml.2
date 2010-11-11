Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab0KKTHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:07:16 -0500
Received: from gir.skynet.ie ([193.1.99.77]:38378 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab0KKTHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:07:07 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] mm,compaction: Add COMPACTION_BUILD
Date: Thu, 11 Nov 2010 19:07:03 +0000
Message-Id: <1289502424-12661-3-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289502424-12661-1-git-send-email-mel@csn.ul.ie>
References: <1289502424-12661-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid #ifdef COMPACTION in a following patch, this patch adds
COMPACTION_BUILD that is similar to NUMA_BUILD in operation.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/kernel.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 450092c..c00c5d1 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -826,6 +826,13 @@ struct sysinfo {
 #define NUMA_BUILD 0
 #endif
 
+/* This helps us avoid #ifdef CONFIG_COMPACTION */
+#ifdef CONFIG_COMPACTION
+#define COMPACTION_BUILD 1
+#else
+#define COMPACTION_BUILD 0
+#endif
+
 /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
-- 
1.7.1

