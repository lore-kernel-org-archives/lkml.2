Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab2GTX15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 19:27:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab2GTX0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 19:26:22 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/11] perf tools: dump exclude_{guest,host}, precise_ip header info too
Date: Fri, 20 Jul 2012 17:25:52 -0600
Message-Id: <1342826756-64663-8-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds the attributes to the event line in the header dump.
From:
 event : name = cycles, type = 0, config = 0x0, config1 = 0x0,
      config2 = 0x0, excl_usr = 0, excl_kern = 0, ...
to
  event : name = cycles, type = 0, config = 0x0, config1 = 0x0,
      config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0,
      excl_guest = 0, precise_ip = 0, ...

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/header.c |    6 ++++++
 1 file changed, 6 insertions(+)

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
1.7.10.1

