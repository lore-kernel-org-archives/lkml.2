Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2FSPuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:50:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab2FSPuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:50:16 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 20/23] perf, tool: Adding round_up/round_down macros
Date: Tue, 19 Jun 2012 17:48:11 +0200
Message-Id: <1340120894-9465-21-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding round_up and round_down macros. They will be used
in comming patches.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/include/linux/kernel.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index 1eb804f..b6842c1 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -108,4 +108,14 @@ int eprintf(int level,
 #define pr_debug3(fmt, ...) pr_debugN(3, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_debug4(fmt, ...) pr_debugN(4, pr_fmt(fmt), ##__VA_ARGS__)
 
+/*
+ * This looks more complex than it should be. But we need to
+ * get the type for the ~ right in round_down (it needs to be
+ * as wide as the result!), and we want to evaluate the macro
+ * arguments just once each.
+ */
+#define __round_mask(x, y) ((__typeof__(x))((y)-1))
+#define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
+#define round_down(x, y) ((x) & ~__round_mask(x, y))
+
 #endif
-- 
1.7.7.6

