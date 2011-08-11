Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab1HKL1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 07:27:05 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37517 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab1HKL1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 07:27:00 -0400
X-AuditID: b753bd60-a1479ba0000050a4-2e-4e43bc8215ee
X-AuditID: b753bd60-a1479ba0000050a4-2e-4e43bc8215ee
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v2 5/9] [BUGFIX] perf probe: Warn when more than one line
 are given
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Date: Thu, 11 Aug 2011 20:02:53 +0900
Message-ID: <20110811110253.19900.96192.stgit@fedora15>
In-Reply-To: <20110811110220.19900.54963.stgit@fedora15>
References: <20110811110220.19900.54963.stgit@fedora15>
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

Changes from the 1st post:
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

