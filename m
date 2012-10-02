Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2JBXtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 19:49:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:15521 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756783Ab2JBXs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 19:48:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,525,1344236400"; 
   d="scan'208";a="229228983"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, x86@vger.kernel.org, eranian@google.com, jolsa@redhat.com,
        a.p.zijlstra@chello.nl, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 18/31] perf, tools: Handle XBEGIN like a jump
Date: Tue,  2 Oct 2012 16:48:38 -0700
Message-Id: <1349221731-15665-19-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
References: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

So that the browser still shows the abort label

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/annotate.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index f0a9103..a34a1ae 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -400,6 +400,8 @@ static struct ins instructions[] = {
 	{ .name = "testb", .ops  = &mov_ops, },
 	{ .name = "testl", .ops  = &mov_ops, },
 	{ .name = "xadd",  .ops  = &mov_ops, },
+	{ .name = "xbeginl", .ops  = &jump_ops, },
+	{ .name = "xbeginq", .ops  = &jump_ops, },
 };
 
 static int ins__cmp(const void *name, const void *insp)
-- 
1.7.7.6

