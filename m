Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab2KJAtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 19:49:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999Ab2KJAtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 19:49:03 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/12] perf tests: Check for mkstemp return value in dso-data test
Date: Sat, 10 Nov 2012 01:46:52 +0100
Message-Id: <1352508412-16914-13-git-send-email-jolsa@redhat.com>
In-Reply-To: <1352508412-16914-1-git-send-email-jolsa@redhat.com>
References: <1352508412-16914-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding check for mkstemp return error value in dso-data test.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/dso-data.c | 4 ++++
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
1.7.11.7

