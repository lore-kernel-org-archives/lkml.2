Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab2DTWxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:53:38 -0400
Received: from outmail006.snc4.facebook.com ([66.220.144.140]:54789 "EHLO
	intmgw002.snc4.facebook.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756326Ab2DTWw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:52:57 -0400
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/4] perf: Limit callchains to 127
Date: Fri, 20 Apr 2012 15:41:34 -0700
Message-Id: <1334961696-19580-3-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1334961696-19580-1-git-send-email-asharma@fb.com>
References: <1334961696-19580-1-git-send-email-asharma@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stack depth of 255 seems excessive, given that copy_from_user_nmi()
could be slow.

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
---
 include/linux/perf_event.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ddbb6a9..d1e71c1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -609,7 +609,7 @@ struct perf_guest_info_callbacks {
 #include <linux/sysfs.h>
 #include <asm/local.h>
 
-#define PERF_MAX_STACK_DEPTH		255
+#define PERF_MAX_STACK_DEPTH		127
 
 struct perf_callchain_entry {
 	__u64				nr;
-- 
1.7.8.4

