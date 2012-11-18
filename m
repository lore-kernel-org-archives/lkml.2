Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab2KROgb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:36:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36567 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2KROaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:16 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/32] perf tests: Check for mkstemp return value in dso-data test
Date: Sun, 18 Nov 2012 11:29:37 -0300
Message-Id: <1353248997-30763-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding check for mkstemp return error value in dso-data test.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352508412-16914-13-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/dso-data.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
index b5198f5..5eaffa2 100644
--- a/tools/perf/tests/dso-data.c
+++ b/tools/perf/tests/dso-data.c
@@ -26,6 +26,10 @@ static char *test_file(int size)
 	unsigned char *buf;
 
 	fd = mkstemp(templ);
+	if (fd < 0) {
+		perror("mkstemp failed");
+		return NULL;
+	}
 
 	buf = malloc(size);
 	if (!buf) {
-- 
1.7.9.2.358.g22243

