Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab1C3Jd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:33:27 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41692 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419Ab1C3JdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:33:19 -0400
X-AuditID: b753bd60-9bb52ba000007e19-45-4d92f8dd29ee
X-AuditID: b753bd60-9bb52ba000007e19-45-4d92f8dd29ee
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 10/12] perf probe: Warn when more than two lines are given
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Wed, 30 Mar 2011 18:26:34 +0900
Message-ID: <20110330092634.2132.45774.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print warning which warns only the last specified --line option is valid.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 tools/perf/builtin-probe.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 2c0e64d..4f3460a 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -134,10 +134,15 @@ static int opt_show_lines(const struct option *opt __used,
 {
 	int ret = 0;
 
-	if (str)
-		ret = parse_line_range_desc(str, &params.line_range);
-	INIT_LIST_HEAD(&params.line_range.line_list);
+	if (!str)
+		return 0;
+
+	if (params.show_lines)
+		pr_warning("Warning: more than two --line option are"
+			   " detected. Only last option is valid.\n");
 	params.show_lines = true;
+	ret = parse_line_range_desc(str, &params.line_range);
+	INIT_LIST_HEAD(&params.line_range.line_list);
 
 	return ret;
 }

