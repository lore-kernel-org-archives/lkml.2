Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab2IKXzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:55:39 -0400
Received: from [205.233.59.134] ([205.233.59.134]:37409 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab2IKXyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:54:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/18] perf tools: Add memdup function
Date: Tue, 11 Sep 2012 20:53:02 -0300
Message-Id: <1347407590-30960-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347407590-30960-1-git-send-email-acme@infradead.org>
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding memdup function to duplicate region of memory.

  void *memdup(const void *src, size_t len)

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347295819-23177-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/include/linux/string.h |    2 ++
 tools/perf/util/string.c               |   18 +++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/include/linux/string.h b/tools/perf/util/include/linux/string.h
index 3b2f590..6f19c54 100644
--- a/tools/perf/util/include/linux/string.h
+++ b/tools/perf/util/include/linux/string.h
@@ -1 +1,3 @@
 #include <string.h>
+
+void *memdup(const void *src, size_t len);
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 199bc4d..3217059 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -1,5 +1,5 @@
 #include "util.h"
-#include "string.h"
+#include "linux/string.h"
 
 #define K 1024LL
 /*
@@ -335,3 +335,19 @@ char *rtrim(char *s)
 
 	return s;
 }
+
+/**
+ * memdup - duplicate region of memory
+ * @src: memory region to duplicate
+ * @len: memory region length
+ */
+void *memdup(const void *src, size_t len)
+{
+	void *p;
+
+	p = malloc(len);
+	if (p)
+		memcpy(p, src, len);
+
+	return p;
+}
-- 
1.7.9.2.358.g22243

