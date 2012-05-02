Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab2EBLks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 07:40:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab2EBLiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 07:38:18 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 06/17] perf, tool: Fix format string for x86-32 compilation
Date: Wed,  2 May 2012 13:37:07 +0200
Message-Id: <1335958638-5160-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1335958638-5160-1-git-send-email-jolsa@redhat.com>
References: <1335958638-5160-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using PRIu64 for printing out u64 nr_events to fix compilation
for x86 32 bits.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-report.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 35c5a59..55901b3 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -304,7 +304,7 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 	if (evname != NULL)
 		ret += fprintf(fp, " of event '%s'", evname);
 
-	ret += fprintf(fp, "\n# Event count (approx.): %lu", nr_events);
+	ret += fprintf(fp, "\n# Event count (approx.): %" PRIu64, nr_events);
 	return ret + fprintf(fp, "\n#\n");
 }
 
-- 
1.7.7.6

