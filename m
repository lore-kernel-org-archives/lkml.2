Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab2L0JOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 04:14:19 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45445 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2L0JMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 04:12:30 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-16-50dc10fb5acc
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/10] perf sort: Calculate parent column width too
Date: Thu, 27 Dec 2012 18:11:42 +0900
Message-Id: <1356599507-14226-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
References: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When hists__calc_col_len() called, most of column length are refreshed
but it missed parent column.  So if the parent sort key was used along
with other keys rests will be misalinged since parent has no proper
column width.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 965ebf948f2f..9485c7024f5b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -82,6 +82,9 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 		hists__new_col_len(hists, HISTC_DSO, len);
 	}
 
+	if (h->parent)
+		hists__new_col_len(hists, HISTC_PARENT, h->parent->namelen);
+
 	if (h->branch_info) {
 		int symlen;
 		/*
-- 
1.7.11.7

