Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab2JaAkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:40:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:35074 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759116Ab2JaAef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:34:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,683,1344236400"; 
   d="scan'208";a="234886222"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 17/32] perf, tools: Handle XBEGIN like a jump
Date: Tue, 30 Oct 2012 17:34:08 -0700
Message-Id: <1351643663-23828-18-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351643663-23828-1-git-send-email-andi@firstfloor.org>
References: <1351643663-23828-1-git-send-email-andi@firstfloor.org>
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
index 7a34dd1..b14d4df 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -401,6 +401,8 @@ static struct ins instructions[] = {
 	{ .name = "testb", .ops  = &mov_ops, },
 	{ .name = "testl", .ops  = &mov_ops, },
 	{ .name = "xadd",  .ops  = &mov_ops, },
+	{ .name = "xbeginl", .ops  = &jump_ops, },
+	{ .name = "xbeginq", .ops  = &jump_ops, },
 };
 
 static int ins__cmp(const void *name, const void *insp)
-- 
1.7.7.6

