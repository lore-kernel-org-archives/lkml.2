Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab1GJKmW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 06:42:22 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56971 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab1GJKmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 06:42:19 -0400
X-AuditID: b753bd60-a14abba0000019f4-aa-4e198208ca4a
X-AuditID: b753bd60-a14abba0000019f4-aa-4e198208ca4a
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 5/5] [BUGFIX] perf probe: Warn when more than one line
 are given
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Date: Sun, 10 Jul 2011 19:00:39 +0900
Message-ID: <20110710100039.2550.91743.stgit@fedora15>
In-Reply-To: <20110710100005.2550.83138.stgit@fedora15>
References: <20110710100005.2550.83138.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check multiple --lines option and print warning which
warns only the first specified --line option is valid.

Changes from previous version:
- Accept only the first option instead of the last.
- Fix warning message according to David's comment.
- Mark as a bugfix.


Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
---

 tools/perf/builtin-probe.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 2c0e64d..8cb0ac8 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -134,10 +134,18 @@ static int opt_show_lines(const struct option *opt __used,
 {
 	int ret = 0;
 
-	if (str)
-		ret = parse_line_range_desc(str, &params.line_range);
-	INIT_LIST_HEAD(&params.line_range.line_list);
+	if (!str)
+		return 0;
+
+	if (params.show_lines) {
+		pr_warning("Warning: more than one --line options are"
+			   " detected. Only the first one is valid.\n");
+		return 0;
+	}
+
 	params.show_lines = true;
+	ret = parse_line_range_desc(str, &params.line_range);
+	INIT_LIST_HEAD(&params.line_range.line_list);
 
 	return ret;
 }

