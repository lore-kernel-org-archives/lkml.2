Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab0EVRp3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 13:45:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41023 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab0EVRpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 13:45:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/3] perf report: Don't start the TUI if -D is used
Date: Sat, 22 May 2010 14:45:10 -0300
Message-Id: <1274550312-16600-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274550312-16600-1-git-send-email-acme@infradead.org>
References: <1274550312-16600-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

One day we'll have support for the "dump raw trace in ASCII" in the TUI
frontend, but till then, use the tty code.

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a7b8760..2c39bd3 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -484,7 +484,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
-	if (strcmp(input_name, "-") != 0)
+	if (dump_trace)
+		setup_pager();
+	else if (strcmp(input_name, "-") != 0)
 		setup_browser();
 	/*
 	 * Only in the newt browser we are doing integrated annotation,
-- 
1.6.2.5

