Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1HLQb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:31:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45361 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab1HLQ3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 12:29:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/12] perf probe: Warn when more than one line are given
Date: Fri, 12 Aug 2011 13:29:00 -0300
Message-Id: <1313166544-6209-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1313166544-6209-1-git-send-email-acme@infradead.org>
References: <1313166544-6209-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Check multiple --lines option and print warning informing that only the
first specified --line option is valid.

Changes from the 1st post:

- Accept only the first option instead of the last.
- Fix warning message according to David's comment.
- Mark as a bugfix.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20110811110253.19900.96192.stgit@fedora15
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 5f2a5c7..710ae3d 100644
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
-- 
1.6.2.5

