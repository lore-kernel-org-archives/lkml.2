Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab2KGH13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:27:29 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50186 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2KGH12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:27:28 -0500
X-AuditID: 9c930179-b7c8bae000003559-80-509a0d5b1000
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 6/6] perf tools: Free {branch,mem}_info when freeing hist_entry
Date: Wed,  7 Nov 2012 16:27:14 +0900
Message-Id: <1352273234-28912-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352273234-28912-1-git-send-email-namhyung@kernel.org>
References: <1352273234-28912-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Those data should be free along with the associated hist_entry,
otherwise they'll be leaked.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 52fe4e24502b..50030133fb3b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -470,6 +470,8 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 
 void hist_entry__free(struct hist_entry *he)
 {
+	free(he->branch_info);
+	free(he->mem_info);
 	free(he);
 }
 
-- 
1.7.11.7

