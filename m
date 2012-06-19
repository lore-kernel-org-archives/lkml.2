Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab2FSSAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:00:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:43316 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2FSSAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:00:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/20] perf lib: Introduce rtrim
Date: Tue, 19 Jun 2012 14:50:08 -0300
Message-Id: <1340128221-17348-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1340128221-17348-1-git-send-email-acme@infradead.org>
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Remove the trailing whitespaces.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8bxozh5lyixgjmziqaxo9675@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/string.c |   22 ++++++++++++++++++++++
 tools/perf/util/util.h   |    2 ++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index d583638..199bc4d 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -313,3 +313,25 @@ int strtailcmp(const char *s1, const char *s2)
 	return 0;
 }
 
+/**
+ * rtrim - Removes trailing whitespace from @s.
+ * @s: The string to be stripped.
+ *
+ * Note that the first trailing whitespace is replaced with a %NUL-terminator
+ * in the given string @s. Returns @s.
+ */
+char *rtrim(char *s)
+{
+	size_t size = strlen(s);
+	char *end;
+
+	if (!size)
+		return s;
+
+	end = s + size - 1;
+	while (end >= s && isspace(*end))
+		end--;
+	*(end + 1) = '\0';
+
+	return s;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 2daaedb..b13c733 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -264,4 +264,6 @@ bool is_power_of_2(unsigned long n)
 
 size_t hex_width(u64 v);
 
+char *rtrim(char *s);
+
 #endif
-- 
1.7.1

