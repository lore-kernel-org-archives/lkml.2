Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab2GYRlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:41:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:45470 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab2GYRlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:41:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/19] perf tools: Dump exclude_{guest,host}, precise_ip header info too
Date: Wed, 25 Jul 2012 14:41:21 -0300
Message-Id: <1343238094-12481-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1343238094-12481-1-git-send-email-acme@infradead.org>
References: <1343238094-12481-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Adds the attributes to the event line in the header dump.
From:
 event : name = cycles, type = 0, config = 0x0, config1 = 0x0,
      config2 = 0x0, excl_usr = 0, excl_kern = 0, ...
to
  event : name = cycles, type = 0, config = 0x0, config1 = 0x0,
      config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0,
      excl_guest = 0, precise_ip = 0, ...

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1342826756-64663-8-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 5a47aba..3a6d204 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1212,6 +1212,12 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 				attr.exclude_user,
 				attr.exclude_kernel);
 
+		fprintf(fp, ", excl_host = %d, excl_guest = %d",
+				attr.exclude_host,
+				attr.exclude_guest);
+
+		fprintf(fp, ", precise_ip = %d", attr.precise_ip);
+
 		if (nr)
 			fprintf(fp, ", id = {");
 
-- 
1.7.1

